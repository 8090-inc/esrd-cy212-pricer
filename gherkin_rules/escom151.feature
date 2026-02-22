Feature: Composite CBSA wage index table (ESCOM151)
  # Description: Defines effective dates and CBSA mapping entries for composite wage index lookup.
  # COBOL: ESCOM151 (table definition)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2006-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given the pricer receives a claim

  Rule: Composite CBSA date table defines effective date codes
    # Description: Composite wage index lookups use the COM-DATE table of effective dates and codes.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESCOM151 (Lines 000100-001100): COM-DATE-TABLE and COM-DATE-CODE entries.

    @rule_id:REF-COM-001
    Scenario: Use composite CBSA date table for effective dating
      Given a claim date is evaluated for composite wage index lookup
      When the driver consults composite wage index effective dates
      Then the effective date table provides the correct date code
      And the date table governs composite CBSA selection

  Rule: Composite CBSA mapping table enumerates CBSA entries
    # Description: Composite CBSA lookups use the CBSA mapping entries defined in the composite table.
    # Policy Citations:
    # - FR-2020-24485 Wage index applied to labor-related share (52.3%) (P31:L6474-6483)
    # Code Path Citations:
    # - ESCOM151 (Lines 001200-004000): COM-CBSA-FILLER entries define CBSA mapping records.

    @rule_id:REF-COM-002
    Scenario: Use composite CBSA mapping entries for lookup
      Given a claim includes a CBSA code
      When the driver searches the composite CBSA mapping table
      Then the CBSA entry is found using the composite table mapping
      And the mapping points to the correct wage index record
