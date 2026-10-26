# Recorded experiments

These are curated, finite test results, not guarantees for arbitrary C programs.

| Record | Contents |
|---|---|
| [Initial pilot](2026-10-25-pilot/report.md) | Six small kernels, Codex/Pi adapter checks, replayable candidate assembly |
| [Recursive compilation](2026-10-25-recursive/report.md) | Nested control flow, a 2,155-line synthetic function, refinement and local repair |

The recursive capsules retain the source, selected plan, model response, final
assembly, diagnostics and verification summary needed to inspect and replay the
result. The long function required one structural refinement and one round of
assembler-guided repairs. It is not a first-attempt success or a real production
function. The pilot's original prompts and intermediate duplicates are archived
locally rather than distributed in this repository.

Machine-specific home-directory prefixes in public JSON metadata are normalized
to repository-relative paths. Run paths describe the original execution and may
not exist in a fresh clone. Original input-source and candidate-assembly bytes and their recorded hashes
are unchanged; generated C recompositions only have trailing blank lines normalized. Use the replay commands in the reports to create a new run.

Do not commit raw agent events, credentials, local configuration, build products,
or unrestricted run directories. The checked-in artifacts are selected evidence;
new full runs stay under ignored `runs/`.
