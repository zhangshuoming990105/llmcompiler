"""Use installed agent CLIs and their existing auth, without provider whitelists."""

import json
import re
import time
from pathlib import Path

from .common import execute, save_json


def decode_response(raw):
    """Extract a complete final JSON document; retain raw text for provenance."""
    match = re.fullmatch(r"\s*```(?:json)?\s*\n([\s\S]*?)\n```\s*", raw)
    try:
        return json.loads(match.group(1) if match else raw), bool(match)
    except json.JSONDecodeError as original_error:
        # Some CLI backends prepend prose despite the output-schema request.
        # Accept only a complete object at the end, never repair JSON or assembly.
        decoder = json.JSONDecoder()
        for start in re.finditer(r"\{", raw):
            try:
                value, end = decoder.raw_decode(raw, start.start())
            except json.JSONDecodeError:
                continue
            if raw[end:].strip() in ("", "```"):
                return value, True
        raise original_error


def generate(backend, prompt, response_schema, directory, *, model=None, timeout=300):
    directory = Path(directory).resolve()
    directory.mkdir(parents=True, exist_ok=False)
    (directory / "prompt.txt").write_text(prompt)
    save_json(directory / "schema.json", response_schema)
    response_file = directory / "response.json"
    if backend == "codex":
        command = [
            "codex",
            "exec",
            "--json",
            "--ephemeral",
            "--sandbox",
            "read-only",
            "--skip-git-repo-check",
            "--cd",
            str(directory),
            "--output-schema",
            str(directory / "schema.json"),
            "--output-last-message",
            str(response_file),
        ]
        if model:
            command += ["--model", model]
        command += ["-"]
        stdin = prompt
    elif backend == "pi":
        command = [
            "pi",
            "--print",
            "--mode",
            "json",
            "--no-session",
            "--no-tools",
            "--no-extensions",
            "--no-mcp",
            "--no-skills",
            "--no-prompt-templates",
            "--no-context-files",
        ]
        if model:
            command += ["--model", model]
        # Long functions can exceed the operating system's argv size limit.
        stdin = prompt
    else:
        raise ValueError(f"Unsupported agent backend: {backend}")
    version = execute([backend, "--version"]).stdout.strip()
    metadata = {
        "backend": backend,
        "cli_version": version,
        "requested_model": model,
        "model_selection": "explicit" if model else "existing CLI configuration",
        "timeout_seconds": timeout,
        "prompt_transport": "stdin",
        "tool_policy": "no tools; reject traces containing tool calls",
    }
    save_json(directory / "invocation.json", metadata)
    started = time.monotonic()
    try:
        result = execute(command, cwd=directory, timeout=timeout, input=stdin)
    except (TimeoutError, KeyboardInterrupt) as error:
        (directory / "events.jsonl").write_text(getattr(error, "stdout", ""))
        (directory / "stderr.txt").write_text(getattr(error, "stderr", ""))
        metadata.update(
            seconds=time.monotonic() - started,
            status="timeout" if isinstance(error, TimeoutError) else "interrupted",
        )
        save_json(directory / "invocation.json", metadata)
        raise
    (directory / "events.jsonl").write_text(result.stdout)
    (directory / "stderr.txt").write_text(result.stderr)
    usage, models, tools_used = [], set(), []
    last_text = None
    for line in result.stdout.splitlines():
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        if backend == "codex":
            item = event.get("item", {})
            if item.get("type") in (
                "command_execution",
                "file_change",
                "mcp_tool_call",
                "web_search",
            ):
                tools_used.append(item.get("type"))
            if event.get("type") == "turn.completed":
                usage.append(event.get("usage", {}))
            if item.get("type") == "agent_message":
                last_text = item.get("text")
        else:
            message = event.get("message", {})
            if event.get("type") == "tool_execution_start":
                tools_used.append(event.get("toolName", "unknown"))
            if event.get("type") == "message_end" and message.get("role") == "assistant":
                last_text = "".join(
                    part.get("text", "")
                    for part in message.get("content", [])
                    if part.get("type") == "text"
                )
                if message.get("usage"):
                    usage.append(message["usage"])
                if message.get("model"):
                    models.add(message["model"])
                tools_used += [
                    p.get("name", "unknown")
                    for p in message.get("content", [])
                    if p.get("type") == "toolCall"
                ]
    metadata.update(
        seconds=time.monotonic() - started,
        exit_code=result.returncode,
        usage=usage,
        reported_models=sorted(models),
        tools_used=tools_used,
    )
    save_json(directory / "invocation.json", metadata)
    if result.returncode:
        raise RuntimeError(f"{backend} exited {result.returncode}; see {directory / 'stderr.txt'}")
    if tools_used:
        raise ValueError(
            f"Generation used tools; excluded to prevent reference leakage: {tools_used}"
        )
    if backend == "pi" or not response_file.exists():
        if not last_text:
            raise ValueError("Agent returned no final answer")
        response_file.write_text(last_text)
    raw = response_file.read_text()
    (directory / "raw-response.txt").write_text(raw)
    response, normalized = decode_response(raw)
    if not isinstance(response, dict):
        raise ValueError("Agent response must be a JSON object")
    metadata["output_normalization"] = (
        "extracted final JSON document from response envelope" if normalized else "none"
    )
    save_json(response_file, response)
    save_json(directory / "invocation.json", metadata)
    return response, metadata
