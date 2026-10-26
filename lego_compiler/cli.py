"""Reproducible prepare/generate/assemble/verify stages and benchmark controller."""

import argparse
import json
import shutil
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

from .agents import generate
from .common import ROOT, checked, digest, save_json
from .compile_blocks import FragmentContractError, compile_blocks
from .diagnose import diagnose
from .frontend import prepare
from .lowering import PROTOCOL, SKILL, assemble, prompt, schema
from .partition import partition
from .regions import recompose_c, select_regions
from .target import native_target
from .verify import verify

DEFAULT_MANIFEST = ROOT / "benchmarks/representative/manifest.json"
NEURAL_MODES = ("direct", "lego-bundle", "lego-block", "lego-adaptive")


def positive_int(value):
    number = int(value)
    if number <= 0:
        raise argparse.ArgumentTypeError("must be greater than zero")
    return number


def experiment_modes(value):
    modes = value.split(",")
    if any(mode not in NEURAL_MODES for mode in modes) or len(set(modes)) != len(modes):
        raise argparse.ArgumentTypeError("choose distinct modes from " + ",".join(NEURAL_MODES))
    return value


def load_cases(manifest, selected):
    path = Path(manifest).resolve()
    cases = json.loads(path.read_text())["cases"]
    if selected:
        wanted = set(selected.split(","))
        if wanted - {case["id"] for case in cases}:
            raise ValueError(f"Unknown case IDs: {sorted(wanted - {case['id'] for case in cases})}")
        cases = [case for case in cases if case["id"] in wanted]
    if not cases:
        raise ValueError("Empty benchmark selection")
    for case in cases:
        for key in ("source", "driver"):
            case[key] = str((path.parent / case[key]).resolve())
    return cases


def summarize(results):
    counts = {}
    for row in results:
        key = row["mode"]
        mode = counts.setdefault(key, {"attempted": 0, "passed": 0, "statuses": {}})
        mode["attempted"] += 1
        mode["passed"] += row["status"] == "passed"
        statuses = mode["statuses"]
        statuses[row["status"]] = statuses.get(row["status"], 0) + 1
    return counts


