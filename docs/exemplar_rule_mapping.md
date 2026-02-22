# Exemplar Rule Mapping (sample-10-rules-cms.pdf → Gherkin)

This maps the 10 exemplar rules in `docs/policies/sample-10-rules-cms.pdf` to the authoritative Gherkin rules in `gherkin_rules/`.

| Exemplar Rule | Gherkin Rule IDs | Gherkin Files | Notes |
| --- | --- | --- | --- |
| Rule 1: Geographic Wage Index Lookup & Application | DRV-WAGE-008, DRV-WAGE-010, CAL-002 | gherkin_rules/esdrv212_wage.feature, gherkin_rules/escal212.feature | Driver performs bundled CBSA lookup and year match; calculator applies labor/non-labor math. |
| Rule 2: Children's Hospital Wage Override | DRV-WAGE-007 | gherkin_rules/esdrv212_wage.feature | Provider-specific override for CY2015+ claims. |
| Rule 3: Supplemental Wage Index 5% Cap | DRV-WAGE-009 | gherkin_rules/esdrv212_wage.feature | Caps decrease to 5% when indicator is on. |
| Rule 4: Acute Kidney Injury (AKI) Exemption | CAL-001P, CAL-001E, CAL-001F, CAL-018 | gherkin_rules/escal212.feature | AKI bypasses bundled factors and height/weight edits; QIP reduction applies only to non-AKI. |
| Rule 5: Pediatric Age Classification | CAL-008, CAL-012 | gherkin_rules/escal212.feature | Age < 18 sets pediatric track; low-volume multiplier defaults to 1.000 for pediatric. |
| Rule 6: Low Body Mass Index (BMI) Adjustment | CAL-005 | gherkin_rules/escal212.feature | BMI < 18.5 applies low BMI factor for adults. |
| Rule 7: Dialysis Onset (New Patient) Adjustment | CAL-009 | gherkin_rules/escal212.feature | Applies onset factor for adults within 120 days. |
| Rule 8: Quality Incentive Program (QIP) Reductions | CAL-007, CAL-018 | gherkin_rules/escal212.feature | Maps QIP indicator to factor and applies reduction for non-AKI. |
| Rule 9: Comorbidity Selection Priority | CAL-011 | gherkin_rules/escal212.feature | Highest-paying comorbidity wins; acute codes take precedence. |
| Rule 10: ESRD Network Fee Reduction | CAL-019 | gherkin_rules/escal212.feature | $0.21 per-diem (0841/0851 + CC74) or $0.50 otherwise. |
