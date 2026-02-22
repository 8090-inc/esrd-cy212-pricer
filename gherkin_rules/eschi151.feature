Feature: Children's hospital wage index override table (ESCHI151)
  # Description: Defines provider-specific wage index overrides for designated children's hospitals.
  # COBOL: ESCHI151 (table definition)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2015-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given a claim is submitted for pricing

  Rule: Children's hospital override table defines provider-specific wage indexes
    # Description: The table maps provider numbers to special wage index values used by the driver.
    # Policy Citations:
    # - CLM104C08-REV10640 §20.2 Pediatric Payment Model (under 18) (P16:L602-606)
    # Code Path Citations:
    # - ESCHI151 (Lines 000700-001900): CHILD-HOSP-TABLE with provider and SWI values.

    @rule_id:REF-CHILD-001
    Scenario: Use children's hospital provider override values
      Given a provider matches a children's hospital entry
      When the children\'s hospital override list is checked
      Then the mapped wage index override is available for use
      And the override list contains provider-specific wage indexes
