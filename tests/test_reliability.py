import argparse
import json
import signal
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import MagicMock, patch

from lego_compiler.cli import experiment_modes, positive_int
from lego_compiler.common import ROOT, digest, execute, save_json
from lego_compiler.compile_blocks import reusable_response
from lego_compiler.lowering import schema
from lego_compiler.verify import verify


class SnapshotTests(unittest.TestCase):
    def test_failed_replace_preserves_the_previous_snapshot(self):
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "state.json"
            save_json(path, {"state": "previous"})
            with patch("lego_compiler.common.os.replace", side_effect=OSError("disk error")):
                with self.assertRaises(OSError):
                    save_json(path, {"state": "new"})
            self.assertEqual(json.loads(path.read_text()), {"state": "previous"})
            self.assertEqual(list(Path(temporary).glob("*.tmp")), [])

    def test_interrupt_stops_the_owned_process_group(self):
        process = MagicMock()
        process.pid = 123456
        process.poll.return_value = None
        process.communicate.side_effect = [KeyboardInterrupt(), ("partial", "diagnostic")]
        with (
            patch("lego_compiler.common.subprocess.Popen") as launch,
            patch("lego_compiler.common.os.killpg") as kill,
        ):
            launch.return_value.__enter__.return_value = process
            with self.assertRaises(KeyboardInterrupt) as raised:
                execute(["example-child"])
        kill.assert_called_once_with(123456, signal.SIGKILL)
        self.assertEqual(raised.exception.stdout, "partial")


class CacheRecoveryTests(unittest.TestCase):
    def test_incomplete_or_invalid_cache_is_not_reused(self):
        plan = {"abi": {"target": "arm64-macos", "return_label": "L_return", "frame_size": 16}}
        block = {"id": "b000", "label_prefix": "L_b000_"}
        for damage in ("metadata", "missing-response", "invalid-assembly"):
            with self.subTest(damage=damage), tempfile.TemporaryDirectory() as temporary:
                previous = Path(temporary)
                save_json(
                    previous / "invocation.json",
                    {
                        "backend": "pi",
                        "requested_model": None,
                        "tools_used": [],
                        "exit_code": 0,
                        "seconds": 1,
                    },
                )
                save_json(previous / "schema.json", schema("lego-block"))
                (previous / "prompt.txt").write_text("task")
                save_json(
                    previous / "response.json", {"blocks": [{"id": "b000", "assembly": "nop"}]}
                )
                args = (previous, plan, block, "task", "digest", schema("lego-block"), "pi", None)
                self.assertIsNotNone(reusable_response(*args))
                if damage == "metadata":
                    (previous / "invocation.json").write_text("{")
                elif damage == "missing-response":
                    (previous / "response.json").unlink()
                else:
                    save_json(
                        previous / "response.json", {"blocks": [{"id": "b000", "assembly": "ret"}]}
                    )
                self.assertIsNone(reusable_response(*args))


class VerificationReportTests(unittest.TestCase):
    def report(self, payload):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            paths = [root / name for name in ("source.c", "driver.c", "candidate.s")]
            for path in paths:
                path.write_text("fixture")
            responses = [subprocess.CompletedProcess([], 0, "", "")] * 2
            responses.append(subprocess.CompletedProcess([], 0, json.dumps(payload), ""))
            with patch("lego_compiler.verify.execute", side_effect=responses):
                result = verify(*paths, "f", root / "verification", "clang")
            self.assertEqual(result["source_sha256"], digest(paths[0]))
            self.assertEqual(len(result["commands"]), 2)
            return result

    def test_driver_cannot_replace_provenance(self):
        result = self.report(
            {"checks": 1, "failures": 0, "source_sha256": "forged", "commands": []}
        )
        self.assertEqual(result["status"], "passed")

    def test_invalid_counts_are_not_successes(self):
        for counts in (
            {"checks": True, "failures": 0},
            {"checks": 1, "failures": -1},
            {"checks": 1, "failures": 2},
            {"checks": 0, "failures": 0},
        ):
            with self.subTest(counts=counts):
                self.assertEqual(self.report(counts)["status"], "invalid_test_output")


class CommandValidationTests(unittest.TestCase):
    def test_nonpositive_limits_and_control_modes_are_rejected(self):
        for value in ("0", "-1"):
            with self.assertRaises(argparse.ArgumentTypeError):
                positive_int(value)
        for value in ("compiler-control", "direct,direct", "unknown"):
            with self.assertRaises(argparse.ArgumentTypeError):
                experiment_modes(value)

    def test_invalid_mode_creates_no_output_directory(self):
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / "run"
            result = subprocess.run(
                [
                    sys.executable,
                    "-m",
                    "lego_compiler",
                    "run",
                    "--modes",
                    "compiler-control",
                    "--output",
                    str(output),
                ],
                cwd=ROOT,
                capture_output=True,
                text=True,
            )
            self.assertEqual(result.returncode, 2)
            self.assertFalse(output.exists())
