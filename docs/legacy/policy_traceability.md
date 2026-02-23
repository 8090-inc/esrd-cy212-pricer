# Policy Traceability Appendix (CY2021.2)

This appendix maps COBOL/DSL rule IDs to authoritative CMS policy sources and sections.

## Policy Sources
- Pub 100-04 (Medicare Claims Processing Manual), Chapter 8
- Pub 100-02 (Medicare Benefit Policy Manual), Chapter 11
- CY 2021 ESRD PPS Final Rule (CMS-1732-F)
- 42 CFR 413.177 (ESRD QIP payment reduction scale)
- ETC Model Final Rule (Medicare Program; Specialty Care Models to Improve Quality of Care and Reduce Expenditures)

## Rule-to-Policy Mapping
| Rule ID(s) | Policy Source | Section | Policy Scope |
| --- | --- | --- | --- |
| DRV-003, DRV-004 | Pub 100-02 | Ch 11 §70 (ESRD PPS Transition Period) | Exception rates during transition period; exception termination after 2014. |
| CAL-000, CAL-001C | Pub 100-04 | Ch 8 §20 (Per Treatment Payment Amount – claim data) | Valid condition and revenue codes for ESRD PPS per-treatment claims. |
| CAL-001D, CAL-007, CAL-018 | 42 CFR | §413.177 | QIP payment reduction scale (0.5% per 10 points, up to 2%). |
| CAL-001P, CAL-006 | Pub 100-04 | Ch 8 §40 (AKI Claims) | AKI billing under ESRD PPS and AKI claim handling. |
| CAL-002 | CMS-1732-F | II.B.4 (CY2021 Base Rate, wage index) | Base rate update and wage index application for CY2021. |
| CAL-003A/B | Pub 100-02 | Ch 11 §60 (Case-Mix Adjustments) | Adult and pediatric age/modality case-mix adjusters. |
| CAL-004/004B | Pub 100-02 | Ch 11 §60 (Case-Mix Adjustments) | BSA formula and BSA factor definition. |
| CAL-005/005B | Pub 100-02 | Ch 11 §60 (Case-Mix Adjustments) | BMI formula and low BMI threshold (18.5) with factor 1.017. |
| CAL-019 | Pub 100-04 | Ch 8 §110 | ESRD network reduction ($0.50 full PPS; $0.21 per-diem). |
| CAL-021 (Outlier Rules) | CMS-1732-F | II.B.4.c (Outlier Policy) | CY2021 MAP/FDL updates and methodology. |
| CAL-017 | CMS-1732-F | II.B (Drug/Tech Add-on Policies) | TDAPA and TPNIES policy updates. |
| CAL-020 | ETC Final Rule | §512.300–§512.350 | Home Dialysis Payment Adjustment for ETC participants (2021–2023). |
| CAL-008/009/010/011/012/013/014 | Pub 100-02 | Ch 11 §60 | Case-mix factors (onset, comorbid, low-volume, rural, training). |

## Exports
- CSV: `docs/legacy/policy_traceability.csv`
- JSON: `docs/legacy/policy_traceability.json`
