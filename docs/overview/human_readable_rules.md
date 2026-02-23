# ESRD CY21.2 Pricer: Human-Readable Rule Book

## Overview
This document represents the extracted, human-readable logic for the ESRD CY21.2 Mainframe Pricer, generated through static analysis of the COBOL codebase. 
This baseline document acts as a repository for establishing rule taxonomy, identifying rule boundaries, and defining business logic conditions and actions.

---

## 1. Module: `ESDRV212` (Main Driver)

### 1.1 Taxonomy & Context
*   **Component Type:** Controller / Router
*   **Purpose:** Initial entry point for pricing a claim. Checks bill dates, handles basic specific-case payment rates, attempts to find the correct Wage Index arrays to load, and ultimately routes the claim to the year-specific Calculation module (e.g., `ESCAL212`).
*   **Rule Categories:** 
    *   Pre-Condition Validations
    *   Direct Payment Edits (Overrides)
    *   Calculation Routing (Call Graph Control)

### 1.2 Identified Business Rules

#### Rule DRV-001: Minimum Date Verification
*   **Description:** The system must reject claims billed before a specified historical cut-off.
*   **Condition:** If `B-THRU-DATE` (Bill Thru Date) is less than `20050401` (April 1st, 2005) OR if the `B-THRU-DATE` is not a valid number.
*   **Action:** 
    *   Set Return Code (`PPS-RTC`) to `98`.
    *   Exit Driver logic immediately (skip all processing).

#### Rule DRV-002: Exception Rate Verification
*   **Description:** The system must ensure that if an exception rate exists on the bill, it is a valid numeric format.
*   **Condition:** If `P-ESRD-RATE` (Exception Rate) is not numeric.
*   **Action:** 
    *   Set Return Code (`PPS-RTC`) to `50`.
    *   Exit Driver logic immediately (skip all processing).

#### Rule DRV-003: Pre-PPS Blended Payment Override
*   **Description:** For claims occurring before the introduction of the Bundled Payment System (PPS) on January 1st, 2011, if the claim has an exception rate, that rate dictates the final payment amount without further calculation.
*   **Condition:** If `B-THRU-DATE` is less than `20110101` AND `P-ESRD-RATE` > 0.
*   **Action:**
    *   Set Final Payment Amount (`PPS-FINAL-PAY-AMT`) to the Exception Rate (`P-ESRD-RATE`).
    *   Set Return Code (`PPS-RTC`) to `01`.
    *   Exit Driver logic immediately (do not call calculation subroutines).
*   **Policy Reference:** Pub 100-02, Ch 11 §70 (ESRD PPS Transition Period / Exception Rates).

#### Rule DRV-004: Pacific Island Trust Territory Exception (2011-2013)
*   **Description:** During the PPS transition period (Jan 2011 - Dec 2013), providers in the Pacific Island Trust Territories who have an exception rate are exempt from the blended methodology and are paid their exception rate directly.
*   **Condition:** If `B-THRU-DATE` is between `20110101` and `20131231` (inclusive) AND Provider is in a Pacific Island Trust Territory (`P-PACIFIC-IS-TRUST-TERR` = '2') AND `P-ESRD-RATE` > 0.
*   **Action:**
    *   Set Final Payment Amount (`PPS-FINAL-PAY-AMT`) to the Exception Rate (`P-ESRD-RATE`).
    *   Set Return Code (`PPS-RTC`) to `01`.
    *   Exit Driver logic immediately (do not call calculation subroutines).
*   **Policy Reference:** Pub 100-02, Ch 11 §70 (ESRD PPS Transition Period / Exception Rates).

#### Rule DRV-005: 2021.2 Calculation Routing
*   **Description:** The system routes the claim to the calculation engine designed for Calendar Year 2021 processing.
*   **Condition:** If `B-THRU-DATE` is between `20210101` and `20211231` (inclusive).
*   **Action:**
    *   Call subroutine `ESCAL212`.
    *   Pass the following data structures: `BILL-NEW-DATA`, `PPS-DATA-ALL`, `WAGE-NEW-RATE-RECORD`, `COM-CBSA-WAGE-RECORD`, `BUN-CBSA-WAGE-RECORD`.
    *   Exit Driver logic after return.

