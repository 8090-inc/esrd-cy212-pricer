Feature: MSA wage adjusted rate table (ESWRT151)
  # Description: Defines effective dates and MSA mapping entries for wage adjusted rate lookup.
  # COBOL: ESWRT151 (table definition)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2005-04-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given a claim is submitted for pricing

  Rule: MSA effective date table defines wage adjusted rate dates
    # Description: MSA wage rate lookups use the WWD date table for effective dating.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESWRT151 (Lines 000100-001000): WWD-ENTRY table and date code definitions.

    @rule_id:REF-MSA-001
    Scenario: Use MSA date table for effective dating
      Given a claim date is evaluated for MSA wage rates
      When MSA wage rate effective dates are applied
      Then the effective date table provides the correct date code
      And the date table governs MSA wage rate selection

  Rule: MSA mapping table enumerates MSA entries
    # Description: MSA wage rate lookups use the MSA mapping entries defined in the table.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESWRT151 (Lines 001100-004000): W-WART-MSA-FILLS entries define MSA mapping records.

    @rule_id:REF-MSA-002
    Scenario: Use MSA mapping entries for lookup
      Given a claim includes an MSA code
      When the MSA wage rate is looked up
      Then the MSA entry is found using the mapping table
      And the mapping points to the correct wage rate record
