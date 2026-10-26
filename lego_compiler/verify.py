"""Build and execute differential tests outside the generation context."""

import json
import time
from pathlib import Path

from .common import digest, execute, save_json


def verify(source, driver, assembly, function, output, compiler, *, timeout=10):
    output = Path(output).resolve()
    output.mkdir(parents=True, exist_ok=False)
    result = {
        "status": "build_error",
        "source_sha256": digest(source),
        "driver_sha256": digest(driver),
        "assembly_sha256": digest(assembly),
        "commands": [],
    }
    started = time.monotonic()
    commands = [
        [
            compiler,
            "-std=c11",
            "-O0",
            "-fno-lto",
            f"-D{function}=reference",
            "-c",
            str(source),
            "-o",
            str(output / "reference.o"),
        ],
        [
            compiler,
            "-std=c11",
            "-O0",
            "-fno-lto",
            str(driver),
            str(assembly),
            str(output / "reference.o"),
            "-o",
            str(output / "check"),
        ],
    ]
    try:
        for index, command in enumerate(commands):
            execution = execute(command)
            result["commands"].append(command)
            (output / f"build_{index}.log").write_text(execution.stdout + execution.stderr)
            if execution.returncode:
                result["error"] = execution.stderr[-6000:]
                return result
        execution = execute([output / "check"], timeout=timeout)
        (output / "stdout.txt").write_text(execution.stdout)
        (output / "stderr.txt").write_text(execution.stderr)
        result["exit_code"] = execution.returncode
        if execution.returncode < 0:
            result.update(status="crash", signal=-execution.returncode)
        else:
            try:
                checks = json.loads(execution.stdout)
                if (
                    not isinstance(checks, dict)
                    or type(checks.get("checks")) is not int
                    or checks["checks"] <= 0
                    or type(checks.get("failures")) is not int
                    or not 0 <= checks["failures"] <= checks["checks"]
                ):
                    raise ValueError("No valid test count")
                # Driver output must not replace controller-owned provenance.
                result.update(checks=checks["checks"], failures=checks["failures"])
                result["status"] = (
                    "passed"
                    if execution.returncode == 0 and checks["failures"] == 0
                    else "mismatch"
                )
            except (ValueError, AttributeError):
                result.update(status="invalid_test_output", error=execution.stdout[-2000:])
    except TimeoutError as error:
        (output / "stdout.txt").write_text(getattr(error, "stdout", ""))
        (output / "stderr.txt").write_text(getattr(error, "stderr", ""))
        result.update(status="timeout", error=str(error))
    finally:
        result["seconds"] = time.monotonic() - started
        save_json(output / "result.json", result)
    return result