---

## 2. Module: `ESCAL212` (CY 2021 Calculation Engine)

### 2.1 Taxonomy & Context
*   **Component Type:** Business Logic & Mathematical Engine
*   **Purpose:** The core calculation logic for processing ESRD claims after the `ESDRV212` has performed initial verifications and loaded the relevant datasets.
*   **Rule Categories:** 
    *   Condition Code Validation
    *   Base Rate Initialization
    *   Patient Characteristic Adjustments (Age, BSA, BMI)
    *   QIP/Penalty Reductions

### 2.2 Identified Business Rules

#### Rule CAL-001: General Claim Validation
*   **Description:** The system must reject claims missing specific condition codes or with missing/invalid Date of Birth, Weight, Height, or Dialysis Session Counts.
*   **Condition:** If `B-COND-CODE` is not 73, 74, 84, 87, or blank; OR if DOB is invalid; OR if Weight > 500 or Height > 300.
*   **Action:** 
    *   Set appropriate specific Return Code (`PPS-RTC` array of 58, 54, 55, 56, 71, 72).
    *   Halt calculation.
*   **Policy Reference:** Pub 100-04, Ch 8 §20 (Per Treatment Payment Amount – claim data) and §20.1 (ESRD PPS adjustments list).

#### Rule CAL-001A: Additional Validation Edits (Detailed)
*   **Description:** The calculation module contains additional edit checks beyond CAL-001, each mapped to a specific rejection return code.
*   **Condition → Action (RTC):**
    *   Provider Type not in 40/41/05 → `52`
    *   Special Payment Indicator not in `1` or blank → `53`
    *   Revenue Code not in `0821/0831/0841/0851/0881` → `57`
    *   QIP Reduction code not in `1/2/3/4` or blank → `53`
    *   Dialysis Session Count missing/non-numeric → `73`
    *   Line Item Date of Service missing/non-numeric → `74`
    *   Dialysis Start Date non-numeric → `75`
    *   Total Separately Billable Outlier amount non-numeric → `76`
    *   Comorbid CWF return code invalid (non-AKI) → `81`
*   **Policy Reference:** Pub 100-04, Ch 8 §20 (Per Treatment Payment Amount – claim data) and 42 CFR §413.177 (QIP reduction scale).

#### Rule CAL-002: Base Wage Amount Calculation
*   **Description:** Calculate the Adjusted PPS Base Rate using the pre-defined labor and non-labor percentages against the national Base Rate, adjusted by the local Wage Index. 
*   **Condition:** Pre-calculation step (Runs unconditionally if valid claim).
*   **Action:**
    *   `Labor Amount` = (`BUNDLED-BASE-PMT-RATE` * `BUN-NAT-LABOR-PCT`) * `BUN-CBSA-W-INDEX`.
    *   `Non-Labor Amount` = `BUNDLED-BASE-PMT-RATE` * `BUN-NAT-NONLABOR-PCT`.
    *   `Base Wage Amount` = `Labor Amount` + `Non-Labor Amount`.
*   **Policy Reference:** CMS-1732-F (CY2021 ESRD PPS Final Rule – Base Rate and Wage Index updates).

