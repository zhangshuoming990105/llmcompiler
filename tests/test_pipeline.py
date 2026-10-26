import platform
import shutil
import tempfile
import unittest
from pathlib import Path

from lego_compiler.cli import summarize
from lego_compiler.common import ROOT
from lego_compiler.frontend import prepare
from lego_compiler.lowering import assemble, validate_fragment
from lego_compiler.target import native_target, symbol
from lego_compiler.verify import verify

COMPILER = "/usr/bin/clang" if platform.system() == "Darwin" else shutil.which("clang")


@unittest.skipUnless(COMPILER, "Clang is required")
class PipelineTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.directory = Path(self.temporary.name)

    def tearDown(self):
        self.temporary.cleanup()

    def prepare_text(self, source):
        path = self.directory / "input.c"
        path.write_text(source)
        return prepare(path, self.directory / "prepared", COMPILER)

    def test_shadowed_names_have_distinct_bindings_and_uses(self):
        plan = prepare(
            ROOT / "benchmarks/representative/shadow_nested/source.c",
            self.directory / "prepared",
            COMPILER,
        )
        for original in ("n", "i"):
            bindings = [b for b in plan["bindings"] if b["original_name"] == original]
            self.assertEqual(len(bindings), 2)
            self.assertEqual(len({b["name"] for b in bindings}), 2)
            self.assertEqual(len({b["offset"] for b in bindings}), 2)
            self.assertTrue(all(b["use_offsets"] for b in bindings))
        self.assertEqual([b["kind"] for b in plan["blocks"]], ["DeclStmt", "ForStmt", "ReturnStmt"])

    def test_utf8_comments_and_all_statements_survive_partition(self):
        plan = self.prepare_text(
            "int f(int n) { /* 中文 */ int a=1; if(n) {a+=2;} else {a-=2;} a*=3; return a; }"
        )
        renamed = (self.directory / "prepared/renamed.c").read_bytes()
        blocks = plan["blocks"]
        self.assertEqual(
            "".join(b["source"] for b in blocks).encode(),
            renamed[blocks[0]["begin"] : blocks[-1]["end"]],
        )
        self.assertIn("else", blocks[1]["source"])
        self.assertEqual(len(blocks), 4)

    def test_native_struct_layout_and_array_stride_are_explicit(self):
        plan = prepare(
            ROOT / "benchmarks/representative/struct_offset/source.c",
            self.directory / "prepared",
            COMPILER,
        )
        self.assertEqual(plan["record_layouts"]["struct Item"], {"tag": 0, "value": 4, "weight": 8})
        accesses = [fact for b in plan["blocks"] for fact in b["address_facts"]]
        self.assertTrue(any(f.get("operation") and f["size"] == 16 for f in accesses))
        self.assertTrue(any(f.get("field_offset") == 8 and f["size"] == 8 for f in accesses))
        intervals = []
        for binding in plan["bindings"]:
            self.assertEqual(binding["offset"] % binding["alignment"], 0)
            intervals.append(set(range(binding["offset"], binding["offset"] + binding["size"])))
        for index, interval in enumerate(intervals):
            self.assertTrue(all(not interval & other for other in intervals[index + 1 :]))
        self.assertEqual(plan["abi"]["frame_size"] % 16, 0)

    def test_unsupported_c_is_an_error(self):
        for source in (
            "int f(int n){int a[n]; return sizeof a;}",
            "int g; int f(void){return g;}",
            "#define X 1\nint f(void){return X;}",
            "int f(void){_Alignas(32) int x=1;return x;}",
        ):
            with self.subTest(source=source), self.assertRaises(ValueError):
                self.prepare_text(source)

    def test_renaming_cannot_capture_an_existing_identifier(self):
        plan = self.prepare_text("int f(int n){int lego_v0_n=2; return n+lego_v0_n;}")
        self.assertEqual(len({b["name"] for b in plan["bindings"]}), 2)
        self.assertTrue(all(b["name"] not in {"n", "lego_v0_n"} for b in plan["bindings"]))

    def test_missing_duplicated_and_reordered_blocks_fail(self):
        plan = self.prepare_text("int f(int n){int a=n; return a;}")
        blocks = [
            {
                "id": b["id"],
                "assembly": "// empty" if native_target() == "arm64-macos" else "# empty",
            }
            for b in plan["blocks"]
        ]
        for bad in (blocks[:1], blocks + blocks[:1], list(reversed(blocks))):
            with self.subTest(blocks=bad), self.assertRaises(ValueError):
                assemble(plan, {"blocks": bad}, "lego-bundle")

    def test_cross_block_jumps_and_stack_mutation_fail(self):
        plan = self.prepare_text("int f(int n){return n;}")
        arm = native_target() == "arm64-macos"
        instructions = (
            ["b L_other_block", "sub sp, sp, #16", "mov x19, x0", "ret", '.include "solution.s"']
            if arm
            else [
                "jmp L_other_block",
                "subq $16, %rsp",
                "movq %rax, %rbx",
                "ret",
                '.include "solution.s"',
            ]
        )
        for instruction in instructions:
            with self.subTest(instruction=instruction), self.assertRaises(ValueError):
                validate_fragment(plan, plan["blocks"][0], instruction)

    def test_differential_checker_detects_wrong_return(self):
        source = self.directory / "source.c"
        source.write_text("int f(int n){return n+1;}")
        driver = self.directory / "driver.c"
        driver.write_text(
            '#include <stdio.h>\nint f(int); int reference(int);\nint main(void){int bad=f(5)!=reference(5); printf("{\\"checks\\":1,\\"failures\\":%d}\\n",bad); return bad;}'
        )
        assembly = self.directory / "bad.s"
        target = native_target()
        body = "mov w0, #0\nret" if target == "arm64-macos" else "xorl %eax, %eax\nret"
        assembly.write_text(
            f".text\n.globl {symbol('f', target)}\n{symbol('f', target)}:\n{body}\n"
        )
        result = verify(source, driver, assembly, "f", self.directory / "check", COMPILER)
        self.assertEqual(result["status"], "mismatch")
        self.assertEqual(result["failures"], 1)

    def test_differential_checker_bounds_nonterminating_assembly(self):
        source = self.directory / "source.c"
        source.write_text("int f(void){return 1;}")
        driver = self.directory / "driver.c"
        driver.write_text("int f(void); int main(void){return f();}")
        assembly = self.directory / "loop.s"
        target = native_target()
        name = symbol("f", target)
        branch = "b" if target == "arm64-macos" else "jmp"
        assembly.write_text(f".text\n.globl {name}\n{name}:\n{branch} {name}\n")
        result = verify(
            source, driver, assembly, "f", self.directory / "check", COMPILER, timeout=0.2
        )
        self.assertEqual(result["status"], "timeout")

    def test_failures_remain_in_denominator(self):
        rows = [
            {"mode": "direct", "status": status}
            for status in ("passed", "preparation_error", "generation_error", "mismatch")
        ]
        summary = summarize(rows)["direct"]
        self.assertEqual((summary["passed"], summary["attempted"]), (1, 4))


if __name__ == "__main__":
    unittest.main()
