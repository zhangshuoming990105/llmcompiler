import json
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from lego_compiler.agents import decode_response, generate
from lego_compiler.common import ProcessTimeout


class AgentTraceTests(unittest.TestCase):
    def test_json_envelopes_are_normalized_without_repairing_payloads(self):
        response, changed = decode_response('```json\n{"decision":"split"}\n```')
        self.assertEqual(response["decision"], "split")
        self.assertTrue(changed)
        self.assertEqual(decode_response('Here is the answer: {"decision":"split"}')[0], response)
        with self.assertRaises(ValueError):
            decode_response('Here is the answer: {"decision":"split"} trailing text')

    def test_codex_tool_use_invalidates_even_a_valid_final_answer(self):
        events = [
            {
                "type": "item.completed",
                "item": {"type": "command_execution", "command": "clang -S source.c"},
            },
            {
                "type": "item.completed",
                "item": {"type": "agent_message", "text": '{"assembly":"ret"}'},
            },
        ]
        outputs = [
            subprocess.CompletedProcess([], 0, "test-cli", ""),
            subprocess.CompletedProcess([], 0, "\n".join(json.dumps(e) for e in events), ""),
        ]
        with (
            tempfile.TemporaryDirectory() as temporary,
            patch("lego_compiler.agents.execute", side_effect=outputs),
        ):
            folder = Path(temporary) / "generation"
            with self.assertRaisesRegex(ValueError, "used tools"):
                generate("codex", "prompt", {}, folder)
            self.assertEqual(
                json.loads((folder / "invocation.json").read_text())["tools_used"],
                ["command_execution"],
            )

    def test_pi_final_message_and_usage_are_preserved(self):
        event = {
            "type": "message_end",
            "message": {
                "role": "assistant",
                "model": "test-model",
                "usage": {"input": 12, "output": 3},
                "content": [{"type": "text", "text": '{"assembly":"ret"}'}],
            },
        }
        outputs = [
            subprocess.CompletedProcess([], 0, "test-cli", ""),
            subprocess.CompletedProcess([], 0, json.dumps(event), ""),
        ]
        with (
            tempfile.TemporaryDirectory() as temporary,
            patch("lego_compiler.agents.execute", side_effect=outputs) as call,
        ):
            response, metadata = generate("pi", "prompt", {}, Path(temporary) / "generation")
            self.assertEqual(response, {"assembly": "ret"})
            self.assertEqual(metadata["reported_models"], ["test-model"])
            self.assertEqual(metadata["usage"], [{"input": 12, "output": 3}])
            self.assertEqual(call.call_args.kwargs["input"], "prompt")
            self.assertNotIn("prompt", call.call_args.args[0])

    def test_timeouts_keep_partial_trace(self):
        outputs = [
            subprocess.CompletedProcess([], 0, "test-cli", ""),
            ProcessTimeout("too slow", '{"type":"turn.started"}\n', "diagnostic"),
        ]
        with (
            tempfile.TemporaryDirectory() as temporary,
            patch("lego_compiler.agents.execute", side_effect=outputs),
        ):
            folder = Path(temporary) / "generation"
            with self.assertRaises(TimeoutError):
                generate("codex", "prompt", {}, folder)
            self.assertEqual((folder / "events.jsonl").read_text(), '{"type":"turn.started"}\n')
            self.assertEqual(
                json.loads((folder / "invocation.json").read_text())["status"], "timeout"
            )
