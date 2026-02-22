Feature: ESRD PPS calculation engine (ESCAL117)
  # Description: Validates inputs, computes bundled adjustments, outlier payments, and return codes.
  # COBOL: ESCAL117 (core calculation paragraphs)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2011-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given the pricer receives a claim


  Rule: Validate condition codes
    # Description: Condition codes must be one of 73, 74, 84, 87, or blank.
    # Policy Citations:
    # - CLM104C08-REV10640 §50.3 Condition Code Structure (73/74/84/87) (P21:L762-774; P22:L788-791)
    # Code Path Citations:
    # - ESCAL117 (Lines 00516-00518): B-COND-CODE NOT = '73'

    @rule_id:CAL117-000
    Scenario: Reject claims with invalid condition codes
      Given the claim condition code is not 73, 74, 84, 87, or blank
      When the pricer validates bill elements
      Then the return code is 58
      And calculation is not executed

  Rule: Validate provider type
    # Description: Provider type must be 40, 41, or 05.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL117 (Lines 00476-00480): P-PROV-TYPE\s*=\s+'40'

    @rule_id:CAL117-001A
    Scenario: Reject claims with invalid provider type
      Given the provider type is not 40, 41, or 05
      When the pricer validates bill elements
      Then the return code is 52
      And calculation is not executed

  Rule: Validate special payment indicator
    # Description: Special payment indicator must be "1" or blank.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL117 (Lines 00483-00485): P-SPEC-PYMT-IND NOT = '1'

    @rule_id:CAL117-001B
    Scenario: Reject claims with invalid special payment indicator
      Given the special payment indicator is not "1" or blank
      When the pricer validates bill elements
      Then the return code is 53
      And calculation is not executed

  Rule: Validate date of birth
    # Description: DOB must be present and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL117 (Lines 00489-00491): B-DOB-DATE

    @rule_id:CAL117-001N
    Scenario: Reject claims with invalid date of birth
      Given the date of birth is missing or non-numeric
      When the pricer validates bill elements
      Then the return code is 54
      And calculation is not executed

  Rule: Validate weight for non-AKI claims
    # Description: Weight is required and numeric for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL117 (Lines 00495-00497): B-PATIENT-WGT

    @rule_id:CAL117-001E
    Scenario: Reject non-AKI claims with invalid weight
      Given the claim is not AKI and weight is zero or non-numeric
      When the pricer validates bill elements
      Then the return code is 55
      And calculation is not executed

  Rule: Validate height for non-AKI claims
    # Description: Height is required and numeric for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL117 (Lines 00501-00503): B-PATIENT-HGT

    @rule_id:CAL117-001F
    Scenario: Reject non-AKI claims with invalid height
      Given the claim is not AKI and height is zero or non-numeric
      When the pricer validates bill elements
      Then the return code is 56
      And calculation is not executed

  Rule: Validate revenue code
    # Description: Revenue code must be 0821, 0831, 0841, 0851, or 0881.
    # Policy Citations:
    # - CLM104C08-REV10640 §50.3 Condition Code Structure (73/74/84/87) (P21:L762-774; P22:L788-791)
    # Code Path Citations:
    # - ESCAL117 (Lines 00507-00512): B-REV-CODE\s+=\s+'0821'

    @rule_id:CAL117-001C
    Scenario: Reject claims with invalid revenue code
      Given the revenue code is not 0821, 0831, 0841, 0851, or 0881
      When the pricer validates bill elements
      Then the return code is 57
      And calculation is not executed

  Rule: Validate height upper bound
    # Description: Non-AKI height must not exceed 300.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL117 (Lines 00522-00524): B-PATIENT-HGT > 300

    @rule_id:CAL117-001G
    Scenario: Reject non-AKI claims with height over 300
      Given the claim is not AKI and height exceeds 300
      When the pricer validates bill elements
      Then the return code is 71
      And calculation is not executed

  Rule: Validate weight upper bound
    # Description: Non-AKI weight must not exceed 500.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL117 (Lines 00528-00530): B-PATIENT-WGT > 500

    @rule_id:CAL117-001H
    Scenario: Reject non-AKI claims with weight over 500
      Given the claim is not AKI and weight exceeds 500
      When the pricer validates bill elements
      Then the return code is 72
      And calculation is not executed

  Rule: Validate dialysis session count
    # Description: Dialysis session count must be present and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL117 (Lines 00539-00542): B-CLAIM-NUM-DIALYSIS-SESSIONS

    @rule_id:CAL117-001I
    Scenario: Reject claims with invalid dialysis session count
      Given the dialysis session count is zero or non-numeric
      When the pricer validates bill elements
      Then the return code is 73
      And calculation is not executed

  Rule: Validate line item date of service
    # Description: Line item date of service must be present and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL117 (Lines 00546-00549): B-LINE-ITEM-DATE-SERVICE

    @rule_id:CAL117-001J
    Scenario: Reject claims with invalid line item date of service
      Given the line item date of service is zero or non-numeric
      When the pricer validates bill elements
      Then the return code is 74
      And calculation is not executed

  Rule: Validate dialysis start date
    # Description: Dialysis start date must be numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL117 (Lines 00553-00555): B-DIALYSIS-START-DATE

    @rule_id:CAL117-001K
    Scenario: Reject claims with invalid dialysis start date
      Given the dialysis start date is non-numeric
      When the pricer validates bill elements
      Then the return code is 75
      And calculation is not executed

  Rule: Validate outlier total charges
    # Description: Outlier total charge must be numeric.
    # Policy Citations:
    # - BP102C11-REV257 §60.D Outlier Payment Calculation (P47:L1885-1893)
    # Code Path Citations:
    # - ESCAL117 (Lines 00559-00561): B-TOT-PRICE-SB-OUTLIER

    @rule_id:CAL117-001L
    Scenario: Reject claims with invalid outlier total charges
      Given the outlier total charges are non-numeric
      When the pricer validates bill elements
      Then the return code is 76
      And calculation is not executed

  Rule: Validate comorbid CWF return code
    # Description: Comorbid return code must be blank or one of 10, 20, 40, 50, 60 for non-AKI claims.
    # Policy Citations:
    # - CLM104C08-REV12979 §40 AKI Claims (no ESRD adjusters, no outlier, no TDAPA/TPNIES) (P17:L634-658)
    # Code Path Citations:
    # - ESCAL117 (Lines 00565-00570): COMORBID-CWF-RETURN-CODE = SPACES

    @rule_id:CAL117-001M
    Scenario: Reject non-AKI claims with invalid comorbid return code
      Given the claim is not AKI and the comorbid return code is not blank, 10, 20, 40, 50, or 60
      When the pricer validates bill elements
      Then the return code is 81
      And calculation is not executed

  Rule: Compute bundled base wage amount
    # Description: Compute labor and non-labor portions and sum into bundled base wage amount.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL117 (Lines 00236-00236): H-BUN-NAT-LABOR-AMT

    @rule_id:CAL117-002
    Scenario: Compute bundled base wage amount
      Given the claim has a bundled base payment rate and wage index
      When the pricer initializes bundled wage calculations
      Then the bundled base wage amount equals labor plus non-labor portions
      And the base wage amount is stored for downstream adjustments

  Rule: Compute patient age at service month
    # Description: Age is computed from thru date year minus DOB year, adjusted when DOB month is after thru month.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL117 (Lines 00458-00461): H-PATIENT-AGE = B-THRU-CCYY

    @rule_id:CAL117-008
    Scenario: Compute patient age for factor selection
      Given the claim includes DOB and thru date
      When the pricer computes patient age
      Then age is adjusted for birth month relative to service month
      And pediatric tracking is set when age is under 18

  Rule: Normalize comorbid data based on CWF return code
    # Description: When CWF return code is present, comorbid data is moved to holding and mapped to internal codes.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.2 Comorbidity Adjustments (single highest) (P39:L1570-1573)
    # Code Path Citations:
    # - ESCAL117 (Lines 00596-00596): MOVE COMORBID-DATA \(1\)\s+TO H-COMORBID-DATA \(1\)

    @rule_id:CAL117-010
    Scenario: Normalize comorbid data for consistent evaluation
      Given a claim includes a CWF comorbid return code
      When the pricer normalizes comorbid data
      Then comorbid data is moved to holding and mapped to MA/MC/MD/ME as appropriate
      And the original values are preserved for later restoration

  Rule: Set pediatric age adjustment factors
    # Description: Pediatric factors depend on age thresholds and hemo vs PD modality.
    # Policy Citations:
    # - CLM104C08-REV10640 §20.2 Pediatric Payment Model (under 18) (P16:L602-606)
    # Code Path Citations:
    # - ESCAL117 (Lines 00331-00331): EB-AGE-LT-13-HEMO-MODE

    @rule_id:CAL117-003A
    Scenario: Apply pediatric age adjustment factors
      Given the patient age is under 18
      When the pricer selects age adjustment factors
      Then the pediatric factor is selected based on age band and modality
      And the factor is stored for bundled calculations

  Rule: Set adult age adjustment factors
    # Description: Adult factors follow age bands 18-44, 45-59, 60-69, 70-79, 80+.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 Adult Age Bands (P36:L1467-1472)
    # Code Path Citations:
    # - ESCAL117 (Lines 00355-00355): CM-AGE-18-44

    @rule_id:CAL117-003B
    Scenario: Apply adult age adjustment factors
      Given the patient age is 18 or older
      When the pricer selects age adjustment factors
      Then the adult factor is selected based on age band
      And the factor is stored for bundled calculations

  Rule: Compute BSA and apply BSA factor
    # Description: BSA is computed using height/weight and applied for adults; pediatric defaults to 1.0.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BSA formula (P36:L1443-1445)
    # Code Path Citations:
    # - ESCAL117 (Lines 00240-00240): H-BUN-BSA

    @rule_id:CAL117-004
    Scenario: Compute BSA adjustment factor
      Given patient height and weight are available
      When the pricer computes BSA and the BSA factor
      Then adult BSA factor is computed from the BSA formula
      And pediatric BSA factor defaults to 1.000

  Rule: Default BSA factor for pediatric claims
    # Description: Pediatric claims use a default BSA factor of 1.000.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BSA formula (P36:L1443-1445)
    # Code Path Citations:
    # - ESCAL117 (Lines 00737-00737): MOVE 1.000\s+TO H-BUN-BSA-FACTOR

    @rule_id:CAL117-004B
    Scenario: Default pediatric BSA factor to 1.000
      Given the patient age is under 18
      When the pricer applies the BSA factor
      Then the BSA factor is 1.000
      And no additional BSA adjustment is applied

  Rule: Compute BMI and apply low BMI factor
    # Description: BMI is computed and a low-BMI factor is applied for adults with BMI < 18.5.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BMI formula (low BMI < 18.5) (P38:L1503-1507)
    # Code Path Citations:
    # - ESCAL117 (Lines 00242-00242): H-BUN-BMI

    @rule_id:CAL117-005
    Scenario: Compute BMI adjustment factor
      Given patient height and weight are available
      When the pricer computes BMI
      Then low BMI factor is applied for adults below 18.5
      And otherwise BMI factor defaults to 1.000

  Rule: Default BMI factor for non-low BMI claims
    # Description: BMI factor defaults to 1.000 when low BMI criteria are not met.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BMI formula (low BMI < 18.5) (P38:L1503-1507)
    # Code Path Citations:
    # - ESCAL117 (Lines 00750-00750): MOVE 1.000\s+TO H-BUN-BMI-FACTOR

    @rule_id:CAL117-005B
    Scenario: Default BMI factor to 1.000 when low BMI criteria are not met
      Given the patient does not meet low BMI criteria
      When the pricer applies the BMI factor
      Then the BMI factor is 1.000
      And no low BMI adjustment is applied

  Rule: Compute onset adjustment factor
    # Description: Onset factor applies to adult claims within 120 days of dialysis start.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 Onset of Dialysis (≤120 days) (P38:L1516-1537)
    # Code Path Citations:
    # - ESCAL117 (Lines 00129-00129): ONSET-DATE

    @rule_id:CAL117-009
    Scenario: Apply onset adjustment factor
      Given dialysis start date and service date are present
      When the pricer computes onset days
      Then adult claims within 120 days receive the onset factor
      And others receive a factor of 1.000

  Rule: Select comorbid adjustment multiplier
    # Description: Comorbid multiplier selection depends on age, onset, and comorbid return code; highest paying comorbid is selected.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.2 Comorbidity Adjustments (single highest) (P39:L1570-1573)
    # Code Path Citations:
    # - ESCAL117 (Lines 00793-00793): CALC-COMORBID-ADJUST

    @rule_id:CAL117-011
    Scenario: Select bundled comorbid multiplier
      Given comorbid data and CWF return codes are available
      When the pricer selects the bundled comorbid multiplier
      Then the highest paying comorbid category is applied
      And comorbid tracking flags are updated

  Rule: Apply low volume adjustment
    # Description: Low volume adjustment applies to adult claims when provider indicator is Y.
    # Policy Citations:
    # - CLM104C08-REV10640 Low-Volume ESRD Facilities Adjustment (P11:L411-419)
    # Code Path Citations:
    # - ESCAL117 (Lines 00827-00835): P-PROV-LOW-VOLUME-INDIC = 'Y'

    @rule_id:CAL117-012
    Scenario: Apply low volume multiplier for adults
      Given provider low volume indicator is Y
      When the pricer evaluates low volume eligibility
      Then adult claims receive the low volume multiplier
      And pediatric claims default to 1.000

  Rule: Compute adjusted base wage amount
    # Description: Adjusted base wage is computed from base wage and case-mix factors.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL117 (Lines 00246-00246): H-BUN-ADJUSTED-BASE-WAGE-AMT

    @rule_id:CAL117-014
    Scenario: Compute adjusted base wage amount
      Given all bundled case-mix factors are available
      When the pricer computes the adjusted base wage amount
      Then the base wage amount is multiplied by the case-mix factors
      And the adjusted base wage amount is stored

  Rule: Apply training add-on and per-diem logic
    # Description: Training add-on applies for condition codes 73/87; per-diem applies for condition code 74 with CAPD/CCPD revenue codes.
    # Policy Citations:
    # - CLM104C08-REV12979 §50.8 Training Add-On Payment (P32:L1112-1121)
    # Code Path Citations:
    # - ESCAL117 (Lines 00313-00313): TRAINING-ADD-ON-PMT-AMT

    @rule_id:CAL117-015
    Scenario: Apply training add-on or per-diem logic
      Given the claim includes condition and revenue codes
      When the pricer evaluates training or per-diem eligibility
      Then training add-on or per-diem amounts are computed as appropriate
      And non-eligible claims receive zero add-on

  Rule: Calculate outlier factors and payment
    # Description: Outlier calculations derive age/BSA/BMI/onset/comorbid/low-volume/rural factors and compute outlier payment.
    # Policy Citations:
    # - BP102C11-REV257 §60.D Outlier Payment Calculation (P47:L1885-1893)
    # Code Path Citations:
    # - ESCAL117 (Lines 00883-00883): CALC-OUTLIER-FACTORS

    @rule_id:CAL117-021
    Scenario: Calculate outlier payment
      Given the claim includes outlier charge data and required case-mix inputs
      When the pricer calculates outlier factors and payments
      Then the outlier payment is computed using predicted vs imputed MAP
      And per-diem adjustments are applied when applicable

  Rule: Compute low-volume recovery payments
    # Description: Low-volume recovery recomputes PPS and outlier payments for low-volume providers and reconciles differences.
    # Policy Citations:
    # - CLM104C08-REV10640 Low-Volume ESRD Facilities Adjustment (P11:L411-419)
    # Code Path Citations:
    # - ESCAL117 (Lines 00387-00387): LOW-VOLUME-TRACK

    @rule_id:CAL117-023
    Scenario: Compute low-volume recovery payment
      Given the low-volume indicator is set for an adult claim
      When the pricer computes low-volume recovery payments
      Then low-volume PPS and outlier payments are recalculated
      And the recovery amount is stored

  Rule: Resolve final return code
    # Description: Return code is selected based on pediatric, outlier, low-volume, training, comorbid, onset, and low BMI flags.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL117 (Lines 00469-00469): 9000-SET-RETURN-CODE

    @rule_id:CAL117-022
    Scenario: Assign return code based on adjustment combinations
      Given the claim has one or more adjustment tracking flags set
      When the pricer resolves the return code
      Then the return code reflects the correct adjustment combination
      And the return code is set for output
