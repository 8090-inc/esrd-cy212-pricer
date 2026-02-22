Feature: Bundled CBSA wage index reference table (BUNDCBSA)
  # Description: Defines bundled CBSA wage index factors by effective date and geography.
  # COBOL: BUNDCBSA (flat file table)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2011-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given a claim is submitted for pricing

  Rule: Bundled CBSA table enumerates wage index factors
    # Description: Bundled CBSA records provide wage index factors by effective date and geography.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - BUNDCBSA (Lines 000100-000900): Bundled CBSA wage index records with effective dates.

    @rule_id:REF-BUNDCBSA-001
    Scenario: Use bundled CBSA wage index records
      Given a claim requires a bundled CBSA wage index
      When the bundled CBSA wage index is looked up
      Then the effective wage index factor is selected for the claim
      And the factor is available for downstream calculations
