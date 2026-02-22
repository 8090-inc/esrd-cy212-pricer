# Gherkin Style Guide (Single DSL)

Goals:
- Maximize rule recall from COBOL.
- Produce SME-readable scenarios that express intent, not control flow.
- Ensure every scenario is traceable to COBOL and policy.

## Required Metadata (per Feature)
- Description: short narrative summary
- COBOL: program/section/paragraph + line range
- Policy: policy ID and section/page/line
- Effective date, transmittal ID, and release ID

## Required Tags (per Scenario)
- `@rule_id:<RULE-ID>`
- `@test_case:<ID>` (optional until regression suite is built)

## Rule Block Conventions
- Use `Rule:` to introduce each business rule.
- Include `Description:` and `Code Path Citations:` as comments within the rule block.

## Scenario Conventions
- Use domain language (e.g., "claim", "adjustment", "return code", "payment amount").
- Avoid step-by-step variable mutation, memory moves, or internal flags.
- Avoid component names in steps (e.g., "driver", "calculator", "pricer", "system").
- Prefer 3–6 steps per scenario (Given/When/Then + 1–2 Ands).
- Prefer one scenario per business rule outcome.
- Use Scenario Outline for enumerations (e.g., revenue/condition codes).

## Precedence and Exceptions
- Express precedence explicitly in Given/When/Then.
- Use "And no other overrides apply" when needed.

## Normalization
- Do not describe normalization steps in scenarios.
- Reference normalization entries by ID when the rule depends on derived values.
- If a rule is purely normalization, move it to `docs/normalization_catalog.md` instead of Gherkin.

## Traceability
- Each scenario must map to:
  - COBOL location
  - Policy clause (or explicit "Internal/No policy citation")
  - Test case ID once regression suite is created

## Code Path Citations
- Cite the COBOL evidence for the rule with file and line ranges.
- Keep citations near the rule (not only in external docs) to maximize SME readability.
