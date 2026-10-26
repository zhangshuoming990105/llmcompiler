"""Persist adaptive keep/split decisions and the executable control skeleton."""

import json
import shutil
from pathlib import Path

from .agents import generate
from .common import save_json
from .regions import recompose_c, select_regions

DECISION_SCHEMA = {
    "type": "object",
    "properties": {
        "decision": {"type": "string", "enum": ["keep", "split"]},
        "reason": {"type": "string"},
    },
    "required": ["decision", "reason"],
    "additionalProperties": False,
}


def partition(
    prepared,
    output,
    *,
    policy="llm",
    backend="codex",
    model=None,
    timeout=300,
    decisions=None,
    refine=(),
    feedback=None,
    max_decisions=10000,
):
    prepared, output = Path(prepared).resolve(), Path(output).resolve()
    output.mkdir(parents=True, exist_ok=False)
    plan = json.loads((prepared / "plan.json").read_text())
    tree = json.loads((prepared / "regions.json").read_text())
    fixed = {item["id"]: item["decision"] for item in plan.get("split_decisions", [])}
    fixed.update(decisions or {})
    for identifier in refine:
        selected_ids = (
            {block["id"] for block in plan["blocks"]} if "split_decisions" in plan else set()
        )
        if (
            identifier not in selected_ids
            or identifier not in tree["nodes"]
            or not tree["nodes"][identifier]["expansion"]
        ):
            raise ValueError(f"Cannot refine region: {identifier}")
        fixed[identifier] = "split"

    def decide(node):
        if node["id"] in fixed:
            return {
                "decision": fixed[node["id"]],
                "reason": "saved or explicitly supplied decision",
            }
        if policy != "llm":
            return {
                "decision": "split" if policy == "all" else "keep",
                "reason": f"{policy} structural control policy",
            }
        message = """Apply Algorithm 2 (SelectControlBlocks) of LEGO-Compiler, arXiv:2505.20356v1.
Choose keep if this region is a manageable unit for accurate independent C-to-assembly
translation; choose split if its control/data complexity or expected output size makes
finer composable parts useful. Splitting exposes outermost control parts; loop/branch
bodies may be split recursively on later visits. Straight-line sequences can also
be subdivided. Prefer the largest region you can responsibly lower. Straight-line
fixed-width arithmetic with explicit bindings usually remains a useful single unit;
do not proactively split it into tiny pieces just because subdivision is possible.
Actual compilation/test failures can trigger finer splits later. Do not use a fixed
line-count rule. Do not translate the region yet.
All inputs are provided. Use no tools. Return only the requested JSON with one short
reason describing observable complexity or an output-budget concern, not hidden reasoning.
The downstream translator gets canonical stack bindings and only this region's source.
"""
        message += "\nTarget: " + plan["abi"]["target"]
        message += "\nRegion: " + node["id"] + " (" + node["kind"] + ")\n" + node["source"]
        message += "\nBinding types: " + json.dumps(
            {
                binding["name"]: binding["c_type"]
                for binding in plan["bindings"]
                if binding["name"] in node["symbol_names"]
            }
        )
        message += "\nImmediate split components: " + json.dumps(
            [
                {"kind": tree["nodes"][step["id"]]["kind"], "id": step["id"]}
                if step["kind"] == "region"
                else step
                for step in node["expansion"]
            ]
        )
        if feedback:
            message += (
                "\nPrior observed diagnostics (not proof of which block is wrong):\n" + feedback
            )
        message += "\nRequired JSON schema:\n" + json.dumps(DECISION_SCHEMA)
        response, _ = generate(
            backend,
            message,
            DECISION_SCHEMA,
            output / "decisions" / node["id"],
            model=model,
            timeout=timeout,
        )
        return response

    selected = select_regions(plan, tree, decide, max_decisions=max_decisions)
    selected["selection_policy"] = policy
    save_json(output / "plan.json", selected)
    save_json(output / "split-decisions.json", selected["split_decisions"])
    (output / "recomposed.c").write_text(recompose_c(selected, tree))
    for name in ("source.c", "renamed.c", "layout.json", "regions.json"):
        shutil.copy2(prepared / name, output / name)
    return selected
