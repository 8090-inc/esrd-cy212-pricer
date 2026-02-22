# Gherkin Rules (Single DSL)

This directory contains the authoritative, SME-readable rule specifications in Gherkin (`.feature`).

Guidelines:
- Gherkin is the only DSL going forward.
- Rules should be denormalized and intent-focused; avoid COBOL control flow.
- Normalization logic belongs in `docs/normalization_catalog.md`.
- Every scenario must include traceability metadata (COBOL, policy, test case).

References:
- Rule format exemplars: `docs/gherkin_exemplars.md`
- Template: `gherkin_rules/_template.feature`
