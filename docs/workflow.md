# Workflow guide

Run the commands below from the repository root. Historical scripts are archived;
the maintained, dependency-free Python package `lego_compiler` turns the LEGO idea into
inspectable stages and a repository skill shared by Codex and Pi:

```text
C source -> Clang declaration identities -> renamed C -> native ABI layout
         -> recursive region graph -> keep/split selection + control skeleton
         -> independently lowered assembly fragments
         -> deterministic ABI scaffold -> assemble/link -> differential tests
```

The model still lowers C to assembly. Clang does syntax/binding extraction,
small type-layout probes, and reference/test compilation. This is explicitly a
**tool-assisted** variant, not a recreation of the old all-neural pipeline.

## Run

Requires Python 3.10+, native Clang, and an authenticated `codex` or `pi` CLI for
neural runs. No Python dependencies or model-name allowlist are required. The
pilot supports arm64/macOS and has an x86-64 Linux/macOS scaffold; see recorded
results for which targets were actually tested. It does not cross-compile.

```sh
python3 -m unittest discover -s tests -v
python3 -m lego_compiler selfcheck --output runs/control-01
python3 -m lego_compiler run --agent codex --output runs/codex-01
python3 -m lego_compiler run --agent pi --modes direct,lego-block --output runs/pi-01
python3 -m lego_compiler run --agent pi --modes lego-adaptive --jobs 4 --output runs/adaptive-01
```

Replay a saved candidate without another model call:

```sh
python3 -m lego_compiler verify benchmarks/representative/legacy_gcd/source.c \
  benchmarks/representative/legacy_gcd/driver.c runs/codex-01/legacy_gcd/lego-bundle/candidate.s \
  --function gcd --output runs/gcd-replay-01
```

`--model` is optional: omitting it preserves the CLI's existing configuration.
The runner saves requested model and any model ID reported by the CLI; a CLI
that omits the resolved model must not be presented as having a verified model
identity. `--cases legacy_gcd,array_stride` bounds the case selection.
The default modes are `direct,lego-bundle` for the original six-case smoke suite.
`lego-block` invokes a fresh process for each top-level block. `lego-adaptive`
implements recursive selection and invokes a fresh process per selected region.
Generation uses no tools and receives no test feedback; the
controller rejects observed tool calls. Pi disables its tools; Codex uses a
read-only sandbox plus trace checks. These controls are experimental hygiene,
not a complete isolation boundary against a malicious agent.

Every run directory is new. It stores prompts, output schemas, raw CLI events,
responses, timing/usage, bindings, layouts, fragments, linked assembly, build
diagnostics, and differential results. Reference code stays in controller-owned
verification: recursive recomposition is checked before lowering, and neural
assembly is checked after generation. There are no automatic repairs; all attempted
cases, including preparation/API/contract/build/runtime failures, remain in the
denominator. `summary.json` is the authoritative count, not agent prose.

## Recursive selection and empirical refinement

