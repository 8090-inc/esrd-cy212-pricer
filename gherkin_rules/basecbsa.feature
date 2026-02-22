Feature: Composite CBSA wage index reference table (BASECBSA)
  # Description: Defines composite CBSA wage index factors by effective date and geography.
  # COBOL: BASECBSA (flat file table)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2006-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given the pricer receives a claim

  Rule: Composite CBSA table enumerates wage index factors
    # Description: Composite CBSA records provide wage index factors by effective date and geography.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - BASECBSA (Lines 000100-000900): Composite CBSA wage index records with effective dates.

    @rule_id:REF-BASECBSA-001
    Scenario: Use composite CBSA wage index records
      Given a claim requires a composite CBSA wage index
      When the pricer references the composite CBSA table
      Then the effective wage index factor is selected for the claim
      And the factor is available for downstream calculations