#### Rule CAL-003: Age Adjustment Multiplier
*   **Description:** Determine the Age Multiplier based on the calculated patient age (current year - DOB year) and the specific dialysis mode (Hemo vs PD).
*   **Condition & Action Mapping:**
    *   If Age < 13 & Mode = Hemo -> Multiplier = `1.306` (EB-AGE-LT-13-HEMO-MODE)
    *   If Age < 13 & Mode = PD -> Multiplier = `1.063` (EB-AGE-LT-13-PD-MODE)
    *   If Age 13-17 & Mode = Hemo -> Multiplier = `1.327` (EB-AGE-13-17-HEMO-MODE)
    *   If Age 13-17 & Mode = PD -> Multiplier = `1.102` (EB-AGE-13-17-PD-MODE)
    *   If Age 18-44 -> Multiplier = `1.257` (CM-AGE-18-44)
    *   If Age 45-59 -> Multiplier = `1.068` (CM-AGE-45-59)
    *   If Age 60-69 -> Multiplier = `1.070` (CM-AGE-60-69)
    *   If Age 70-79 -> Multiplier = `1.000` (CM-AGE-70-79)
    *   If Age 80+ -> Multiplier = `1.109` (CM-AGE-80-PLUS)
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Case-Mix Adjustments – adult and pediatric age factors).

#### Rule CAL-004: BSA Factor Calculation
*   **Description:** Calculate the patient's Body Surface Area using the traditional medical formula, then determine the adjustment factor if the patient is over 17.
*   **Formula:** BSA = 0.007184 * (Height^0.725) * (Weight^0.425).
*   **Condition:** If Age > 17.
*   **Action:** 
    *   `BSA Factor` = `CM-BSA` (1.032) ^ ((`Calculated BSA` - `BSA-NATIONAL-AVERAGE` [1.90]) / 0.1).
    *   *(Note: If Age <= 17, `BSA Factor` = 1.000)*
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Case-Mix Adjustments – BSA formula and factor).

#### Rule CAL-005: Low BMI Adjustment
*   **Description:** Apply a case-mix multiplier for adult patients who are significantly underweight.
*   **Formula:** BMI = (Weight / (Height^2)) * 10000.
*   **Condition:** If Age > 17 AND Calculated BMI < 18.5.
*   **Action:** 
    *   Set `BMI Factor` = `CM-BMI-LT-18-5` (1.017).
    *   *(Note: Otherwise, `BMI Factor` = 1.000)*
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Case-Mix Adjustments – BMI threshold and factor).

#### Rule CAL-006: AKI Claim Shortcut
*   **Description:** Acute Kidney Injury claims bypass the full bundled factor calculation.
*   **Condition:** If `B-COND-CODE` = `84`.
*   **Action:**
    *   Set `H-PPS-FINAL-PAY-AMT` = `H-BUN-BASE-WAGE-AMT`.
    *   Set `PPS-RTC` = `02`.
    *   Set `PPS-2011-COMORBID-PAY` = `10`.
*   **Policy Reference:** Pub 100-04, Ch 8 §40 (AKI Claims).

#### Rule CAL-007: QIP Reduction Mapping
*   **Description:** Apply Quality Incentive Program reduction to final computed payment amounts (except AKI).
*   **Condition & Action Mapping:**
    *   If `P-QIP-REDUCTION` = blank → `QIP-REDUCTION` = 1.000
    *   If `P-QIP-REDUCTION` = `1` → `QIP-REDUCTION` = 0.995
    *   If `P-QIP-REDUCTION` = `2` → `QIP-REDUCTION` = 0.990
    *   If `P-QIP-REDUCTION` = `3` → `QIP-REDUCTION` = 0.985
    *   If `P-QIP-REDUCTION` = `4` → `QIP-REDUCTION` = 0.980
*   **Policy Reference:** 42 CFR §413.177 (QIP payment reduction scale).

#### Rule CAL-008: Age Calculation
*   **Description:** Compute patient age using the bill year minus DOB year, minus one if DOB month is after bill month.
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Case-Mix Adjustments).

#### Rule CAL-009: Onset Factor
*   **Description:** For adults, compute dialysis onset days and apply onset multiplier if ≤120 days.
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Onset adjustment).

#### Rule CAL-010/011: Comorbidity Normalization & Selection
*   **Description:** Normalize CWF comorbidity return codes into internal comorbidity codes and select the highest multiplier, unless pediatric or onset logic suppresses comorbid payment.
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Comorbidity adjusters).

#### Rule CAL-012: Low Volume Factor
*   **Description:** Apply low-volume multiplier for adult low-volume providers.
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Low-volume adjustment).

