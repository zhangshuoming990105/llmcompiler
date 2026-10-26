import copy
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from test_pipeline import COMPILER

from lego_compiler.common import save_json
from lego_compiler.compile_blocks import compile_blocks
from lego_compiler.frontend import prepare
from lego_compiler.lowering import prompt


@unittest.skipUnless(COMPILER, "Clang is required")
class IncrementalLoweringTests(unittest.TestCase):
    def test_unrelated_edits_reuse_unchanged_fragments_only(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "input.c"
            source.write_text("int f(int n){int x=n; x+=1; return x;}")
            plan = prepare(source, root / "prepared", COMPILER)
            first, second = root / "first", root / "second"
            first.mkdir()
            second.mkdir()

            def fake(backend, message, response_schema, directory, **kwargs):
                directory.mkdir()
                identifier = directory.name
                result = {
                    "blocks": [
                        {
                            "id": identifier,
                            "assembly": "// test fragment"
                            if plan["abi"]["target"] == "arm64-macos"
                            else "# test fragment",
                        }
                    ]
                }
                metadata = {
                    "backend": backend,
                    "requested_model": None,
                    "exit_code": 0,
                    "tools_used": [],
                    "seconds": 0.1,
                }
                (directory / "prompt.txt").write_text(message)
                save_json(directory / "schema.json", response_schema)
                save_json(directory / "response.json", result)
                save_json(directory / "invocation.json", metadata)
                return result, metadata

            with patch("lego_compiler.compile_blocks.generate", side_effect=fake):
                compile_blocks(plan, source.read_text(), first, backend="pi")
            edited = copy.deepcopy(plan)
            edited["source_sha256"] = "unrelated whole-function fingerprint"
            edited["blocks"][1]["source"] = edited["blocks"][1]["source"].replace("+=1", "+=2")
            with patch("lego_compiler.compile_blocks.generate", side_effect=fake) as generator:
                _, metadata = compile_blocks(
                    edited, source.read_text(), second, backend="pi", reuse=first
                )
                self.assertEqual(generator.call_count, 1)
            self.assertEqual([item["reused"] for item in metadata], [True, False, True])
            repaired, reused = root / "repaired", root / "reused"
            repaired.mkdir()
            reused.mkdir()
            with patch("lego_compiler.compile_blocks.generate", side_effect=fake) as generator:
                compile_blocks(
                    edited,
                    source.read_text(),
                    repaired,
                    backend="pi",
                    reuse=second,
                    feedback={"b001": "An observed local diagnostic"},
                )
                self.assertEqual(generator.call_count, 1)
            with patch("lego_compiler.compile_blocks.generate", side_effect=fake) as generator:
                _, metadata = compile_blocks(
                    edited, source.read_text(), reused, backend="pi", reuse=repaired
                )
                self.assertEqual(generator.call_count, 0)
            self.assertTrue(all(item["reused"] for item in metadata))

    def test_single_region_prompt_omits_unreferenced_bindings(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "input.c"
            source.write_text("int f(int n){int unused=2; return n;}")
            plan = prepare(source, root / "prepared", COMPILER)
            from lego_compiler.regions import select_regions

            tree = json.loads((root / "prepared/regions.json").read_text())
            selected = select_regions(plan, tree, lambda node: "split")
            block = next(block for block in selected["blocks"] if block["kind"] == "ReturnStmt")
            text = prompt(selected, source.read_text(), "lego-block", block["id"])
            self.assertNotIn('"original_name": "unused"', text)
            self.assertNotIn(selected["source_sha256"], text)
