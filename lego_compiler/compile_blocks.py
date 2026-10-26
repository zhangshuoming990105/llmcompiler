"""Independent regional lowering, with explicit reuse of prior compatible leaves."""

import copy
import hashlib
import json
import shutil
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from .agents import decode_response, generate
from .common import save_json
from .lowering import assemble, prompt, schema, validate_fragment


class FragmentContractError(ValueError):
    """A generated region violates its declared composition interface."""


def validate_response(plan, block, answer):
    if (
        not isinstance(answer, dict)
        or set(answer) != {"blocks"}
        or not isinstance(answer["blocks"], list)
        or len(answer["blocks"]) != 1
        or not isinstance(answer["blocks"][0], dict)
        or answer["blocks"][0].get("id") != block["id"]
    ):
        raise FragmentContractError(f"Region {block['id']} returned unexpected IDs")
    fragment = answer["blocks"][0]
    if set(fragment) != {"id", "assembly"} or not isinstance(fragment["assembly"], str):
        raise FragmentContractError(f"Region {block['id']} returned an invalid fragment")
    try:
        validate_fragment(plan, block, fragment["assembly"])
    except ValueError as error:
        raise FragmentContractError(f"Region {block['id']}: {error}") from error
    return fragment


def reusable_response(
    previous, plan, block, message, contract_digest, response_schema, backend, model
):
    """A partial, corrupt, or invalid previous attempt is a cache miss."""
    if previous is None:
        return None
    try:
        metadata = json.loads((previous / "invocation.json").read_text())
        if (
            not isinstance(metadata, dict)
            or metadata.get("backend") != backend
            or metadata.get("requested_model") != model
            or metadata.get("tools_used") != []
            or metadata.get("exit_code") != 0
            or not isinstance(metadata.get("seconds"), (int, float))
        ):
            return None
        previous_prompt = (previous / "prompt.txt").read_text()
        compatible = previous_prompt == message or (
            not block.get("diagnostic") and metadata.get("contract_sha256") == contract_digest
        )
        if not compatible or json.loads((previous / "schema.json").read_text()) != response_schema:
            return None
        answer, _ = decode_response((previous / "response.json").read_text())
        validate_response(plan, block, answer)
        return answer, metadata
    except (OSError, ValueError, KeyError, TypeError):
        return None


def compile_blocks(
    plan,
    source,
    destination,
    *,
    backend,
    model=None,
    timeout=300,
    jobs=1,
    reuse=None,
    feedback=None,
):
    destination = Path(destination).resolve()
    if jobs < 1:
        raise ValueError("jobs must be positive")
    base_messages = {
        block["id"]: prompt(plan, source, "lego-block", block["id"]) for block in plan["blocks"]
    }
    if feedback:
        plan = copy.deepcopy(plan)
        known = {block["id"] for block in plan["blocks"]}
        if (
            not isinstance(feedback, dict)
            or set(feedback) - known
            or not all(isinstance(value, str) for value in feedback.values())
        ):
            raise ValueError("Feedback must map selected region IDs to diagnostic strings")
        for block in plan["blocks"]:
            if block["id"] in feedback:
                block["diagnostic"] = feedback[block["id"]]
        save_json(destination / "feedback.json", feedback)
    response_schema = schema("lego-block")
    messages = {
        block["id"]: prompt(plan, source, "lego-block", block["id"])
        if block.get("diagnostic")
        else base_messages[block["id"]]
        for block in plan["blocks"]
    }

    def lower(block):
        message = messages[block["id"]]
        contract_digest = hashlib.sha256(base_messages[block["id"]].encode()).hexdigest()
        output = destination / block["id"]
        previous = Path(reuse) / block["id"] if reuse else None
        answer, information = None, None
        cached = reusable_response(
            previous, plan, block, message, contract_digest, response_schema, backend, model
        )
        if cached is not None:
            answer, metadata = cached
            information = dict(metadata)
            information.update(
                reused_from=str(previous.resolve()),
                reused_generation_seconds=metadata.get(
                    "reused_generation_seconds", metadata["seconds"]
                ),
                seconds=0,
                reused=True,
            )
            output.mkdir(parents=True, exist_ok=False)
            for filename in (
                "prompt.txt",
                "schema.json",
                "raw-response.txt",
                "events.jsonl",
                "stderr.txt",
            ):
                if (previous / filename).exists():
                    shutil.copy2(previous / filename, output / filename)
            save_json(output / "response.json", answer)
        if answer is None:
            answer, information = generate(
                backend, message, response_schema, output, model=model, timeout=timeout
            )
            information["reused"] = False
        information["contract_sha256"] = contract_digest
        save_json(output / "invocation.json", information)
        try:
            fragment = validate_response(plan, block, answer)
        except FragmentContractError as error:
            save_json(output / "validation.json", {"status": "failed", "error": str(error)})
            raise
        save_json(output / "validation.json", {"status": "passed"})
        print(f"  {block['id']}: {'reused' if information['reused'] else 'lowered'}", flush=True)
        return fragment, information

    # Inputs and the ABI plan are frozen. Every worker writes a separate folder;
    # executor.map returns in source order irrespective of completion order.
    with ThreadPoolExecutor(max_workers=jobs) as executor:
        results = list(executor.map(lower, plan["blocks"]))
    response = {"blocks": [fragment for fragment, _ in results]}
    metadata = [information for _, information in results]
    save_json(destination / "response.json", response)
    save_json(destination / "generation.json", metadata)
    source_map = {}
    (destination / "candidate.s").write_text(assemble(plan, response, "lego-block", source_map))
    save_json(destination / "source-map.json", source_map)
    fragments = destination / "fragments"
    fragments.mkdir(exist_ok=True)
    for block in response["blocks"]:
        (fragments / (block["id"] + ".s")).write_text(block["assembly"] + "\n")
    return response, metadata
