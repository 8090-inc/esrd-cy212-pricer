Feature: Shared wage index records (WAGECPY)
  # Description: Defines shared records for MSA wage rates and CBSA wage indexes used by calculation modules.
  # COBOL: WAGECPY (copybook)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2005-04-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given the pricer receives a claim

  Rule: Wage copybook defines MSA wage adjusted rate record
    # Description: MSA wage adjusted rate fields are passed from driver to calculator.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - WAGECPY (Lines 000500-001400): WAGE-NEW-RATE-RECORD structure.

    @rule_id:REF-WAGECPY-001
    Scenario: Use MSA wage adjusted rate fields
      Given the driver retrieves MSA wage rates
      When the calculator receives WAGE-NEW-RATE-RECORD
      Then the MSA wage adjusted rate fields are available
      And the effective date is included

  Rule: Wage copybook defines composite and bundled CBSA wage records
    # Description: Composite and bundled CBSA wage index records are passed to calculation modules.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - WAGECPY (Lines 002000-004300): COM-CBSA-WAGE-RECORD and BUN-CBSA-WAGE-RECORD structures.

    @rule_id:REF-WAGECPY-002
    Scenario: Use CBSA wage index records
      Given the driver retrieves CBSA wage indexes
      When the calculator receives wage index records
      Then composite and bundled CBSA wage index fields are available
      And the effective dates are included
