Feature: Bundled CBSA wage index table (ESBUN210)
  # Description: Defines effective dates and CBSA mapping entries for bundled wage index lookup.
  # COBOL: ESBUN210 (table definition)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2011-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given a claim is submitted for pricing

  Rule: Bundled CBSA date table defines effective date codes
    # Description: Bundled wage index lookups use the BUN-DATE table of effective dates and codes.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESBUN210 (Lines 000100-001300): BUN-DATE-TABLE and BUN-DATE-CODE entries.

    @rule_id:REF-BUN-001
    Scenario: Use bundled CBSA date table for effective dating
      Given a claim date is evaluated for bundled wage index lookup
      When bundled wage index effective dates are applied
      Then the effective date table provides the correct date code
      And the date table governs bundled CBSA selection

  Rule: Bundled CBSA mapping table enumerates CBSA entries
    # Description: Bundled CBSA lookups use the CBSA mapping entries defined in the bundled table.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESBUN210 (Lines 001400-004000): BUN-CBSA-FILLER entries define CBSA mapping records.

    @rule_id:REF-BUN-002
    Scenario: Use bundled CBSA mapping entries for lookup
      Given a claim includes a CBSA code
      When the bundled CBSA mapping is looked up
      Then the CBSA entry is found using the bundled table mapping
      And the mapping points to the correct wage index record
