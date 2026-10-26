"""Deterministic scalability stress source; this is not a real-world benchmark."""

import random
from pathlib import Path


def generate(stages=32, statements_per_arm=32, seed=20261025):
    randomizer = random.Random(seed)
    lines = [
        "unsigned int long_kernel(unsigned int *a, int n, unsigned int seed) {",
        "    unsigned int state = seed;",
        "    for (int i = 0; i < n; ++i) {",
        "        int round = 0;",
        "        while (round < 2) {",
        "            ++round;",
    ]
    for stage in range(stages):
        mask = 1 << (stage % 31)
        lines.append(f"            if ((state ^ seed) & {mask}u) {{")
        for branch in range(2):
            if branch:
                lines.append("            } else {")
            for index in range(statements_per_arm):
                constant = randomizer.randrange(1, 65536)
                shift = randomizer.randrange(1, 16)
                offset = randomizer.randrange(8)
                operation = (index + stage + branch) % 4
                if operation == 0:
                    statement = f"state = (state ^ a[(i + {offset}) % n]) * {constant | 1}u + {stage + index + 1}u;"
                elif operation == 1:
                    statement = f"state = (state << {shift}) | (state >> {32 - shift});"
                elif operation == 2:
                    statement = f"state ^= (state >> {shift}) + {constant}u;"
                else:
                    statement = f"state += (unsigned int)(i + round) * {constant}u;"
                lines.append("                " + statement)
        lines.append("            }")
    lines += ["        }", "        a[i] ^= state;", "    }", "    return state;", "}"]
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    output = Path(__file__).parent / "long_nested/source.c"
    output.write_text(generate())
    print(f"Wrote {len(output.read_text().splitlines())} lines to {output}")
