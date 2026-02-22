Feature: Claim input/output record layout (BILLCPY)
  # Description: Defines the bill input fields and derived outputs passed between driver and calculation modules.
  # COBOL: BILLCPY (copybook)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2005-04-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given a claim is submitted for pricing

  Rule: Bill copybook defines required claim inputs
    # Description: The bill record defines condition, revenue, patient, and provider fields used in rules.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - BILLCPY (Lines 002700-010800): BILL-NEW-DATA fields for condition, revenue, patient, provider, and comorbid inputs.

    @rule_id:REF-BILL-001
    Scenario: Use bill input fields for pricing rules
      Given a claim is represented by BILL-NEW-DATA
      When the claim is validated and priced
      Then the defined bill fields provide required inputs
      And the field layout is used consistently across modules
