import json
import tempfile
import unittest
from pathlib import Path

from test_pipeline import COMPILER

from lego_compiler.common import save_json
from lego_compiler.diagnose import diagnose
from lego_compiler.frontend import prepare
from lego_compiler.lowering import assemble


@unittest.skipUnless(COMPILER, "Clang is required")
class DiagnosticMappingTests(unittest.TestCase):
    def test_assembler_error_maps_to_the_failing_region_only(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "source.c"
            source.write_text("int f(int n){int x=n; x+=1; return x;}")
            plan = prepare(source, root / "prepared", COMPILER)
            response = {
                "blocks": [
                    {
                        "id": block["id"],
                        "assembly": "invalid_instruction_for_mapping" if index == 1 else "nop",
                    }
                    for index, block in enumerate(plan["blocks"])
                ]
            }
            candidate = root / "candidate.s"
            candidate.write_text(assemble(plan, response, "lego-block"))
            save_json(root / "response.json", response)
            result = diagnose(root / "prepared", candidate, root / "diagnostics", COMPILER)
            self.assertEqual(result["status"], "assembly_error")
            self.assertEqual(result["mapped_regions"], ["b001"])
            feedback = json.loads((root / "diagnostics/feedback.json").read_text())
            self.assertEqual(list(feedback), ["b001"])
            self.assertIn("invalid_instruction_for_mapping", feedback["b001"])
