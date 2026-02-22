Feature: ESRD PPS calculation engine (ESCAL212)
  # Description: Validates inputs, computes bundled adjustments, outlier payments, and return codes for CY2021.2.
  # COBOL: ESCAL212 (0000-START-TO-FINISH, 1000-VALIDATE-BILL-ELEMENTS, 1200-INITIALIZATION, 2000-CALCULATE-BUNDLED-FACTORS,
  #        2100-CALC-COMORBID-ADJUST, 2500-CALC-OUTLIER-FACTORS, 3000-LOW-VOL-FULL-PPS-PAYMENT,
  #        3100-LOW-VOL-OUT-PPS-PAYMENT, 9000-SET-RETURN-CODE)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2021-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given a claim is submitted for pricing


  Rule: Force full PPS processing for all claims
    # Description: All claims are processed as 100% PPS (waive-blend forced to Y).
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL212 (Lines 076100-076300): MOVE "Y" TO P-PROV-WAIVE-BLEND-PAY-INDIC.

    @rule_id:CAL-001O
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
    # - ESCAL212 (Lines 077700-079000): If B-COND-CODE = 84, set final pay to base wage amount, RTC 02, comorbid pay 10.

    @rule_id:CAL-001P
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
    # - ESCAL212 (Lines 079600-080000): If B-COND-CODE not in 73/74/84/87/blank -> RTC 58.

    @rule_id:CAL-000
    Scenario: Reject claims with invalid condition codes
      Given the claim condition code is not 73, 74, 84, 87, or blank
      When bill elements are validated
      Then the return code is 58

  Rule: Validate provider type
    # Description: Provider type must be 40, 41, or 05.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL212 (Lines 080300-080800): If P-PROV-TYPE not 40/41/05 -> RTC 52.

    @rule_id:CAL-001A
    Scenario: Reject claims with invalid provider type
      Given the provider type is not 40, 41, or 05
      When bill elements are validated
      Then the return code is 52

  Rule: Validate special payment indicator
    # Description: Special payment indicator must be "1" or blank.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL212 (Lines 081100-081400): If P-SPEC-PYMT-IND not 1 or blank -> RTC 53.

    @rule_id:CAL-001B
    Scenario: Reject claims with invalid special payment indicator
      Given the special payment indicator is not "1" or blank
      When bill elements are validated
      Then the return code is 53

  Rule: Validate date of birth
    # Description: DOB must be present and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL212 (Lines 081700-082000): If DOB is zero or not numeric -> RTC 54.

    @rule_id:CAL-001N
    Scenario: Reject claims with invalid date of birth
      Given the date of birth is missing or non-numeric
      When bill elements are validated
      Then the return code is 54

  Rule: Validate weight for non-AKI claims
    # Description: Weight is required and numeric for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL212 (Lines 082300-082800): If not AKI and weight is zero or not numeric -> RTC 55.

    @rule_id:CAL-001E
    Scenario: Reject non-AKI claims with invalid weight
      Given the claim is not AKI and weight is zero or non-numeric
      When bill elements are validated
      Then the return code is 55

  Rule: Validate height for non-AKI claims
    # Description: Height is required and numeric for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL212 (Lines 083100-083600): If not AKI and height is zero or not numeric -> RTC 56.

    @rule_id:CAL-001F
    Scenario: Reject non-AKI claims with invalid height
      Given the claim is not AKI and height is zero or non-numeric
      When bill elements are validated
      Then the return code is 56

  Rule: Validate revenue code
    # Description: Revenue code must be 0821, 0831, 0841, 0851, or 0881.
    # Policy Citations:
    # - CLM104C08-REV10640 §50.3 Condition Code Structure (73/74/84/87) (P21:L762-774; P22:L788-791)
    # Code Path Citations:
    # - ESCAL212 (Lines 083900-084500): If B-REV-CODE not in 0821/0831/0841/0851/0881 -> RTC 57.

    @rule_id:CAL-001C
    Scenario: Reject claims with invalid revenue code
      Given the revenue code is not 0821, 0831, 0841, 0851, or 0881
      When bill elements are validated
      Then the return code is 57

  Rule: Validate QIP reduction code
    # Description: QIP reduction code must be 1-4 or blank.
    # Policy Citations:
    # - CLM104C08-REV10640 §20.3 QIP Reduction Codes (P17:L619-624)
    # Code Path Citations:
    # - ESCAL212 (Lines 084800-085200): If P-QIP-REDUCTION not 1-4 or blank -> RTC 53.

    @rule_id:CAL-001D
    Scenario: Reject claims with invalid QIP reduction code
      Given the QIP reduction code is not 1, 2, 3, 4, or blank
      When bill elements are validated
      Then the return code is 53

  Rule: Validate height upper bound
    # Description: Non-AKI height must not exceed 300.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL212 (Lines 085800-086200): If not AKI and height > 300 -> RTC 71.

    @rule_id:CAL-001G
    Scenario: Reject non-AKI claims with height over 300
      Given the claim is not AKI and height exceeds 300
      When bill elements are validated
      Then the return code is 71

  Rule: Validate weight upper bound
    # Description: Non-AKI weight must not exceed 500.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL212 (Lines 086600-087000): If not AKI and weight > 500 -> RTC 72.

    @rule_id:CAL-001H
    Scenario: Reject non-AKI claims with weight over 500
      Given the claim is not AKI and weight exceeds 500
      When bill elements are validated
      Then the return code is 72

  Rule: Validate dialysis session count
    # Description: Dialysis session count must be present and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL212 (Lines 087900-088300): If session count zero or not numeric -> RTC 73.

    @rule_id:CAL-001I
    Scenario: Reject claims with invalid dialysis session count
      Given the dialysis session count is zero or non-numeric
      When bill elements are validated
      Then the return code is 73

  Rule: Validate line item date of service
    # Description: Line item date of service must be present and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL212 (Lines 088600-089000): If line item date is zero or not numeric -> RTC 74.

    @rule_id:CAL-001J
    Scenario: Reject claims with invalid line item date of service
      Given the line item date of service is zero or non-numeric
      When bill elements are validated
      Then the return code is 74

  Rule: Validate dialysis start date
    # Description: Dialysis start date must be numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL212 (Lines 089300-089600): If dialysis start date not numeric -> RTC 75.

    @rule_id:CAL-001K
    Scenario: Reject claims with invalid dialysis start date
      Given the dialysis start date is non-numeric
      When bill elements are validated
      Then the return code is 75

  Rule: Validate outlier total charges
    # Description: Outlier total charge must be numeric.
    # Policy Citations:
    # - BP102C11-REV257 §60.D Outlier Payment Calculation (P47:L1885-1893)
    # Code Path Citations:
    # - ESCAL212 (Lines 089900-090200): If outlier total not numeric -> RTC 76.

    @rule_id:CAL-001L
    Scenario: Reject claims with invalid outlier total charges
      Given the outlier total charges are non-numeric
      When bill elements are validated
      Then the return code is 76

  Rule: Validate comorbid CWF return code
    # Description: Comorbid return code must be blank or one of 10, 20, 40, 50, 60 for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL212 (Lines 091600-092300): If not AKI and comorbid return code not in set -> RTC 81.

    @rule_id:CAL-001M
    Scenario: Reject non-AKI claims with invalid comorbid return code
      Given the claim is not AKI and the comorbid return code is not blank, 10, 20, 40, 50, or 60
      When bill elements are validated
      Then the return code is 81

  Rule: Compute bundled base wage amount
    # Description: Compute labor and non-labor portions and sum into bundled base wage amount.
    # Policy Citations:
    # - FR-2020-24485 II.B.4.b.(1) CY 2021 ESRD PPS Wage Indices (P31:L6474-6483)
    # Code Path Citations:
    # - ESCAL212 (Lines 093700-094500): Compute labor and non-labor amounts and base wage amount.

    @rule_id:CAL-002
    Scenario: Compute bundled base wage amount
      Given the claim has a bundled base payment rate and wage index
      When pricing begins
      Then the bundled base wage amount equals labor plus non-labor portions

  Rule: Compute patient age at service month
    # Description: Age is computed from thru date year minus DOB year, adjusted when DOB month is after thru month.
    # Policy Citations:
    # - PUB100-04-CH8-REV10640 §20.2 Pediatric Payment Model (under 18) (P17:L637-640)
    # Code Path Citations:
    # - ESCAL212 (Lines 094900-095500): Compute H-PATIENT-AGE and adjust for month.

    @rule_id:CAL-008
    Scenario: Compute patient age for factor selection
      Given the claim includes DOB and thru date
      When patient age is determined
      Then age is adjusted for birth month relative to service month

  Rule: Map QIP reduction codes to factors
    # Description: QIP reduction codes map to 1.000, 0.995, 0.990, 0.985, or 0.980 factors.
    # Policy Citations:
    # - CLM104C08-REV10640 §20.3 QIP Reduction Codes (P17:L619-624)
    # Code Path Citations:
    # - ESCAL212 (Lines 095900-097700): Map P-QIP-REDUCTION to QIP-REDUCTION factor.

    @rule_id:CAL-007
    Scenario: Map QIP reduction codes to reduction factors
      Given a claim includes a QIP reduction code
      When the reduction factor is determined
      Then the correct QIP reduction factor is selected

  Rule: Normalize comorbid data based on CWF return code
    # Description: Comorbidity codes are interpreted based on the CWF return code.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.2 Comorbidity Adjustments (single highest) (P39:L1570-1573)
    # Code Path Citations:
    # - ESCAL212 (Lines 099400-107200): Move comorbid data to holding and map codes based on CWF return code.

    @rule_id:CAL-010
    Scenario: Interpret comorbidity codes using the CWF return code
      Given a claim includes a CWF comorbid return code
      When comorbidity codes are interpreted for evaluation
      Then the comorbidity category used for payment is derived from the return code

  Rule: Set pediatric age adjustment factors
    # Description: Pediatric factors depend on age thresholds and hemo vs PD modality.
    # Policy Citations:
    # - CLM104C08-REV10640 §20.2 Pediatric Payment Model (under 18) (P16:L602-606)
    # Code Path Citations:
    # - ESCAL212 (Lines 107600-108900): Pediatric age factor selection by age and revenue code.

    @rule_id:CAL-003A
    Scenario: Apply pediatric age adjustment factors
      Given the patient age is under 18
      When age adjustment factors are selected
      Then the pediatric factor is selected based on age band and modality

  Rule: Set adult age adjustment factors
    # Description: Adult factors follow age bands 18-44, 45-59, 60-69, 70-79, 80+.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 Adult Age Bands (P36:L1467-1472)
    # Code Path Citations:
    # - ESCAL212 (Lines 109200-110700): Adult age factor selection by age bands.

    @rule_id:CAL-003B
    Scenario: Apply adult age adjustment factors
      Given the patient age is 18 or older
      When age adjustment factors are selected
      Then the adult factor is selected based on age band

  Rule: Compute BSA and apply BSA factor
    # Description: BSA is computed using height/weight and applied for adults; pediatric defaults to 1.0.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BSA formula (P36:L1443-1445)
    # Code Path Citations:
    # - ESCAL212 (Lines 111700-112600): Compute BSA and BSA factor for adults; pediatric defaults to 1.000.

    @rule_id:CAL-004
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
    # - ESCAL212 (Lines 112000-112600): Pediatric path moves 1.000 to H-BUN-BSA-FACTOR.

    @rule_id:CAL-004B
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
    # - ESCAL212 (Lines 113100-113900): Compute BMI and apply low BMI factor when < 18.5 for adults.

    @rule_id:CAL-005
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
    # - ESCAL212 (Lines 113400-113900): Else branch moves 1.000 to H-BUN-BMI-FACTOR.

    @rule_id:CAL-005B
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
    # - ESCAL212 (Lines 114400-116700): Compute onset days and apply onset factor for adults <=120 days.

    @rule_id:CAL-009
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
    # - ESCAL212 (Lines 117200-121200): Set comorbid multiplier by age, onset, and CWF code.
    # - ESCAL212 (Lines 138300-145000): 2100-CALC-COMORBID-ADJUST selects highest paying comorbid.

    @rule_id:CAL-011
    Scenario: Select bundled comorbid multiplier
      Given comorbid data and CWF return codes are available
      When the comorbidity adjustment is selected
      Then the highest paying comorbid category is applied

  Rule: Apply low volume adjustment
    # Description: Low volume adjustment applies to adult claims when provider indicator is Y.
    # Policy Citations:
    # - CLM104C08-REV10640 Low-Volume ESRD Facilities Adjustment (P11:L411-419)
    # Code Path Citations:
    # - ESCAL212 (Lines 121700-122900): Apply low volume multiplier for adults when indicator is Y.

    @rule_id:CAL-012
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
    # - ESCAL212 (Lines 123400-123700): If CBSA < 100 and adult -> rural multiplier else 1.000.

    @rule_id:CAL-013
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
    # - ESCAL212 (Lines 124200-124600): Compute H-BUN-ADJUSTED-BASE-WAGE-AMT using factors.

    @rule_id:CAL-014
    Scenario: Compute adjusted base wage amount
      Given all bundled case-mix factors are available
      When the base payment is adjusted
      Then the base wage amount is multiplied by the case-mix factors

  Rule: Apply training add-on and per-diem logic
    # Description: Training add-on applies for condition codes 73/87; per-diem applies for condition code 74 with CAPD/CCPD revenue codes.
    # Policy Citations:
    # - CLM104C08-REV12979 §50.8 Training Add-On Payment (P32:L1112-1121)
    # Code Path Citations:
    # - ESCAL212 (Lines 125100-128200): Training add-on and per-diem calculations with HDPA variants.

    @rule_id:CAL-015
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
    # - ESCAL212 (Lines 128700-130700): Compute final amounts with and without HDPA.

    @rule_id:CAL-016
    Scenario: Compute final bundled payment
      Given the claim has adjusted base and any training or per-diem amounts
      When the bundled payment is calculated
      Then the correct final amount is computed for the claim type

  Rule: Compute TDAPA and TPNIES add-ons
    # Description: TDAPA and TPNIES per-treatment add-ons are computed and added to final amounts.
    # Policy Citations:
    # - CMS-ESRD-OUTLIER TDAPA/TPNIES not outlier services until period ends (HTML:L969-973)
    # Code Path Citations:
    # - ESCAL212 (Lines 131200-133300): Compute TDAPA/TPNIES and add to final amounts.

    @rule_id:CAL-017
    Scenario: Apply TDAPA and TPNIES add-ons
      Given the claim includes payer-only TDAPA or TPNIES values
      When add-on payments are calculated
      Then TDAPA and TPNIES per-treatment add-ons are calculated
      And the add-ons are included in final amounts

  Rule: Select HDPA payment path
    # Description: ETC HDPA path uses data code 94 for HDPA amounts and sets adjusted base wage before HDPA.
    # Policy Citations:
    # - CFR-42-512-340 §512.340 Facility HDPA applicability (072X, CC 74/76) (HTML:L601-606)
    # Code Path Citations:
    # - ESCAL212 (Lines 133400-133700): If B-DATA-CODE=94, select with-HDPA amount.
    # - ESCAL212 (Lines 217300-218600): Apply HDPA selection logic for non-AKI claims.

    @rule_id:CAL-020
    Scenario: Select HDPA payment path for ETC claims
      Given the claim includes the ETC HDPA data code
      When HDPA eligibility is determined
      Then with-HDPA amounts are selected for data code 94
      And non-HDPA amounts are selected otherwise

  Rule: Apply network reduction
    # Description: Network reduction is $0.21 for per-diem claims and $0.50 for full PPS, and is applied to final amounts.
    # Policy Citations:
    # - CLM104C08-REV10640 §110 ESRD Network Reduction ($0.50 / $0.21 per diem) (P54:L1903-1913)
    # Code Path Citations:
    # - ESCAL212 (Lines 134700-135100): Set network reduction amount based on per-diem vs full PPS.
    # - ESCAL212 (Lines 216400-216700): Subtract network reduction from final amounts.

    @rule_id:CAL-019
    Scenario: Apply network reduction to final amounts
      Given the claim is per-diem or full PPS
      When the network reduction is applied
      Then the correct network reduction amount is set and subtracted
      And final amounts are reduced accordingly

  Rule: Calculate outlier factors and payment
    # Description: Outlier calculations derive age/BSA/BMI/onset/comorbid/low-volume/rural factors and compute outlier payment.
    # Policy Citations:
    # - BP102C11-REV257 §60.D Outlier Payment Calculation (P47:L1885-1893)
    # Code Path Citations:
    # - ESCAL212 (Lines 145200-167900): Outlier factor calculations and payment logic.

    @rule_id:CAL-021
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
    # - ESCAL212 (Lines 136000-137900): Low-volume recovery adjustments and PPS-LOW-VOL-AMT.
    # - ESCAL212 (Lines 174800-186600): Low-volume PPS and outlier recovery calculations.

    @rule_id:CAL-023
    Scenario: Compute low-volume recovery payment
      Given the low-volume indicator is set for an adult claim
      When low-volume recovery is calculated
      Then low-volume PPS and outlier payments are recalculated

  Rule: Resolve final return code
    # Description: Return code is selected based on pediatric, outlier, low-volume, training, comorbid, onset, and low BMI flags.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL212 (Lines 187000-204900): Return code matrix and assignment logic.

    @rule_id:CAL-022
    Scenario: Assign return code based on adjustment combinations
      When the return code is determined
      Then the return code reflects the correct adjustment combination

  Rule: Apply QIP reduction to payment amounts
    # Description: QIP reduction is applied to all relevant payment rates for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV10640 §20.3 QIP Reduction Codes (P17:L619-624)
    # Code Path Citations:
    # - ESCAL212 (Lines 213200-215800): Apply QIP reduction to blended and full rates and final amounts.

    @rule_id:CAL-018
    Scenario: Apply QIP reduction to payment amounts
      Given the claim is not AKI and has a QIP reduction factor
      When QIP reduction is applied
      Then all applicable payment amounts are reduced by the QIP factor
      And QIP reductions are reflected in final outputs
