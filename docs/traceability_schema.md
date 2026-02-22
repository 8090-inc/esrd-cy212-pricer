# Traceability Schema

Each rule scenario must map COBOL source to policy and tests.

Required mapping:
- COBOL program/section/paragraph (with line range)
- Gherkin feature and scenario ID
- Policy citation (policy_id + section/page/line)
- Test case ID (once regression suite is built)
- Normalization IDs used

## Columns (traceability_matrix.csv)
- cobol_program
- cobol_section
- cobol_paragraph
- cobol_line_start
- cobol_line_end
- gherkin_feature
- gherkin_scenario
- rule_id
- policy_id
- policy_section
- policy_page_line
- effective_date
- transmittal_id
- test_case_id
- normalization_ids
- status
- notes

