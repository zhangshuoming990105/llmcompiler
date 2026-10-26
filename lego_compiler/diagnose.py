"""Map assembler diagnostics back to exact regions without guessing from tests."""

import json
import re
from pathlib import Path

from .common import execute, save_json
from .lowering import assemble


def diagnose(prepared, candidate, output, compiler):
    prepared, candidate, output = Path(prepared), Path(candidate).resolve(), Path(output).resolve()
    output.mkdir(parents=True, exist_ok=False)
    plan = json.loads((prepared / "plan.json").read_text())
    response = json.loads((candidate.parent / "response.json").read_text())
    source_map = {}
    rebuilt = assemble(plan, response, "lego-block", source_map)
    if rebuilt != candidate.read_text():
        raise ValueError(
            "Candidate differs from its recorded fragments; cannot assign reliable region locations"
        )
    execution = execute([compiler, "-c", candidate, "-o", output / "candidate.o"])
    (output / "assembler.log").write_text(execution.stdout + execution.stderr)
    save_json(output / "source-map.json", source_map)
    errors, feedback = [], {}
    assembly_lines = candidate.read_text().splitlines()
    fragments = {block["id"]: block["assembly"] for block in response["blocks"]}
    for match in re.finditer(
        re.escape(str(candidate)) + r":(\d+):(\d+): (?:fatal )?error: (.*)", execution.stderr
    ):
        line = int(match[1])
        region = next(
            (name for name, span in source_map.items() if span["start"] <= line <= span["end"]),
            None,
        )
        error = {
            "line": line,
            "column": int(match[2]),
            "message": match[3],
            "region": region,
            "assembly": assembly_lines[line - 1] if 0 < line <= len(assembly_lines) else "",
        }
        errors.append(error)
        if region is not None:
            feedback.setdefault(region, []).append(
                error["message"] + "\nOffending instruction: " + error["assembly"]
            )
    feedback = {
        name: "Assembler diagnostics:\n"
        + "\n".join(messages)
        + "\nPrevious generated fragment:\n"
        + fragments[name]
        for name, messages in feedback.items()
    }
    result = {
        "status": "passed" if execution.returncode == 0 else "assembly_error",
        "exit_code": execution.returncode,
        "errors": errors,
        "mapped_regions": sorted(feedback),
    }
    save_json(output / "result.json", result)
    save_json(output / "feedback.json", feedback)
    return result