#### Rule CAL-013: Rural Factor
*   **Description:** Apply rural adjustment multiplier for adult claims with CBSA < 100.
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Rural adjustment).

#### Rule CAL-014: Adjusted Base Wage Amount
*   **Description:** Multiply all case-mix factors to derive the adjusted base wage amount.
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Case-Mix Adjustments).

#### Rule CAL-015: Training Add-On / Per-Diem
*   **Description:** Apply training add-on for condition codes 73/87; compute per-diem for home dialysis (cond code 74 with rev 0841/0851).
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Training and per-diem).

#### Rule CAL-016: Final Payment With/Without HDPA
*   **Description:** Compute final PPS payment amounts for per-diem or full PPS claims.
*   **Policy Reference:** Pub 100-02, Ch 11 §60 (Payment calculation).

#### Rule CAL-017: TDAPA / TPNIES Add-Ons
*   **Description:** Compute TDAPA and TPNIES per-treatment add-ons and include them in final payment.
*   **Policy Reference:** CMS-1732-F (CY2021 ESRD PPS Final Rule).

#### Rule CAL-018: QIP Reduction Application
*   **Description:** Apply QIP reduction to final payment amounts (non-AKI).
*   **Policy Reference:** 42 CFR §413.177.

#### Rule CAL-019: Network Reduction
*   **Description:** Subtract $0.50 for full PPS or $0.21 for per-diem claims.
*   **Policy Reference:** Pub 100-04, Ch 8 §110.

#### Rule CAL-020: HDPA Selection (ETC)
*   **Description:** Use HDPA-adjusted PPS amount when ETC indicator is set; otherwise use standard PPS amount.
*   **Policy Reference:** ETC Final Rule (§512.300–§512.350).

#### Rule CAL-021: Outlier Calculation
*   **Description:** Compute outlier MAP, compare to imputed MAP, and calculate outlier payment.
*   **Policy Reference:** CMS-1732-F (Outlier policy updates) and Pub 100-02 Ch 11 §60.

#### Rule CAL-022: Return Code Resolution Matrix
*   **Description:** Assign final PPS-RTC based on combinations of outlier, comorbidity, onset, low-volume, training, pediatric, and low BMI flags.
*   **Policy Reference:** RTCCPY (internal return-code definitions).

#### Rule CAL-023: Low Volume Recovery Payments
*   **Description:** Compute low-volume recovery adjustments to PPS and outlier components.
*   **Policy Reference:** Pub 100-02, Ch 11 §60.

---

## 6. Policy Traceability
Full policy-to-rule mapping: `docs/legacy/policy_traceability.md`.

## 7. Policy Gaps & Mismatches
Discrepancy log: `docs/policy/policy_gap_log.md`.

---

## 3. Data Dictionary: Interfaces & Copybooks

### 3.1 `RTCCPY` (Return Codes)
The system uses `PPS-RTC` to signal calculation success, failure, or applied adjustments back to the driver/FISS.
*   **Payment Adjustments (00-49):**
    *   `02`: No adjustments.
    *   `03`: With Outlier.
    *   `04`: With Acute Comorbid.
    *   `05`: With Chronic Comorbid.
    *   `08`: With Onset.
    *   `10`: With Low Volume.
    *   `11`: With Training.
    *   `14`: With Pediatric.
    *   `31`: With Low BMI.
*   **Rejection Codes (50-99):**
    *   `52`: Invalid Provider Type (Not 40 or 41).
    *   `54`: Invalid Date of Birth.
    *   `55`/`56`: Invalid Height or Weight.
    *   `58`: Invalid Condition Code.
    *   `60`/`61`: CBSA Wage Index not found.

