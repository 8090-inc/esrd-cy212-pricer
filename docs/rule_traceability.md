# Rule Traceability & Lineage

## 1. Traceability Matrix
This matrix maps the human and machine-readable business rules back to their exact origin within the COBOL codebase, establishing code-to-rule provenance. 

| Rule ID | Module | Line Range | Business Description | Extracted Rule Category | SME Validation Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| DRV-001 | `ESDRV212` | 397-400 | Reject claims billed before the historical cut-off of 20050401 or completely invalid numeric dates. | Validation | Pending V1 Baseline |
| DRV-002 | `ESDRV212` | 402-405 | Ensure the exception rate is a valid numeric. | Validation | Pending V1 Baseline |
| DRV-003 | `ESDRV212` | 420-424 | Honor Exception Rate for pre-2011 claims directly, without calling PPS calculation logic. | Payment_Override | Pending V1 Baseline |
| DRV-004 | `ESDRV212` | 426-433 | Honor Exception Rate for Pacific Island Trust Territories during the 2011-2013 transition period without calculating PPS blend. | Payment_Override | Pending V1 Baseline |
| DRV-005 | `ESDRV212` | 520-528 | Route 2021 claims to the CY2021 calculation engine. | Routing | Pending V1 Baseline | 
| CAL-001 | `ESCAL212` | 795-884 | Reject claims missing specific condition codes or with missing/invalid Date of Birth, Weight, Height, or Dialysis Session Counts. | Validation | Pending V2 Baseline |
| CAL-002 | `ESCAL212` | 937-945 | Calculate the Adjusted PPS Base Rate using the pre-defined labor and non-labor percentages against the national Base Rate. | Calculation | Pending V2 Baseline |
| CAL-003 | `ESCAL212` | 1076-1112 | Determine the Age Multiplier based on the calculated patient age (current year - DOB year) and the specific dialysis mode (Hemo vs PD). | Calculation | Pending V2 Baseline |
| CAL-004 | `ESCAL212` | 1117-1126 | Calculate the patient's Body Surface Area using the traditional medical formula, then determine the adjustment factor. | Calculation | Pending V2 Baseline |
| CAL-005 | `ESCAL212` | 1131-1139 | Apply a case-mix multiplier for adult patients who are significantly underweight. | Calculation | Pending V2 Baseline |
| CPY-RTC-001/002 | `RTCCPY` | 1-80 | Map integer codes (00-99) passing between caller and module to their semantic business logic outcome (Paid, Adjustments, Rejection Reasons). | Reference Data | Pending V3 Baseline |
| CPY-BILL-001 | `BILLCPY` | 1-260 | The rigid data contract interface defining input structures like condition codes and date strings passed from FISS. | Reference Data | Pending V3 Baseline |
| REF-WAGE-001/BASE-001| `BASECBSA`,`BASERATE`,`BUNDCBSA`,`ESCOM151`,`ESBUN210`,`ESWRT151` | All | Lookup tables for Base Rates and Geographic Multipliers by Calendar Year. | Reference Data | Pending V3 Baseline |
| REF-CHILD-001 | `ESCHI151` | 15-20 | Exemption Wage Indexes for six rigidly defined unique Oscar NPI tags mapping to specific children's hospitals. | Exception Matrix | Pending V3 Baseline |
| HIST-CALC-001 | `ESDRV212` & `ESCAL056`->`202` | N/A | Execute historically locked snapshot of the mathematical model using hardcoded legacy multipliers. | Version Routing | Pending V3 Baseline |

---

## 2. SME Validation Workflow

To ensure the integrity and accuracy of the reverse-engineered rules (both human-readable narratives and JSON machine configurations), the following review cycle is proposed for establishing a production baseline:

### 2.1 Sampling Strategy
Given the volume of rules, a stratified sampling approach will be taken during extraction:
*   **V1 Slice (Driver/Routing logic):** 100% review required due to small footprint.
*   **V2 Slice (Core Calculations):** 100% review required on the Base Rate Initialization, Age/BMI Multipliers, and 20% random sampling of Comorbidity overrides.
*   **V3 Slice (Complete Set):** Review triggered only for structural deviations identified by the Python validation harness, plus spot-checking 10% of new rules.

### 2.2 Review Cycle
1.  **Extraction:** Automated/manual static analysis generates the JSON and Markdown artifacts.
2.  **Linting/Validation:** Rules are passed through the continuous integration test harness (`rule_validator.py`) to ensure structural schema compliance before human review.
3.  **SME Adjudication:** Business analysts and Mainframe SMEs review the Traceability Matrix against the Human-Readable rules.
4.  **Feedback/Correction:** Issues are logged via unique `Rule ID`. The JSON payload and narrative are adjusted accordingly.
5.  **Baseline Approval:** Once an entire Milestone Slice (e.g., V1) passes both schema validation and SME adjudication without dispute, the "Validation Status" moves to `Approved Baseline` and those rules are locked to prevent regression.

### 2.3 Documentation Export
Upon Baseline Approval, the JSON files act as the Vendor-Neutral, machine-readable format. The Python tools can easily parse this single source of truth into Drools, YAML, or any target database structure required by future systems without needing to reinterpret the original COBOL source logic.
