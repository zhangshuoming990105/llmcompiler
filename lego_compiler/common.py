"""Small, dependency-free helpers shared by the experiment stages."""

import hashlib
import json
import os
import signal
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class ProcessTimeout(TimeoutError):
    def __init__(self, message, stdout, stderr):
        super().__init__(message)
        self.stdout = stdout
        self.stderr = stderr


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save_json(path, data):
    """Publish a complete snapshot, leaving the previous file intact on failure."""
    path = Path(path)
    payload = json.dumps(data, indent=2, ensure_ascii=False) + "\n"
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            dir=path.parent,
            prefix=f".{path.name}.",
            suffix=".tmp",
            delete=False,
        ) as stream:
            temporary = Path(stream.name)
            stream.write(payload)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


def execute(command, *, cwd=None, timeout=30, input=None):
    """Bound the entire process group, including agent-launched child processes."""
    with subprocess.Popen(
        [str(x) for x in command],
        cwd=cwd,
        text=True,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        start_new_session=True,
    ) as process:
        try:
            stdout, stderr = process.communicate(input, timeout=timeout)
        except subprocess.TimeoutExpired:
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            stdout, stderr = process.communicate()
            raise ProcessTimeout(
                f"Command timed out after {timeout}s: {command[0]}", stdout, stderr
            )
        except BaseException as error:
            # Ctrl-C must not leave an agent or its subprocesses running.
            if process.poll() is None:
                try:
                    os.killpg(process.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
            stdout, stderr = process.communicate()
            error.stdout, error.stderr = stdout, stderr
            raise
    return subprocess.CompletedProcess(command, process.returncode, stdout, stderr)


def checked(command, **kwargs):
    result = execute(command, **kwargs)
    if result.returncode:
        raise RuntimeError(f"Command failed ({result.returncode}): {command}\n{result.stderr}")
    return result.stdout