### 3.2 `BILLCPY` (Input Interface payload)
The caller (e.g. FISS system) passes a populated payload that must adhere to this contract.
*   `B-REV-CODE` (String 4): The specific Revenue Code (e.g., "0821" or "0881" for Hemo vs PD).
*   `B-COND-CODE` (String 2): Claim Condition Code (e.g., 73, 74, 84, 87).
*   `B-PATIENT-HGT` / `B-PATIENT-WGT` (Decimal): Patient bio-metrics used for BMI and BSA calculation.
*   `B-THRU-DATE`: (CCYYMMDD): Billing End Date used for module routing.
*   `P-ESRD-RATE` (Decimal): The specific overriding exception rate for transition/old claims.

---

## 4. Reference Data Tables (Geographic Adjustments & Rates)

The system utilizes several pre-defined reference tables, either as hardcoded arrays in COBOL Copybooks or as external flat files, to define historical geographic wage indexes and base payment rates.

*   `ESCOM151`: Composite CBSA Wage Record. Contains hardcoded CBSA values mapping to Wage Index multipliers for Calendar Years 2006 through 2013.
*   `ESBUN210`: Bundled CBSA Wage Index. Contains hardcoded CBSA values mapping to Wage Index multipliers for the fully implemented bundled payment years (2011 and later).
*   `ESWRT151`: MSA Wage-Adjusted Rates. Maps older Metropolitan Statistical Area (MSA) codes to their historical rates.
*   `BASECBSA` & `BUNDCBSA`: Flat-file representations of the CBSA data arrays.
*   `BASERATE`: Flat file containing the National Base Payment Rate by year.
*   `ESCHI151`: **Special Children's Wage Index.** A customized, hardcoded override array strictly containing exactly 6 specific Provider OSCAR Numbers for Children's Hospitals (e.g. `093300`, `263302`) that trigger a specialized Wage Index overriding standard geographic calculations.

---

## 5. Historical Calculation Engines (Legacy Modules)

While `ESCAL212` represents the modern baseline of the calculation pricing rules, the source codebase includes 20 specific legacy legacy execution modules (`ESCAL056` through `ESCAL202`) intended to price retrospective claims precisely based on the static data applicable during those years.

### Rule HIST-001: Historical Versioning & Routing
The controller (`ESDRV212`) selects the appropriate execution engine by directly mapping the Bill Thru Date to a particular static module. The executed rules remain structurally identical to the logic documented for `ESCAL212`, except they substitute historically locked hardcoded values for variables such as Base Rates, low-volume thresholds, or distinct Age Multipliers mapping to those specific years.
*   **2005-04-01 -> 2005-12-31**: Calls `ESCAL056`
*   **2006-01-01 -> 2006-12-31**: Calls `ESCAL062`
*   **2007-01-01 -> 2007-03-31**: Calls `ESCAL070`
*   **2007-04-01 -> 2007-12-31**: Calls `ESCAL071` (patch)
*   **2008-01-01 -> 2008-12-31**: Calls `ESCAL080`
*   **2009-01-01 -> 2009-12-31**: Calls `ESCAL091`
*   **2010-01-01 -> 2010-12-31**: Calls `ESCAL100`
*   **2011-01-01 -> 2011-12-31**: Calls `ESCAL117`
*   **2012-01-01 -> 2012-12-31**: Calls `ESCAL122`
*   **2013-01-01 -> 2013-12-31**: Calls `ESCAL130`
*   **2014-01-01 -> 2014-12-31**: Calls `ESCAL140`
*   **2015-01-01 -> 2015-12-31**: Calls `ESCAL151`
*   **2016-01-01 -> 2016-12-31**: Calls `ESCAL160`
*   **2017-01-01 -> 2017-06-30**: Calls `ESCAL170`
*   **2017-07-01 -> 2017-12-31**: Calls `ESCAL171` (patch)
*   **2018-01-01 -> 2018-12-31**: Calls `ESCAL180`
*   **2019-01-01 -> 2019-12-31**: Calls `ESCAL191`
*   **2020-01-01 -> 2020-06-30**: Calls `ESCAL200`
*   **2020-07-01 -> 2020-12-31**: Calls `ESCAL202` (patch)
*   **2021-01-01 -> 2021-12-31**: Calls `ESCAL212`
