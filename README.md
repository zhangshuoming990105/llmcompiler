# LEGO-Compiler

A modern, skill-driven C-to-assembly compiler based on
[LEGO-compiler: enhancing neural compilation through translation composability](https://doi.org/10.1007/s42514-025-00272-9),
published in CCF Transactions on High Performance Computing (2026).

The maintained implementation turns recursive control-block decomposition into
explicit artifacts: symbol bindings, native type layouts, keep/split decisions,
control-flow interfaces, assembly fragments, and differential test results.
Codex or Pi supplies the neural lowering; deterministic tools validate and combine
its output. This is a tool-assisted research prototype for a bounded C subset.

```text
C → bindings and layout → recursive keep/split → independent region lowering
  → assembly composition → diagnostics → local refinement/repair → verification
```

## Quick start

From a clone of this repository, use Python 3.10+ and native Clang. Runtime Python
code has no third-party dependencies. Neural runs also require an authenticated
`codex` or `pi` CLI; omitting `--model` preserves its existing configuration.

```sh
# No model calls: tests and conventional-compiler controls.
python3 -m unittest discover -s tests -v
python3 -m lego_compiler selfcheck --output runs/control-01

# Recursive neural compilation with independent regional requests.
python3 -m lego_compiler run --agent pi --modes lego-adaptive --jobs 4 \
  --manifest benchmarks/recursive/manifest.json --cases nested_control \
  --output runs/nested-01
```

Use a new output directory for each run. `--agent codex` selects the other adapter.
`--cases`, `--model`, `--agent-timeout`, and `--jobs` bound an experiment. Generation
workers receive their inputs explicitly and do not use tools; the controller runs
preparation, compilation checks, and tests. CI does not make model calls.

The repository skill is [lego-neural-compile](.agents/skills/lego-neural-compile/SKILL.md).
Invoke `$lego-neural-compile` in Codex or load the skill directory in Pi.

## Recursive compilation and local iteration

The selector keeps a manageable region or splits its outermost control components,
then revisits the children in source order.
Loop bodies, nested branches, and straight-line sequences can be refined again.
There is no fixed source-line threshold.

| Stage | CLI command | Main artifact |
|---|---|---|
| Binding, layout and region graph | `prepare` | `plan.json`, `regions.json` |
| Adaptive selection / further refinement | `select` | selected plan, `split-decisions.json`, `recomposed.c` |
| Independent translation and reuse | `lower` | responses, fragments, `candidate.s` |
| Deterministic reconstruction | `assemble` | combined assembly |
| Locate assembler errors | `diagnose` | region-specific `feedback.json` |
| Execute differential checks | `verify` | `result.json` |

A local edit can reuse compatible fragments. A failed non-atomic region can be
split further with `select --refine`; assembler diagnostics can be supplied only
to affected regions with `lower --feedback`. Initial attempts and repairs remain
separate. See [the workflow guide](docs/workflow.md) for complete commands and
[the lowering protocol](.agents/skills/lego-neural-compile/references/protocol.md)
for the memory and control-flow contracts.

## Modernization experiments

| Experiment | Recorded result |
|---|---|
| Nested loops, switch, break and continue, Pi | 30 independent regions; 1,000 checks passed |
| One-statement edit in the nested kernel | 1 region regenerated, 29 reused; 1,000 checks passed |
| Synthetic 2,155-line function, Pi | 123 final regions; 200 checks passed after refinement and local repair |

The long-function run needed one structural refinement and one repair round
covering 21 regions; the other 102 were reused. These are finite differential
checks on a synthetic scalability workload, including return values and complete
array buffers.

Inspect the [recursive compilation results](experiments/2026-10-25-recursive/report.md),
or replay the long candidate without another model call:

```sh
python3 -m lego_compiler verify benchmarks/recursive/long_nested/source.c \
  benchmarks/recursive/long_nested/driver.c \
  experiments/2026-10-25-recursive/long_nested/candidate.s \
  --function long_kernel --output runs/long-replay-01
```

Recorded neural assembly targets **arm64/macOS**. Native tests and CI also cover
compiler controls and the x86-64 Linux/macOS scaffold; this does not establish
neural accuracy on those targets. There is no cross-compilation mode.

## Scope

The frontend currently accepts one self-contained C function with scalar register
parameters/return values and native layouts. Includes/macros, global storage,
static locals, VLAs, varargs, arbitrary goto, bitfields, anonymous records,
variable-specific alignment, scope-cleanup and returns-twice attributes are not
supported. The lowering contract also excludes constant pools and extra spill
slots. Structural checks and finite differential tests are not equivalence proofs.

Clang supplies parsing/binding facts, small type-layout probes, and reference/test
compilation. The model generates candidate assembly. The harness executes input
programs and generated code, and is intended for controlled experiments rather
than running untrusted submissions as a security sandbox.

## Development and layout

- `lego_compiler/`: maintained implementation and CLI.
- `.agents/skills/`: repository skill and lowering protocol.
- `benchmarks/`: deterministic sources, drivers and manifests.
- `tests/`: regression tests, including corrupt-cache, timeout and control-flow cases.
- `experiments/`: recorded results and replayable artifacts.
- `docs/`: workflow and maintenance notes.

Run `ruff check .`, `ruff format --check .`, and the unittest command above before
submitting changes. See [maintenance notes](docs/maintenance.md) for repository
conventions and contribution checks.

## Citation

```bibtex
@article{zhang2026legocompiler,
  title   = {{LEGO}-compiler: enhancing neural compilation through translation composability},
  author  = {Zhang, Shuoming and Zhao, Jiacheng and Yu, Qiuchu and Xia, Chunwei and Wang, Zheng and Chen, Yunji and Feng, Xiaobing and Cui, Huimin},
  journal = {CCF Transactions on High Performance Computing},
  year    = {2026},
  volume  = {8},
  number  = {4},
  pages   = {410--436},
  doi     = {10.1007/s42514-025-00272-9},
  url     = {https://doi.org/10.1007/s42514-025-00272-9}
}
```

Code is distributed under the [MIT license](LICENSE).
