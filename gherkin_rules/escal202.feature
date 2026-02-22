Feature: ESRD PPS calculation engine (ESCAL202)
  # Description: Validates inputs, computes bundled adjustments, outlier payments, and return codes for CY2020.2.
  # COBOL: ESCAL202 (0000-START-TO-FINISH, 1000-VALIDATE-BILL-ELEMENTS, 1200-INITIALIZATION, 2000-CALCULATE-BUNDLED-FACTORS,
  #        2100-CALC-COMORBID-ADJUST, 2500-CALC-OUTLIER-FACTORS, 3000-LOW-VOL-FULL-PPS-PAYMENT,
  #        3100-LOW-VOL-OUT-PPS-PAYMENT, 9000-SET-RETURN-CODE)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2020-07-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given a claim is submitted for pricing


  Rule: Force full PPS processing for all claims
    # Description: The pricer forces the waive-blend indicator to Y so all bills are processed as 100% PPS.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 072100-072100): MOVE "Y" TO P-PROV-WAIVE-BLEND-PAY-INDIC.

    @rule_id:CAL202-001O
    Scenario: Force waive-blend indicator to Y
      Given a claim is loaded for pricing
      When pricing begins
      Then the waive-blend indicator is set to "Y"
      And full PPS processing is enforced

  Rule: Short-circuit AKI claims
    # Description: AKI claims (condition code 84) bypass bundled factor calculations and use the base wage amount.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL202 (Lines 073600-074400): If B-COND-CODE = 84, set final pay to base wage amount, RTC 02, comorbid pay 10.

    @rule_id:CAL202-001P
    Scenario: AKI claims bypass bundled factor calculations
      Given the claim condition code is 84
      When pricing continues after initialization
      Then the final payment equals the bundled base wage amount
      And the return code is 02

  Rule: Validate condition codes
    # Description: Condition codes must be one of 73, 74, 84, 87, or blank.
    # Policy Citations:
    # - CLM104C08-REV10640 §50.3 Condition Code Structure (73/74/84/87) (P21:L762-774; P22:L788-791)
    # Code Path Citations:
    # - ESCAL202 (Lines 075500-075900): If B-COND-CODE not in 73/74/84/87/blank -> RTC 58.

    @rule_id:CAL202-000
    Scenario: Reject claims with invalid condition codes
      Given the claim condition code is not 73, 74, 84, 87, or blank
      When bill elements are validated
      Then the return code is 58
      And calculation is not executed

  Rule: Validate provider type
    # Description: Provider type must be 40, 41, or 05.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 076200-076700): If P-PROV-TYPE not 40/41/05 -> RTC 52.

    @rule_id:CAL202-001A
    Scenario: Reject claims with invalid provider type
      Given the provider type is not 40, 41, or 05
      When bill elements are validated
      Then the return code is 52
      And calculation is not executed

  Rule: Validate special payment indicator
    # Description: Special payment indicator must be "1" or blank.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 077000-077300): If P-SPEC-PYMT-IND not 1 or blank -> RTC 53.

    @rule_id:CAL202-001B
    Scenario: Reject claims with invalid special payment indicator
      Given the special payment indicator is not "1" or blank
      When bill elements are validated
      Then the return code is 53
      And calculation is not executed

  Rule: Validate date of birth
    # Description: DOB must be present and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 077600-078000): If DOB is zero or not numeric -> RTC 54.

    @rule_id:CAL202-001N
    Scenario: Reject claims with invalid date of birth
      Given the date of birth is missing or non-numeric
      When bill elements are validated
      Then the return code is 54
      And calculation is not executed

  Rule: Validate weight for non-AKI claims
    # Description: Weight is required and numeric for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL202 (Lines 078200-078700): If not AKI and weight is zero or not numeric -> RTC 55.

    @rule_id:CAL202-001E
    Scenario: Reject non-AKI claims with invalid weight
      Given the claim is not AKI and weight is zero or non-numeric
      When bill elements are validated
      Then the return code is 55
      And calculation is not executed

  Rule: Validate height for non-AKI claims
    # Description: Height is required and numeric for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL202 (Lines 079000-079600): If not AKI and height is zero or not numeric -> RTC 56.

    @rule_id:CAL202-001F
    Scenario: Reject non-AKI claims with invalid height
      Given the claim is not AKI and height is zero or non-numeric
      When bill elements are validated
      Then the return code is 56
      And calculation is not executed

  Rule: Validate revenue code
    # Description: Revenue code must be 0821, 0831, 0841, 0851, or 0881.
    # Policy Citations:
    # - CLM104C08-REV10640 §50.3 Condition Code Structure (73/74/84/87) (P21:L762-774; P22:L788-791)
    # Code Path Citations:
    # - ESCAL202 (Lines 079800-080400): If B-REV-CODE not in 0821/0831/0841/0851/0881 -> RTC 57.

    @rule_id:CAL202-001C
    Scenario: Reject claims with invalid revenue code
      Given the revenue code is not 0821, 0831, 0841, 0851, or 0881
      When bill elements are validated
      Then the return code is 57
      And calculation is not executed

  Rule: Validate QIP reduction code
    # Description: QIP reduction code must be 1-4 or blank.
    # Policy Citations:
    # - CLM104C08-REV10640 §20.3 QIP Reduction Codes (P17:L619-624)
    # Code Path Citations:
    # - ESCAL202 (Lines 080700-081400): If P-QIP-REDUCTION not 1-4 or blank -> RTC 53.

    @rule_id:CAL202-001D
    Scenario: Reject claims with invalid QIP reduction code
      Given the QIP reduction code is not 1, 2, 3, 4, or blank
      When bill elements are validated
      Then the return code is 53
      And calculation is not executed

  Rule: Validate height upper bound
    # Description: Non-AKI height must not exceed 300.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL202 (Lines 081700-082300): If not AKI and height > 300 -> RTC 71.

    @rule_id:CAL202-001G
    Scenario: Reject non-AKI claims with height over 300
      Given the claim is not AKI and height exceeds 300
      When bill elements are validated
      Then the return code is 71
      And calculation is not executed

  Rule: Validate weight upper bound
    # Description: Non-AKI weight must not exceed 500.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL202 (Lines 082500-083100): If not AKI and weight > 500 -> RTC 72.

    @rule_id:CAL202-001H
    Scenario: Reject non-AKI claims with weight over 500
      Given the claim is not AKI and weight exceeds 500
      When bill elements are validated
      Then the return code is 72
      And calculation is not executed

  Rule: Validate dialysis session count
    # Description: Dialysis session count must be present and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 083800-084300): If session count zero or not numeric -> RTC 73.

    @rule_id:CAL202-001I
    Scenario: Reject claims with invalid dialysis session count
      Given the dialysis session count is zero or non-numeric
      When bill elements are validated
      Then the return code is 73
      And calculation is not executed

  Rule: Validate line item date of service
    # Description: Line item date of service must be present and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 084500-085000): If line item date is zero or not numeric -> RTC 74.

    @rule_id:CAL202-001J
    Scenario: Reject claims with invalid line item date of service
      Given the line item date of service is zero or non-numeric
      When bill elements are validated
      Then the return code is 74
      And calculation is not executed

  Rule: Validate dialysis start date
    # Description: Dialysis start date must be numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 085200-085600): If dialysis start date not numeric -> RTC 75.

    @rule_id:CAL202-001K
    Scenario: Reject claims with invalid dialysis start date
      Given the dialysis start date is non-numeric
      When bill elements are validated
      Then the return code is 75
      And calculation is not executed

  Rule: Validate outlier total charges
    # Description: Outlier total charge must be numeric.
    # Policy Citations:
    # - BP102C11-REV257 §60.D Outlier Payment Calculation (P47:L1885-1893)
    # Code Path Citations:
    # - ESCAL202 (Lines 085800-086200): If outlier total not numeric -> RTC 76.

    @rule_id:CAL202-001L
    Scenario: Reject claims with invalid outlier total charges
      Given the outlier total charges are non-numeric
      When bill elements are validated
      Then the return code is 76
      And calculation is not executed

  Rule: Validate comorbid CWF return code
    # Description: Comorbid return code must be blank or one of 10, 20, 40, 50, 60 for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL202 (Lines 087500-088400): If not AKI and comorbid return code not in set -> RTC 81.

    @rule_id:CAL202-001M
    Scenario: Reject non-AKI claims with invalid comorbid return code
      Given the claim is not AKI and the comorbid return code is not blank, 10, 20, 40, 50, or 60
      When bill elements are validated
      Then the return code is 81
      And calculation is not executed

  Rule: Compute bundled base wage amount
    # Description: Compute labor and non-labor portions and sum into bundled base wage amount.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 089600-090400): Compute labor and non-labor amounts and base wage amount.

    @rule_id:CAL202-002
    Scenario: Compute bundled base wage amount
      Given the claim has a bundled base payment rate and wage index
      When base wage calculations begin
      Then the bundled base wage amount equals labor plus non-labor portions
      And the base wage amount is stored for downstream adjustments

  Rule: Compute patient age at service month
    # Description: Age is computed from thru date year minus DOB year, adjusted when DOB month is after thru month.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 090800-091400): Compute H-PATIENT-AGE and adjust for month.

    @rule_id:CAL202-008
    Scenario: Compute patient age for factor selection
      Given the claim includes DOB and thru date
      When patient age is determined
      Then age is adjusted for birth month relative to service month
      And pediatric tracking is set when age is under 18

  Rule: Map QIP reduction codes to factors
    # Description: QIP reduction codes map to 1.000, 0.995, 0.990, 0.985, or 0.980 factors.
    # Policy Citations:
    # - CLM104C08-REV10640 §20.3 QIP Reduction Codes (P17:L619-624)
    # Code Path Citations:
    # - ESCAL202 (Lines 091800-093900): Map P-QIP-REDUCTION to QIP-REDUCTION factor.

    @rule_id:CAL202-007
    Scenario: Map QIP reduction codes to reduction factors
      Given a claim includes a QIP reduction code
      When the reduction factor is determined
      Then the correct QIP reduction factor is selected
      And it is used later in QIP application

  Rule: Normalize comorbid data based on CWF return code
    # Description: When CWF return code is present, comorbid data is moved to holding and mapped to internal codes.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.2 Comorbidity Adjustments (single highest) (P39:L1570-1573)
    # Code Path Citations:
    # - ESCAL202 (Lines 095300-103100): Move comorbid data to holding and map codes based on CWF return code.

    @rule_id:CAL202-010
    Scenario: Normalize comorbid data for consistent evaluation
      Given a claim includes a CWF comorbid return code
      When comorbidity codes are interpreted for evaluation
      Then comorbid data is moved to holding and mapped to MA/MC/MD/ME as appropriate
      And the original values are preserved for later restoration

  Rule: Set pediatric age adjustment factors
    # Description: Pediatric factors depend on age thresholds and hemo vs PD modality.
    # Policy Citations:
    # - CLM104C08-REV10640 §20.2 Pediatric Payment Model (under 18) (P16:L602-606)
    # Code Path Citations:
    # - ESCAL202 (Lines 103500-105000): Pediatric age factor selection by age and revenue code.

    @rule_id:CAL202-003A
    Scenario: Apply pediatric age adjustment factors
      Given the patient age is under 18
      When age adjustment factors are selected
      Then the pediatric factor is selected based on age band and modality
      And the factor is stored for bundled calculations

  Rule: Set adult age adjustment factors
    # Description: Adult factors follow age bands 18-44, 45-59, 60-69, 70-79, 80+.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 Adult Age Bands (P36:L1467-1472)
    # Code Path Citations:
    # - ESCAL202 (Lines 105100-107100): Adult age factor selection by age bands.

    @rule_id:CAL202-003B
    Scenario: Apply adult age adjustment factors
      Given the patient age is 18 or older
      When age adjustment factors are selected
      Then the adult factor is selected based on age band
      And the factor is stored for bundled calculations

  Rule: Compute BSA and apply BSA factor
    # Description: BSA is computed using height/weight and applied for adults; pediatric defaults to 1.0.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BSA formula (P36:L1443-1445)
    # Code Path Citations:
    # - ESCAL202 (Lines 107600-108500): Compute BSA and BSA factor for adults; pediatric defaults to 1.000.

    @rule_id:CAL202-004
    Scenario: Compute BSA adjustment factor
      Given patient height and weight are available
      When BSA is calculated
      Then adult BSA factor is computed from the BSA formula
      And pediatric BSA factor defaults to 1.000

  Rule: Default BSA factor for pediatric claims
    # Description: Pediatric claims use a default BSA factor of 1.000.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BSA formula (P36:L1443-1445)
    # Code Path Citations:
    # - ESCAL202 (Lines 108300-108500): Pediatric path moves 1.000 to H-BUN-BSA-FACTOR.

    @rule_id:CAL202-004B
    Scenario: Default pediatric BSA factor to 1.000
      Given the patient age is under 18
      When the BSA factor is applied
      Then the BSA factor is 1.000
      And no additional BSA adjustment is applied

  Rule: Compute BMI and apply low BMI factor
    # Description: BMI is computed and a low-BMI factor is applied for adults with BMI < 18.5.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BMI formula (low BMI < 18.5) (P38:L1503-1507)
    # Code Path Citations:
    # - ESCAL202 (Lines 109000-109800): Compute BMI and apply low BMI factor when < 18.5 for adults.

    @rule_id:CAL202-005
    Scenario: Compute BMI adjustment factor
      Given patient height and weight are available
      When BMI is calculated
      Then low BMI factor is applied for adults below 18.5
      And otherwise BMI factor defaults to 1.000

  Rule: Default BMI factor for non-low BMI claims
    # Description: BMI factor defaults to 1.000 when low BMI criteria are not met.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BMI formula (low BMI < 18.5) (P38:L1503-1507)
    # Code Path Citations:
    # - ESCAL202 (Lines 109600-109800): Else branch moves 1.000 to H-BUN-BMI-FACTOR.

    @rule_id:CAL202-005B
    Scenario: Default BMI factor to 1.000 when low BMI criteria are not met
      Given the patient does not meet low BMI criteria
      When the BMI factor is applied
      Then the BMI factor is 1.000
      And no low BMI adjustment is applied

  Rule: Compute onset adjustment factor
    # Description: Onset factor applies to adult claims within 120 days of dialysis start.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 Onset of Dialysis (≤120 days) (P38:L1516-1537)
    # Code Path Citations:
    # - ESCAL202 (Lines 110300-112600): Compute onset days and apply onset factor for adults <=120 days.

    @rule_id:CAL202-009
    Scenario: Apply onset adjustment factor
      Given dialysis start date and service date are present
      When dialysis onset days are calculated
      Then adult claims within 120 days receive the onset factor
      And others receive a factor of 1.000

  Rule: Select comorbid adjustment multiplier
    # Description: Comorbid multiplier selection depends on age, onset, and comorbid return code; highest paying comorbid is selected.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.2 Comorbidity Adjustments (single highest) (P39:L1570-1573)
    # Code Path Citations:
    # - ESCAL202 (Lines 113100-117100): Set comorbid multiplier by age, onset, and CWF code.
    # - ESCAL202 (Lines 131700-138400): 2100-CALC-COMORBID-ADJUST selects highest paying comorbid.

    @rule_id:CAL202-011
    Scenario: Select bundled comorbid multiplier
      Given comorbid data and CWF return codes are available
      When the comorbidity adjustment is selected
      Then the highest paying comorbid category is applied
      And comorbid tracking flags are updated

  Rule: Apply low volume adjustment
    # Description: Low volume adjustment applies to adult claims when provider indicator is Y.
    # Policy Citations:
    # - CLM104C08-REV10640 Low-Volume ESRD Facilities Adjustment (P11:L411-419)
    # Code Path Citations:
    # - ESCAL202 (Lines 117600-118800): Apply low volume multiplier for adults when indicator is Y.

    @rule_id:CAL202-012
    Scenario: Apply low volume multiplier for adults
      Given provider low volume indicator is Y
      When low-volume eligibility is evaluated
      Then adult claims receive the low volume multiplier
      And pediatric claims default to 1.000

  Rule: Apply rural adjustment
    # Description: Rural adjustment applies when CBSA < 100 and adult age.
    # Policy Citations:
    # - CMS-ESRDPAYMENT Facility-Level Adjustments include rural adjustment (HTML:L793-795)
    # Code Path Citations:
    # - ESCAL202 (Lines 119300-119600): If CBSA < 100 and adult -> rural multiplier else 1.000.

    @rule_id:CAL202-013
    Scenario: Apply rural adjustment multiplier
      Given the facility CBSA code is below 100
      When rural eligibility is evaluated
      Then adult claims receive the rural multiplier
      And others receive a multiplier of 1.000

  Rule: Compute adjusted base wage amount
    # Description: Adjusted base wage is computed from base wage and case-mix factors.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 120100-120500): Compute H-BUN-ADJUSTED-BASE-WAGE-AMT using factors.

    @rule_id:CAL202-014
    Scenario: Compute adjusted base wage amount
      Given all bundled case-mix factors are available
      When the base payment is adjusted
      Then the base wage amount is multiplied by the case-mix factors
      And the adjusted base wage amount is stored

  Rule: Apply training add-on and per-diem logic
    # Description: Training add-on applies for condition codes 73/87; per-diem applies for condition code 74 with CAPD/CCPD revenue codes.
    # Policy Citations:
    # - CLM104C08-REV12979 §50.8 Training Add-On Payment (P32:L1112-1121)
    # Code Path Citations:
    # - ESCAL202 (Lines 121100-124100): Training add-on and per-diem calculations with HDPA variants.

    @rule_id:CAL202-015
    Scenario: Apply training add-on or per-diem logic
      Given the claim includes condition and revenue codes
      When training or per-diem eligibility is evaluated
      Then training add-on or per-diem amounts are computed as appropriate
      And non-eligible claims receive zero add-on

  Rule: Compute final bundled payment amount
    # Description: Final payment is per-diem for home dialysis or adjusted base plus training add-on otherwise.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 124600-126600): Compute final amounts with and without HDPA.

    @rule_id:CAL202-016
    Scenario: Compute final bundled payment
      Given the claim has adjusted base and any training or per-diem amounts
      When the bundled payment is calculated
      Then the correct final amount is computed for the claim type
      And with-HDPA and without-HDPA amounts are stored

  Rule: Compute TDAPA add-on
    # Description: TDAPA per-treatment add-on is computed and added to final amounts.
    # Policy Citations:
    # - CMS-ESRD-OUTLIER TDAPA/TPNIES not outlier services until period ends (HTML:L969-973)
    # Code Path Citations:
    # - ESCAL202 (Lines 127100-127800): Compute TDAPA and add to final amounts.

    @rule_id:CAL202-017
    Scenario: Apply TDAPA add-on
      Given the claim includes payer-only TDAPA values
      When add-on payments are calculated
      Then TDAPA per-treatment add-on is calculated
      And the add-on is included in final amounts

  Rule: Select HDPA payment path
    # Description: ETC HDPA path uses data code 94 for HDPA amounts and sets adjusted base wage before HDPA.
    # Policy Citations:
    # - CFR-42-512-340 §512.340 Facility HDPA applicability (072X, CC 74/76) (HTML:L601-606)
    # Code Path Citations:
    # - ESCAL202 (Lines 128000-128300): If B-DATA-CODE=94, select with-HDPA amount.
    # - ESCAL202 (Lines 209000-209900): Apply HDPA selection logic for non-AKI claims.

    @rule_id:CAL202-020
    Scenario: Select HDPA payment path for ETC claims
      Given the claim includes the ETC HDPA data code
      When HDPA eligibility is determined
      Then with-HDPA amounts are selected for data code 94
      And non-HDPA amounts are selected otherwise

  Rule: Calculate outlier factors and payment
    # Description: Outlier calculations derive age/BSA/BMI/onset/comorbid/low-volume/rural factors and compute outlier payment.
    # Policy Citations:
    # - BP102C11-REV257 §60.D Outlier Payment Calculation (P47:L1885-1893)
    # Code Path Citations:
    # - ESCAL202 (Lines 138600-161300): Outlier factor calculations and payment logic.

    @rule_id:CAL202-021
    Scenario: Calculate outlier payment
      Given the claim includes outlier charge data and required case-mix inputs
      When outlier payment is calculated
      Then the outlier payment is computed using predicted vs imputed MAP
      And per-diem adjustments are applied when applicable

  Rule: Compute low-volume recovery payments
    # Description: Low-volume recovery recomputes PPS and outlier payments for low-volume providers and reconciles differences.
    # Policy Citations:
    # - CLM104C08-REV10640 Low-Volume ESRD Facilities Adjustment (P11:L411-419)
    # Code Path Citations:
    # - ESCAL202 (Lines 129400-131300): Low-volume recovery adjustments and PPS-LOW-VOL-AMT.
    # - ESCAL202 (Lines 168500-180000): Low-volume PPS and outlier recovery calculations.

    @rule_id:CAL202-023
    Scenario: Compute low-volume recovery payment
      Given the low-volume indicator is set for an adult claim
      When low-volume recovery is calculated
      Then low-volume PPS and outlier payments are recalculated
      And the recovery amount is stored

  Rule: Resolve final return code
    # Description: Return code is selected based on pediatric, outlier, low-volume, training, comorbid, onset, and low BMI flags.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL202 (Lines 180400-198300): Return code matrix and assignment logic.

    @rule_id:CAL202-022
    Scenario: Assign return code based on adjustment combinations
      Given the claim has one or more adjustment tracking flags set
      When the return code is determined
      Then the return code reflects the correct adjustment combination
      And the return code is set for output

  Rule: Apply QIP reduction to payment amounts
    # Description: QIP reduction is applied to all relevant payment rates for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV10640 §20.3 QIP Reduction Codes (P17:L619-624)
    # Code Path Citations:
    # - ESCAL202 (Lines 205700-208600): Apply QIP reduction to blended and full rates and final amounts.

    @rule_id:CAL202-018
    Scenario: Apply QIP reduction to payment amounts
      Given the claim is not AKI and has a QIP reduction factor
      When QIP reduction is applied
      Then all applicable payment amounts are reduced by the QIP factor
      And QIP reductions are reflected in final outputs
