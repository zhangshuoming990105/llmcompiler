# Repository maintenance

The supported implementation is `lego_compiler/`. The historical monolithic
scripts and raw 2025 logs are not part of the current execution path. Historical
scripts remain in sanitized Git history; local copies of raw material are kept
under ignored `.local-archive/` and are not published.

Development uses Python 3.10+, native Clang, and unittest. Model-backed tests are
separate from CI; ordinary refactors should use deterministic tests and native
compiler controls without spending model tokens.

```sh
ruff check .
ruff format --check .
python3 -m unittest discover -s tests -v
python3 -m lego_compiler selfcheck --output runs/check-01
python3 scripts/check_public_tree.py
```

`save_json` atomically publishes run records. Interrupted or invalid cached
responses are treated as misses, and each new lowering invocation still makes
at most one model request per selected region. Keep initial failures and record
refinements or repairs in new directories. Never replace neural assembly with
compiler output when reporting a neural result.

External project checkouts for inspection belong under
`3rdparty/<project-name>/`. Keep credentials in the agent CLI's existing auth
configuration, not in this repository. Use `scripts/check_public_tree.py
--history` to inspect reachable branch/tag histories before publication; the
scanner reports locations and categories, never credential values.
