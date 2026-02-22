Feature: Base rate reference table (BASERATE)
  # Description: Defines base payment rates by state/CBSA and effective date.
  # COBOL: BASERATE (flat file table)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2005-04-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given a claim is submitted for pricing

  Rule: Base rate table enumerates effective base payment rates
    # Description: Base rate records include effective date and rate values by geographic identifier.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - BASERATE (Lines 000100-000900): Base rate records with effective date and rates.

    @rule_id:REF-BASE-001
    Scenario: Use base rate records for payment initialization
      Given a claim requires a base payment rate
      When the base rate is looked up
      Then the effective base rate is selected for the claim
      And the base rate is available for downstream calculations
