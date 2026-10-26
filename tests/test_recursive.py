import json
import random
import tempfile
import unittest
from pathlib import Path

from test_pipeline import COMPILER

from lego_compiler.common import checked
from lego_compiler.frontend import prepare
from lego_compiler.regions import recompose_c, select_regions, validate_composition
from lego_compiler.verify import verify

NESTED = """int f(int n, int *a) {
    int s = 0;
    for (int i=0; i<n; ++i) {
        if (i%3 == 0) continue;
        int j=0;
        while (j<4) {
            ++j;
            switch ((a[i]+j)&3) {
                case 0: s+=j; break;
                case 1: if (j==2) continue; s-=i;
                case 2: s+=3; break;
                default: s+=a[i];
            }
            if (s>200) break;
        }
        do { --s; if (s%5==0) break; } while(s>100);
        if (s < -100) return s;
    }
    return s;
}
"""

SIDE_EFFECTS = """int f(int n, int *a) {
    int i=0, j=0, s=0;
    while (i<n && a[i++]!=0) s+=i;
    do { if (++j<2) continue; s+=j; } while(j<3);
    for (;;) { if (++i>n+2) break; s+=i; }
    switch(a[0]++) {
        case -1: s+=2;
        case 0: s+=3; break;
        default: s-=3;
        case 2: s+=7;
    }
    return s + a[0];
}
"""


@unittest.skipUnless(COMPILER, "Clang is required")
class RecursiveControlTests(unittest.TestCase):
    def check_partition(self, source, decider):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            original = directory / "input.c"
            original.write_text(source)
            plan = prepare(original, directory / "prepared", COMPILER)
            tree = json.loads((directory / "prepared/regions.json").read_text())
            selected = select_regions(plan, tree, decider)
            composed = directory / "composed.c"
            composed.write_text(recompose_c(selected, tree))
            assembly = directory / "composed.s"
            checked([COMPILER, "-std=c11", "-O0", "-S", composed, "-o", assembly])
            driver = directory / "driver.c"
            driver.write_text("""#include <stdio.h>
#include <string.h>
int f(int, int*); int reference(int, int*);
int main(void) {
  int checks=0, bad=0;
  for(int t=0;t<100;++t) {
    int a[8], b[8];
    for(int j=0;j<8;++j) a[j]=t*(j+1)%17-8;
    memcpy(b,a,sizeof a);
    int expected=reference(t%9,b);
    bad += f(t%9,a)!=expected; ++checks;
    bad += memcmp(a,b,sizeof a)!=0; ++checks;
  }
  printf("{\\"checks\\":%d,\\"failures\\":%d}\\n",checks,bad);
  return bad!=0;
}""")
            result = verify(original, driver, assembly, "f", directory / "check", COMPILER)
            self.assertEqual(result["status"], "passed", result)
            return selected, tree

    def test_all_nested_controls_can_be_split_to_atomic_regions(self):
        selected, tree = self.check_partition(NESTED, lambda node: "split")
        self.assertTrue(
            all(not tree["nodes"][block["id"]]["expansion"] for block in selected["blocks"])
        )
        self.assertGreater(max(item["depth"] for item in selected["split_decisions"]), 5)
        self.assertTrue(
            any(
                block["source"].strip() == "continue;" and block["allowed_targets"]
                for block in selected["blocks"]
            )
        )

    def test_short_circuit_do_continue_infinite_for_and_switch_fallthrough(self):
        self.check_partition(SIDE_EFFECTS, lambda node: "split")

    def test_mixed_keep_split_frontiers_preserve_semantics(self):
        for seed in range(3):
            generator = random.Random(seed)
            with self.subTest(seed=seed):
                self.check_partition(
                    NESTED,
                    lambda node: "split"
                    if node["id"] == "r" or generator.random() < 0.65
                    else "keep",
                )

    def test_condition_register_handoff_is_explicit(self):
        selected, _ = self.check_partition(NESTED, lambda node: "split")
        branch = next(
            i for i, step in enumerate(selected["composition"]) if step["kind"] == "branch"
        )
        del selected["composition"][branch - 1]
        with self.assertRaises(ValueError):
            validate_composition(selected)
