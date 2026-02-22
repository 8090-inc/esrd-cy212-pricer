Feature: ESRD PPS calculation engine (ESCAL100)
  # Description: Legacy (pre-2011) pricing logic using MSA/CBSA blends and case-mix factors.
  # COBOL: ESCAL100 (1000-EDIT-THE-BILL-INFO, 1200-CALC-AGE, 2000-ASSEMBLE-PPS-VARIABLES, 3000-CALC-PAYMENT)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2010-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given a claim is submitted for pricing


  Rule: Validate special payment indicator
    # Description: Special payment indicator must be "1" or blank.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL100 (Lines 00314-00316): P-SPEC-PYMT-IND NOT = '1'

    @rule_id:CAL100-001B
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
    # - ESCAL100 (Lines 00320-00322): B-DOB-DATE

    @rule_id:CAL100-001N
    Scenario: Reject claims with invalid date of birth
      Given the date of birth is missing or non-numeric
      When bill elements are validated
      Then the return code is 54
      And calculation is not executed

  Rule: Validate weight
    # Description: Weight is required and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL100 (Lines 00326-00328): B-PATIENT-WGT

    @rule_id:CAL100-001E
    Scenario: Reject claims with invalid weight
      Given the patient weight is zero or non-numeric
      When bill elements are validated
      Then the return code is 55
      And calculation is not executed

  Rule: Validate height
    # Description: Height is required and numeric.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL100 (Lines 00332-00334): B-PATIENT-HGT

    @rule_id:CAL100-001F
    Scenario: Reject claims with invalid height
      Given the patient height is zero or non-numeric
      When bill elements are validated
      Then the return code is 56
      And calculation is not executed

  Rule: Validate revenue code
    # Description: Revenue code must be within the allowed dialysis revenue codes for the module.
    # Policy Citations:
    # - CLM104C08-REV10640 §50.3 Condition Code Structure (73/74/84/87) (P21:L762-774; P22:L788-791)
    # Code Path Citations:
    # - ESCAL100 (Lines 00338-00343): B-REV-CODE\s+=\s+'0821'

    @rule_id:CAL100-001C
    Scenario: Reject claims with invalid revenue code
      Given the revenue code is not an allowed dialysis revenue code
      When bill elements are validated
      Then the return code is 57
      And calculation is not executed

  Rule: Validate condition codes
    # Description: Condition code must be within the allowed set for the module.
    # Policy Citations:
    # - CLM104C08-REV10640 §50.3 Condition Code Structure (73/74/84/87) (P21:L762-774; P22:L788-791)
    # Code Path Citations:
    # - ESCAL100 (Lines 00347-00349): B-COND-CODE NOT = '73'

    @rule_id:CAL100-000
    Scenario: Reject claims with invalid condition codes
      Given the claim condition code is not in the allowed set
      When bill elements are validated
      Then the return code is 58
      And calculation is not executed

  Rule: Validate height upper bound
    # Description: Height must not exceed 300.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL100 (Lines 00353-00355): B-PATIENT-HGT > 300

    @rule_id:CAL100-001G
    Scenario: Reject claims with height over 300
      Given the patient height exceeds 300
      When bill elements are validated
      Then the return code is 71
      And calculation is not executed

  Rule: Validate weight upper bound
    # Description: Weight must not exceed 500.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL100 (Lines 00359-00361): B-PATIENT-WGT > 500

    @rule_id:CAL100-001H
    Scenario: Reject claims with weight over 500
      Given the patient weight exceeds 500
      When bill elements are validated
      Then the return code is 72
      And calculation is not executed

  Rule: Compute patient age
    # Description: Age is computed from thru date year minus DOB year, adjusted when DOB month is after thru month.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL100 (Lines 00374-00378): COMPUTE H-PATIENT-AGE = B-THRU-CCYY

    @rule_id:CAL100-008
    Scenario: Compute patient age for factor selection
      Given the claim includes DOB and thru date
      When patient age is determined
      Then age is adjusted for birth month relative to service month
      And age is available for factor selection

  Rule: Set age adjustment factor
    # Description: Age adjustment factor is selected based on age bands defined in the module.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 Adult Age Bands (P36:L1467-1472)
    # Code Path Citations:
    # - ESCAL100 (Lines 00384-00401): H-PATIENT-AGE < 18

    @rule_id:CAL100-003B
    Scenario: Apply age adjustment factor by age band
      Given patient age has been calculated
      When age adjustment factors are selected
      Then the factor matches the age band logic in the module
      And the factor is stored for payment calculation

  Rule: Compute BSA factor
    # Description: BSA is computed from height and weight and mapped to a BSA factor.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BSA formula (P36:L1443-1445)
    # Code Path Citations:
    # - ESCAL100 (Lines 00414-00425): COMPUTE H-BSA

    @rule_id:CAL100-004
    Scenario: Compute BSA adjustment factor
      Given patient height and weight are available
      When BSA is calculated
      Then adult BSA factor is computed from the BSA formula
      And pediatric BSA factor defaults to 1.000

  Rule: Compute BMI factor
    # Description: BMI is computed and a low BMI factor is applied when criteria are met.
    # Policy Citations:
    # - BP102C11-REV257 §60.A.1 BMI formula (low BMI < 18.5) (P38:L1503-1507)
    # Code Path Citations:
    # - ESCAL100 (Lines 00417-00425): COMPUTE H-BMI

    @rule_id:CAL100-005
    Scenario: Compute BMI adjustment factor
      Given patient height and weight are available
      When BMI is calculated
      Then low BMI factor is applied when criteria are met
      And otherwise BMI factor defaults to 1.000

  Rule: Compute wage-adjusted payment
    # Description: Payment uses wage-adjusted amounts (CBSA/MSA blend when applicable) and case-mix factors.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESCAL100 (Lines 00443-00443): COMPUTE H-WAGE-ADJ-PYMT-NEW

    @rule_id:CAL100-016
    Scenario: Compute wage-adjusted payment amount
      Given wage indexes and case-mix factors are available
      When the wage-adjusted payment is calculated
      Then the payment uses blend percentages when applicable
      And the final payment amount is produced

  Rule: Apply condition code add-ons and per-diem
    # Description: Condition code 73 applies add-ons; condition code 74 applies CAPD/CCPD per-diem adjustments.
    # Policy Citations:
    # - CLM104C08-REV10640 §50.3 Condition Code Structure (73/74/84/87) (P21:L762-774; P22:L788-791)
    # Code Path Citations:
    # - ESCAL100 (Lines 00458-00477): B-COND-CODE = '73'

    @rule_id:CAL100-015
    Scenario: Apply condition code add-ons and per-diem adjustments
      Given the claim includes condition and revenue codes
      When condition code add-ons or per-diem factors apply
      Then add-ons or per-diem adjustments are applied as defined
      And the adjusted payment amount is stored

  Rule: Set final payment amount
    # Description: Final payment amount is moved to PPS-FINAL-PAY-AMT for output.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESCAL100 (Lines 00481-00481): MOVE H-PYMT-AMT\s+TO PPS-FINAL-PAY-AMT

    @rule_id:CAL100-016B
    Scenario: Set final payment amount
      Given the payment amount has been computed
      When the final payment is determined
      Then PPS-FINAL-PAY-AMT is set
      And the final amount is ready for output
