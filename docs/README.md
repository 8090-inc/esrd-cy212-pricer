# Docs Index

This folder contains the reverse‑engineered artifacts. Start here to avoid hunting.

## Folder Map
- `overview/`: Primary narratives, rulebooks, and DSL guidance.
- `traceability/`: COBOL ↔ Gherkin ↔ Policy ↔ Test mappings and coverage.
- `policy/`: Policy versions, gaps, and source files.
- `diagrams/`: Domain and technical diagrams (Mermaid).
- `tests/`: Regression baseline cases and schemas.
- `legacy/`: Superseded artifacts kept for reference.

## Primary Reading
- `overview/claims_expert_narrative.md`: Plain‑English end‑to‑end pricing narrative.
- `overview/claims_expert_narrative_validation.md`: Line‑by‑line evidence for the narrative.
- `overview/human_readable_rules.md`: Full rulebook (detailed, long‑form).

## Gherkin and Rules
- `../gherkin_rules/`: Authoritative rule DSL (Gherkin).
- `overview/gherkin_style_guide.md`: Style and readability rules for Gherkin.
- `overview/normalization_catalog.md`: Derived fields and normalization logic.
- `overview/dsl_policy.md`: DSL governance (Gherkin only).

## Traceability and Coverage
- `traceability/traceability_matrix.csv`: COBOL ↔ Gherkin ↔ Policy ↔ Test mapping.
- `traceability/traceability_schema.md`: Column definitions and requirements.
- `traceability/coverage_report.md`: Rule coverage by module.

## Policy Sources
- `policy/policy_version_index.csv`: Policy version control.
- `policy/policy_gap_log.md`: Known policy gaps.
- `policy/policies/`: Policy and example source files.

## Diagrams
- `diagrams/system_architecture.md`: Technical architecture diagrams.
- `diagrams/domain_expert_diagrams.md`: Business‑facing diagrams.
- `diagrams/architecture_diagrams.md`: Additional technical diagrams.

## Regression Baselines
- `tests/regression_baseline_cases.csv`: Canonical + auto‑derived test cases.
- `tests/regression_baseline_cases.md`: Schema and notes.

## Historical/Legacy Artifacts
- `legacy/policy_traceability.md`, `legacy/policy_traceability.csv`, `legacy/policy_traceability.json`: Legacy policy mapping outputs.
These are retained for reference but the current source of truth is `traceability/traceability_matrix.csv`.
