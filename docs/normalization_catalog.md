# Normalization Catalog

This catalog captures data normalization and derived variables used across rules. This is supporting documentation, not a DSL.

## Table
| Norm ID | Name | Source Fields | Derived Field | Purpose | Used By Scenarios | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| NORM-001 | Age (normalized) | B_DOB_DATE, B_LINE_ITEM_DATE_SERVICE | PATIENT_AGE_YEARS | Age-based adjustment selection | TBD | Compute age as of service month per policy. |
| NORM-002 | BSA (normalized) | B_PATIENT_HGT, B_PATIENT_WGT | PATIENT_BSA | Case-mix adjustment | TBD | Derived via policy formula. |
| NORM-003 | BMI (normalized) | B_PATIENT_HGT, B_PATIENT_WGT | PATIENT_BMI | Low BMI adjustment | TBD | Derived via policy formula. |
| NORM-004 | Onset days | B_DIALYSIS_START_DATE, B_LINE_ITEM_DATE_SERVICE | ONSET_DAYS | Onset adjustment eligibility | TBD | Derived via date difference. |
| NORM-005 | Wage index year code | B_THRU_DATE | B_THRU_YEAR_CODE | Ensure wage index year matches claim year | TBD | Derived in driver for bundled CBSA lookup. |
| NORM-006 | Supplemental wage index ratio | BUN_CBSA_W_INDEX, P_SUPP_WI | ESRD_SUPP_WI_RATIO | Cap wage index decreases at 5% | TBD | Applied when supplemental wage index indicator is on. |
| NORM-007 | Hemo-equivalent sessions | B_CLAIM_NUM_DIALYSIS_SESSIONS | HEMO_EQUIV_DIAL_SESSIONS | Per-diem and outlier normalization | TBD | Used to normalize per-diem/outlier values. |
| NORM-008 | CBSA/MSA blend percentages | CBSA_BLEND_PCT, MSA_BLEND_PCT | BLENDED_WAGE_ADJ | Legacy MSA/CBSA blending | TBD | Applies to pre-2011 modules. |