def run(args, control=False):
    cases = load_cases(args.manifest, args.cases)
    output = Path(args.output).resolve()
    modes = (
        ["compiler-control", "rename-control", "split-control"]
        if control
        else args.modes.split(",")
    )
    if not control:
        experiment_modes(args.modes)
    output.mkdir(parents=True, exist_ok=False)
    metadata = {
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "target": native_target(),
        "compiler": checked([args.compiler, "--version"]).splitlines()[0],
        "manifest_sha256": digest(args.manifest),
        "skill_sha256": digest(SKILL),
        "protocol_sha256": digest(PROTOCOL),
        "modes": modes,
        "agent": None if control else args.agent,
        "model": None if control else args.model,
        "split_policy": "all" if control else args.split_policy,
        "jobs": 1 if control else args.jobs,
        "repair_budget": 0,
        "generation_feedback": "none",
        "case_ids": [c["id"] for c in cases],
    }
    metadata["implementation_sha256"] = {
        str(path.relative_to(ROOT)): digest(path)
        for path in sorted((ROOT / "lego_compiler").glob("*.py"))
    }
    metadata["suite_sha256"] = {
        str(path.relative_to(Path(args.manifest).resolve().parent)): digest(path)
        for path in sorted(Path(args.manifest).resolve().parent.rglob("*"))
        if path.is_file() and path.suffix in (".c", ".h", ".json")
    }
    save_json(output / "run.json", metadata)
    results = []
    for case in cases:
        directory = output / case["id"]
        directory.mkdir()
        try:
            plan = prepare(case["source"], directory / "prepared", args.compiler)
            if plan["function"] != case["function"]:
                raise ValueError("Manifest function differs from parsed C definition")
        except (ValueError, RuntimeError, TimeoutError, OSError) as error:
            for mode in modes:
                results.append(
                    {
                        "case": case["id"],
                        "mode": mode,
                        "status": "preparation_error",
                        "error": str(error),
                    }
                )
            save_json(output / "results.json", results)
            save_json(output / "summary.json", summarize(results))
            print(f"{case['id']}: preparation_error: {error}", flush=True)
            continue
        for mode in modes:
            destination = directory / mode
            destination.mkdir()
            row = {
                "case": case["id"],
                "mode": mode,
                "status": "generation_error",
                "origin": case["origin"],
                "plan_sha256": digest(directory / "prepared/plan.json"),
            }
            started = time.monotonic()
            print(f"{case['id']} / {mode}: starting", flush=True)
            try:
                assembly = destination / "candidate.s"
                active_plan = plan
                if control:
                    src = (
                        case["source"]
                        if mode == "compiler-control"
                        else directory / "prepared/renamed.c"
                    )
                    if mode == "split-control":
                        tree = json.loads((directory / "prepared/regions.json").read_text())
                        active_plan = select_regions(plan, tree, lambda node: "split")
                        src = destination / "recomposed.c"
                        src.write_text(recompose_c(active_plan, tree))
                        save_json(destination / "plan.json", active_plan)
                    checked([args.compiler, "-std=c11", "-O0", "-S", src, "-o", assembly])
                else:
                    response = None
                    usage = []
                    if mode == "lego-adaptive":
                        row["status"] = "partition_error"
                        active_plan = partition(
                            directory / "prepared",
                            destination / "partition",
                            policy=args.split_policy,
                            backend=args.agent,
                            model=args.model,
                            timeout=args.agent_timeout,
                            max_decisions=args.decision_limit,
                        )
                        row["selected_regions"] = len(active_plan["blocks"])
                        row["selected_plan_sha256"] = digest(destination / "partition/plan.json")
                        row["status"] = "structural_error"
                        structural_asm = destination / "partition/structural-control.s"
                        checked(
                            [
                                args.compiler,
                                "-std=c11",
                                "-O0",
                                "-S",
                                destination / "partition/recomposed.c",
                                "-o",
                                structural_asm,
                            ]
                        )
                        structure = verify(
                            case["source"],
                            case["driver"],
                            structural_asm,
                            case["function"],
                            destination / "structure-check",
                            args.compiler,
                            timeout=args.test_timeout,
                        )
                        row["structural_check"] = structure
                        if structure["status"] != "passed":
                            raise ValueError(
                                "Control decomposition failed its independent C differential check"
                            )
                        row["status"] = "generation_error"
                    if mode in ("lego-block", "lego-adaptive"):
                        response, usage = compile_blocks(
                            active_plan,
                            Path(case["source"]).read_text(),
                            destination,
                            backend=args.agent,
                            model=args.model,
                            timeout=args.agent_timeout,
                            jobs=args.jobs,
                        )
                    else:
                        response, info = generate(
                            args.agent,
                            prompt(plan, Path(case["source"]).read_text(), mode),
                            schema(mode),
                            destination / "generation",
                            model=args.model,
                            timeout=args.agent_timeout,
                        )
                        usage.append(info)
                    row["generation"] = usage
                    save_json(destination / "response.json", response)
                    row["status"] = "contract_error"
                    assembly.write_text(assemble(active_plan, response, mode))
                    if mode != "direct":
                        fragments = destination / "fragments"
                        fragments.mkdir(exist_ok=True)
                        for block in response["blocks"]:
                            (fragments / (block["id"] + ".s")).write_text(block["assembly"] + "\n")
                row["status"] = "verification_error"
                row.update(
                    verify(
                        case["source"],
                        case["driver"],
                        assembly,
                        case["function"],
                        destination / "verification",
                        args.compiler,
                        timeout=args.test_timeout,
                    )
                )
            except (ValueError, RuntimeError, TimeoutError, OSError) as error:
                if isinstance(error, TimeoutError) and row["status"] == "generation_error":
                    row["status"] = "generation_timeout"
                if isinstance(error, FragmentContractError):
                    row["status"] = "contract_error"
                row["error"] = str(error)
            row["total_seconds"] = time.monotonic() - started
            save_json(destination / "result.json", row)
            results.append(row)
            save_json(output / "results.json", results)
            save_json(output / "summary.json", summarize(results))
            print(f"{case['id']} / {mode}: {row['status']}", flush=True)
    print(json.dumps(summarize(results), indent=2))
    return 0 if all(row["status"] == "passed" for row in results) else 1


