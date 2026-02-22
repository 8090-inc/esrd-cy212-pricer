Feature: Wage index and reference table lookup (ESDRV212)
  # Description: Retrieves MSA, composite CBSA, and bundled CBSA wage indexes, including special overrides and supplemental caps.
  # COBOL: ESDRV212 (0500-0550, 0700-0750, 0800-0850, 0820-SEARCH-CHILD-HOSP-TABLE)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2021-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given the pricer receives a claim

  Rule: Find MSA wage adjusted rate by claim date and MSA
    # Description: The driver searches the MSA table by claim date and MSA code; missing entries return RTC 60.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESDRV212 (Lines 095700-097200): Search WWM-ENTRY by P-GEO-MSA; AT END sets RTC 60.

    @rule_id:DRV-WAGE-001
    Scenario: Locate MSA wage adjusted rate or return RTC 60
      Given a claim includes an MSA code
      When the driver searches the MSA wage table for the claim date
      Then the wage rate is retrieved when the MSA is found
      And missing MSA results return code 60

  Rule: Resolve MSA wage rate by effective date
    # Description: The driver selects the most recent wage rate effective for the claim date; if none, rates are zeroed.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESDRV212 (Lines 097700-099000): Compare date codes, walk back pointer, else set wage rate records to zero.

    @rule_id:DRV-WAGE-002
    Scenario: Select effective MSA wage rate for claim date
      Given a claim includes an MSA code and effective dates
      When the driver compares wage index date codes to the claim date
      Then the most recent effective wage rates are selected
      And if none are found the wage rates are set to zero

  Rule: Composite CBSA lookup honors special payment indicator
    # Description: Special payment indicator bypasses CBSA lookup and uses the provider-supplied wage index.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESDRV212 (Lines 099500-099900): If P-SPEC-PYMT-IND = '1', use P-SPEC-WAGE-INDX and exit.

    @rule_id:DRV-WAGE-003
    Scenario: Use special wage index when special payment indicator is set
      Given the special payment indicator is set to "1"
      When the driver retrieves the composite CBSA wage index
      Then the provider-supplied special wage index is used
      And standard CBSA lookup is bypassed

  Rule: Composite CBSA lookup by claim date and CBSA
    # Description: The driver selects the correct composite CBSA index; missing CBSA sets RTC 60/61 depending on runtime.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESDRV212 (Lines 100100-101500): Search COM-CBSA-ENTRY by P-GEO-CBSA; AT END sets RTC 60 or 61.

    @rule_id:DRV-WAGE-004
    Scenario: Locate composite CBSA wage index or return RTC 60/61
      Given a claim includes a CBSA code
      When the driver searches the composite CBSA table for the claim date
      Then the composite wage index is retrieved when the CBSA is found
      And missing CBSA results in return code 60 or 61 depending on runtime

  Rule: Resolve composite CBSA wage index by effective date
    # Description: The driver walks back the CBSA index pointer to find the effective date; otherwise sets index to zero.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESDRV212 (Lines 102600-103900): If date code mismatch, decrement pointer; else set COM-CBSA-W-INDEX to zero.

    @rule_id:DRV-WAGE-005
    Scenario: Select effective composite CBSA wage index for claim date
      Given a claim includes a CBSA code and effective dates
      When the driver compares composite CBSA date codes to the claim date
      Then the most recent effective composite wage index is selected
      And if none are found the composite wage index is set to zero

  Rule: Bundled CBSA lookup honors special payment indicator
    # Description: Special payment indicator bypasses bundled CBSA lookup and uses the provider-supplied wage index.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESDRV212 (Lines 104500-104900): If P-SPEC-PYMT-IND = '1', use P-SPEC-WAGE-INDX and exit.

    @rule_id:DRV-WAGE-006
    Scenario: Use special wage index for bundled CBSA lookup
      Given the special payment indicator is set to "1"
      When the driver retrieves the bundled CBSA wage index
      Then the provider-supplied special wage index is used
      And standard bundled CBSA lookup is bypassed

  Rule: Children's hospital override (CY2015)
    # Description: For CY2015 claims, a children's hospital provider match overrides the bundled CBSA wage index.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 105100-106100): Search child hospital table and use CHILD-HOSP-SWI when found.
    # - ESDRV212 (Lines 111800-112000): Provider match sets CHILD-HOSP-SWI-FOUND.

    @rule_id:DRV-WAGE-007
    Scenario: Apply children's hospital wage index override
      Given the claim is in CY2015 and the provider matches the children's hospital list
      When the driver searches the children's hospital table
      Then the bundled CBSA wage index is overridden by the hospital-specific index
      And the standard CBSA lookup is skipped

  Rule: Bundled CBSA lookup by claim date and CBSA
    # Description: The driver searches bundled CBSA by claim date and CBSA code; missing entries return RTC 60/61.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESDRV212 (Lines 106300-109100): Compute year code, search BUN-CBSA-ENTRY; AT END sets RTC 60/61.

    @rule_id:DRV-WAGE-008
    Scenario: Locate bundled CBSA wage index or return RTC 60/61
      Given a claim includes a CBSA code
      When the driver searches the bundled CBSA table for the claim date
      Then the bundled wage index is retrieved when the CBSA is found
      And missing CBSA results in return code 60 or 61 depending on runtime

  Rule: Supplemental wage index 5% cap
    # Description: Supplemental wage index caps decreases to 5% for claims after 2020-09-30 when indicator is on.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESDRV212 (Lines 109300-111300): If P-SUPP-WI-IND = '1' and prior wage index is present, cap decreases to 5%.

    @rule_id:DRV-WAGE-009
    Scenario: Cap supplemental wage index decrease to 5%
      Given the claim date is after 2020-09-30 and supplemental wage index is enabled
      When the driver computes the supplemental wage index ratio
      Then decreases greater than 5% are capped at 5%
      And missing prior wage index results in return code 60

  Rule: Bundled CBSA rate must match claim year
    # Description: The driver enforces wage index year matching claim year and returns RTC 60 if no matching year is found.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESDRV212 (Lines 112200-114600): If year code mismatch, step back; if none found, set BUN-CBSA-W-INDEX to zero and RTC 60.

    @rule_id:DRV-WAGE-010
    Scenario: Enforce bundled CBSA year match
      Given a claim includes a CBSA wage index record
      When the driver validates the wage index year against the claim year
      Then only matching-year indexes are used
      And missing matches result in return code 60
