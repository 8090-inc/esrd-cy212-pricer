# Regression Baseline Cases

Canonical and synthetic test cases used as a regression baseline for the Gherkin rules.

Source of truth: `docs/tests/regression_baseline_cases.csv`.

Notes:
- `TC-EX-*` entries are curated exemplar cases.
- `TC-AUTO-*` entries are auto-derived from Gherkin Given/When/Then steps and require SME refinement.

Columns:
- `test_case_id`: Unique ID for traceability.
- `rule_id`: Gherkin rule ID the case validates.
- `description`: Short intent statement.
- `input_fields`: Input and action steps derived from the scenario.
- `expected_outcome`: Expected results derived from the scenario.
- `source`: `Synthetic`, `Synthetic (auto-derived)`, or `CMS Example` when available.