def main():
    parser = argparse.ArgumentParser(description="Inspectable LEGO neural compiler pilot")
    compiler = "/usr/bin/clang" if sys.platform == "darwin" else shutil.which("clang") or "clang"
    parser.add_argument("--compiler", default=compiler)
    sub = parser.add_subparsers(dest="command", required=True)
    prepare_parser = sub.add_parser(
        "prepare", help="Extract bindings, layouts, and source-preserving blocks"
    )
    prepare_parser.add_argument("source")
    prepare_parser.add_argument("--output", required=True)
    prompt_parser = sub.add_parser("prompt", help="Print a self-contained lowering prompt")
    prompt_parser.add_argument("prepared")
    prompt_parser.add_argument(
        "--mode", choices=("direct", "lego-bundle", "lego-block"), default="lego-bundle"
    )
    prompt_parser.add_argument("--block")
    assemble_parser = sub.add_parser("assemble", help="Validate and merge an agent JSON response")
    assemble_parser.add_argument("prepared")
    assemble_parser.add_argument("response")
    assemble_parser.add_argument(
        "--mode", choices=("direct", "lego-bundle", "lego-block"), default="lego-bundle"
    )
    assemble_parser.add_argument("--output", required=True)
    verify_parser = sub.add_parser(
        "verify", help="Replay differential tests against saved candidate assembly"
    )
    verify_parser.add_argument("source")
    verify_parser.add_argument("driver")
    verify_parser.add_argument("assembly")
    verify_parser.add_argument("--function", required=True)
    verify_parser.add_argument("--output", required=True)
    verify_parser.add_argument("--test-timeout", type=positive_int, default=10)
    select_parser = sub.add_parser(
        "select", help="Algorithm 2 keep/split selection, with recursive control decomposition"
    )
    select_parser.add_argument("prepared")
    select_parser.add_argument("--output", required=True)
    select_parser.add_argument("--policy", choices=("llm", "all", "keep"), default="llm")
    select_parser.add_argument("--agent", choices=("codex", "pi"), default="codex")
    select_parser.add_argument("--model")
    select_parser.add_argument("--agent-timeout", type=positive_int, default=300)
    select_parser.add_argument("--decision-limit", type=positive_int, default=10000)
    select_parser.add_argument("--decisions", help="JSON object mapping region IDs to keep/split")
    select_parser.add_argument(
        "--refine", default="", help="Comma-separated kept region IDs to split one level further"
    )
    select_parser.add_argument(
        "--feedback", help="Prior diagnostics file supplied to LLM decisions"
    )
    lower_parser = sub.add_parser(
        "lower", help="Lower a selected partition; optionally reuse matching prior leaves"
    )
    lower_parser.add_argument("prepared")
    lower_parser.add_argument("--output", required=True)
    lower_parser.add_argument("--agent", choices=("codex", "pi"), default="codex")
    lower_parser.add_argument("--model")
    lower_parser.add_argument("--agent-timeout", type=positive_int, default=300)
    lower_parser.add_argument("--jobs", type=positive_int, default=1)
    lower_parser.add_argument(
        "--reuse", help="Prior lowering directory, requiring identical leaf prompts/contracts"
    )
    lower_parser.add_argument(
        "--feedback", help="JSON mapping selected region IDs to assembler/observed diagnostics"
    )
    diagnose_parser = sub.add_parser(
        "diagnose", help="Assemble a candidate and map errors to its recorded regions"
    )
    diagnose_parser.add_argument("prepared")
    diagnose_parser.add_argument("candidate")
    diagnose_parser.add_argument("--output", required=True)
    for name in ("run", "selfcheck"):
        command = sub.add_parser(name)
        command.add_argument("--manifest", default=str(DEFAULT_MANIFEST))
        command.add_argument("--cases", help="Comma-separated IDs; default all six pilot cases")
        command.add_argument(
            "--output", required=True, help="New directory; existing results are never overwritten"
        )
        command.add_argument("--test-timeout", type=positive_int, default=10)
        if name == "run":
            command.add_argument("--agent", choices=("codex", "pi"), default="codex")
            command.add_argument(
                "--model", help="Omit to preserve the existing agent CLI model configuration"
            )
            command.add_argument("--modes", type=experiment_modes, default="direct,lego-bundle")
            command.add_argument("--agent-timeout", type=positive_int, default=300)
            command.add_argument("--split-policy", choices=("llm", "all", "keep"), default="llm")
            command.add_argument("--decision-limit", type=positive_int, default=10000)
            command.add_argument("--jobs", type=positive_int, default=1)
    args = parser.parse_args()
    try:
        if args.command in ("run", "selfcheck"):
            code = run(args, args.command == "selfcheck")
        elif args.command == "prepare":
            if Path(args.output).exists():
                raise ValueError("Use a new output directory")
            plan = prepare(args.source, args.output, args.compiler)
            print(
                json.dumps(
                    {
                        "function": plan["function"],
                        "blocks": len(plan["blocks"]),
                        "target": plan["abi"]["target"],
                    }
                )
            )
            code = 0
        elif args.command == "verify":
            paths = [Path(path).resolve() for path in (args.source, args.driver, args.assembly)]
            result = verify(
                *paths, args.function, args.output, args.compiler, timeout=args.test_timeout
            )
            print(json.dumps(result, indent=2))
            code = 0 if result["status"] == "passed" else 1
        elif args.command == "select":
            selected = partition(
                args.prepared,
                args.output,
                policy=args.policy,
                backend=args.agent,
                model=args.model,
                timeout=args.agent_timeout,
                max_decisions=args.decision_limit,
                decisions=json.loads(Path(args.decisions).read_text()) if args.decisions else None,
                refine=[item for item in args.refine.split(",") if item],
                feedback=Path(args.feedback).read_text() if args.feedback else None,
            )
            print(
                json.dumps(
                    {
                        "blocks": len(selected["blocks"]),
                        "decisions": len(selected["split_decisions"]),
                        "depth": max(item["depth"] for item in selected["split_decisions"]),
                    }
                )
            )
            code = 0
        elif args.command == "lower":
            prepared = Path(args.prepared).resolve()
            output = Path(args.output).resolve()
            output.mkdir(parents=True, exist_ok=False)
            plan = json.loads((prepared / "plan.json").read_text())
            _, metadata = compile_blocks(
                plan,
                (prepared / "source.c").read_text(),
                output,
                backend=args.agent,
                model=args.model,
                timeout=args.agent_timeout,
                jobs=args.jobs,
                reuse=args.reuse,
                feedback=json.loads(Path(args.feedback).read_text()) if args.feedback else None,
            )
            print(
                json.dumps(
                    {
                        "regions": len(metadata),
                        "fresh": sum(not item["reused"] for item in metadata),
                        "reused": sum(item["reused"] for item in metadata),
                    }
                )
            )
            code = 0
        elif args.command == "diagnose":
            result = diagnose(args.prepared, args.candidate, args.output, args.compiler)
            print(
                json.dumps(
                    {
                        "status": result["status"],
                        "errors": len(result["errors"]),
                        "affected_regions": len(result["mapped_regions"]),
                        "details": str(Path(args.output).resolve() / "result.json"),
                    },
                    indent=2,
                )
            )
            code = 0 if result["status"] == "passed" else 1
        else:
            prepared = Path(args.prepared)
            plan = json.loads((prepared / "plan.json").read_text())
            if args.command == "prompt":
                if args.mode == "lego-block" and not args.block:
                    raise ValueError("lego-block requires --block")
                print(prompt(plan, (prepared / "source.c").read_text(), args.mode, args.block))
            else:
                response = json.loads(Path(args.response).read_text())
                Path(args.output).write_text(assemble(plan, response, args.mode))
            code = 0
    except (ValueError, RuntimeError, OSError, TimeoutError) as error:
        print(str(error), file=sys.stderr)
        code = 2
    sys.exit(code)