The recursive path follows [Algorithm 2 and Appendix A of LEGO-Compiler](https://arxiv.org/html/2505.20356v1#A4).
The selector takes a region from a deque, obtains a keep/split decision, and
places split components back at the front in reverse order. A loop exposes its
initialization, condition, body, update, and jumps; nested bodies remain eligible
for subdivision. Branches and switches expose corresponding control components.
Straight-line sequences can be subdivided as well. There is no required line
threshold. `--split-policy all` exercises the finest supported decomposition;
the normal `llm` policy decides which composable regions to retain.

The implementation records the region tree in `regions.json`, selected leaves
and control skeleton in `plan.json`, and every decision in `split-decisions.json`.
Before neural lowering, `lego-adaptive` recompiles `recomposed.c` and checks it
against the original function. This tests decomposition independently of neural
translation. Conditions produce one explicit boolean result consumed by the
adjacent controller jump. All persistent C values use canonical stack slots.
Switch selectors are evaluated once; nested break/continue targets are explicit.

For a difficult leaf, the agent can use observed diagnostics to refine just
that region and then reuse unaffected translations:

```sh
python3 -m lego_compiler select runs/old-partition --refine REGION_ID \
  --policy keep --output runs/refined-partition
python3 -m lego_compiler lower runs/refined-partition --agent pi --jobs 4 \
  --reuse runs/old-lowering --output runs/refined-lowering
```

Use an actual selected, non-atomic region ID from `plan.json`. `--policy keep`
splits it one level; `--policy llm --feedback diagnostics.txt` permits deeper
decisions on new descendants. Reuse requires an identical regional prompt and
contract, backend, and requested model; reused artifacts retain their original
model provenance and do not count as fresh inference. Source offsets and
whole-function hashes are absent from regional prompts, so unrelated source
edits do not cause global cache invalidation. ABI/layout changes still do.

Local assembler feedback can be obtained and applied without regenerating
unaffected regions:

```sh
python3 -m lego_compiler diagnose runs/partition runs/lowering/candidate.s \
  --output runs/diagnostics-01
python3 -m lego_compiler lower runs/partition --agent pi --jobs 4 \
  --reuse runs/lowering --feedback runs/diagnostics-01/feedback.json \
  --output runs/repaired-01
```

The diagnostic map is derived from the recorded fragments and checked against
the candidate bytes. Unmapped scaffold errors remain distinct from region errors.
Repair feedback changes only the affected requests; repaired fragments can be
reused later under the same base contract after the diagnostic is removed.
Each invocation is one bounded attempt; the CLI does not silently repeat repairs.

`benchmarks/recursive` adds a nested control-flow diagnostic and a deterministic
2,155-line stress function. The latter is synthetic, with many similar arithmetic
patterns; it measures scaling of this implementation, not coverage of a real
production codebase. Regenerate it with `python3 benchmarks/recursive/generate_long.py`.

For interactive use, invoke `$lego-neural-compile` in Codex, or load
`.agents/skills/lego-neural-compile` in Pi. The skill is repository-scoped; no
global agent settings are changed. See its protocol for block boundary rules.

## Scope and experimental limits

The six-case suite contains exact archived C sources for `gcd`, bit operations,
and `switch`, plus new tests for shadowed variables/nested loops, strided array
mutation, and padded struct indexing. Its input generators are deterministic,
bounded, and avoid undefined behavior in these functions. Tests compare return
values and observable buffers, not assembly text. These new inputs are **not**
the old ExeBench IO pairs. The small suite cannot establish a general accuracy
improvement; direct and LEGO may both saturate it on modern models.

The frontend currently requires one self-contained C function, scalar register
parameters/return values, and native layouts. Includes/macros, global storage,
static locals, varargs, VLAs, goto, bitfields, and anonymous records are rejected.
Variable-specific alignment, scope-cleanup attributes, and returns-twice control
transfers are also unsupported.
Original arbitrary goto remains unsupported; the recursive controller generates
only explicit, bound structural jumps. Switch cases hidden inside nested scopes
or loop bodies (such as Duff's device) and GNU case ranges are unsupported.
The fragment contract excludes constant pools and extra spill slots; some valid
C programs therefore cannot be lowered in this pilot. Structural checks do not
prove instruction-level ABI correctness or semantic equivalence. Extend the
subset and test corpus explicitly before running a full external benchmark.

Historical issues motivating a separate runner: the old CLI never calls
`split_function_into_cbs`; `full` asks for internal steps but saves only the final
assembly; masked cases are counted as passes; the default ARM path links through
the host compiler without an explicit target ABI; and the model/provider map is
fixed to 2025 names. Old prompt examples also contain type/register mismatches.

## Next experiments

1. Use real long functions to study selected-region complexity, output limits,
   refinement depth, peak per-call context, and how much recompilation a local
   edit or failure requires. Small-function accuracy is only a smoke check here.
2. Add region-local behavioral diagnostics and bounded automatic refinement;
   whole-program mismatches currently require the agent to choose a refinement
   hypothesis, rather than implying that the faulty region is already known.
3. Extend the C subset and type/call interfaces for the selected real codebases.
   Restore exact dataset revisions and IO pairs when reproducing historical rates.

The CLI adapter follows the installed command help and current
[Codex non-interactive documentation](https://learn.chatgpt.com/docs/non-interactive-mode).
Repository discovery follows the
[Codex skill documentation](https://learn.chatgpt.com/docs/build-skills) and Pi's
installed `docs/skills.md` / `pi --help`. External project source checkouts, if
needed later, belong under `3rdparty/<project-name>/`.
