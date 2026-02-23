# Docs Index

This folder contains the reverse‑engineered artifacts. Start here to avoid hunting.

## Primary Reading
- `claims_expert_narrative.md`: Plain‑English end‑to‑end pricing narrative.
- `claims_expert_narrative_validation.md`: Line‑by‑line evidence for the narrative.
- `human_readable_rules.md`: Full rulebook (detailed, long‑form).

## Gherkin and Rules
- `../gherkin_rules/`: Authoritative rule DSL (Gherkin).
- `gherkin_style_guide.md`: Style and readability rules for Gherkin.
- `normalization_catalog.md`: Derived fields and normalization logic.

## Traceability and Coverage
- `traceability_matrix.csv`: COBOL ↔ Gherkin ↔ Policy ↔ Test mapping.
- `traceability_schema.md`: Column definitions and requirements.
- `coverage_report.md`: Rule coverage by module.

## Policy Sources
- `policy_version_index.csv`: Policy version control.
- `policy_gap_log.md`: Known policy gaps.
- `policies/`: Policy and example source files.

## Diagrams
- `system_architecture.md`: Technical architecture diagrams.
- `domain_expert_diagrams.md`: Business‑facing diagrams.
- `architecture_diagrams.md`: Additional technical diagrams.

## Regression Baselines
- `regression_baseline_cases.csv`: Canonical + auto‑derived test cases.
- `regression_baseline_cases.md`: Schema and notes.

## Historical/Legacy Artifacts
- `policy_traceability.md`, `policy_traceability.csv`, `policy_traceability.json`: Legacy policy mapping outputs.
These are retained for reference but the current source of truth is `traceability_matrix.csv`.
