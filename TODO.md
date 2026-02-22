# TODO (Paused Work)

Task: Provide per-rule DSL citations mapped to specific policy portions (with web citations), validate against COBOL, and keep improving rules until no more improvements are possible.

Current state:
- Added `policy_refs` to every rule in the DSL files and confirmed coverage in `docs/rule_policy_citations.md`.
- `rules/escal212_rules.yaml` and `rules/esdrv212_rules.yaml` updated so every rule has a `policy_refs` entry (including `Internal/No policy citation found` where applicable).
- `docs/rule_policy_citations.md` includes a row for every rule ID across `rules/*.yaml`.
- Validation: `python3 scripts/rule_validator.py` passes for updated rule files.

Open items:
- Replace generic policy references with exact policy section/page/line anchors where possible (e.g., Pub 100-04 Ch 8, Pub 100-02 Ch 11).
- Ensure each rule in `docs/rule_policy_citations.md` includes the specific policy portion reference (section and page/line).
- Reconcile any remaining policy/COBOL mismatches (notably the revenue code 0880 mismatch noted in the gap log).
- Expand policy mapping for any rules marked `Internal/No policy citation found` only if a policy source can be identified.

Key files:
- `docs/rule_policy_citations.md`
- `rules/escal212_rules.yaml`
- `rules/esdrv212_rules.yaml`
- `rules/reference_table_rules.yaml`
- `rules/copybook_rules.yaml`
- `rules/historical_calc_rules.yaml`
- `docs/policy_gap_log.md`
- `docs/policy_traceability.md`
- `docs/rule_traceability.md`

Next step when resuming:
- Gather official policy documents (Pub 100-04 Ch 8, Pub 100-02 Ch 11, 42 CFR 413.177, 42 CFR 512.340/512.350, CMS-1732-F).
- Update `policy_refs` and `docs/rule_policy_citations.md` with precise citations to the policy text.
