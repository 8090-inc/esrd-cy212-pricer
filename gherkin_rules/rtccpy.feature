Feature: Return code definitions (RTCCPY)
  # Description: Enumerates return codes and their meanings for calculation and driver outcomes.
  # COBOL: RTCCPY (copybook)
  # Policy: See policy_version_index.csv for source mapping
  # Effective: 2011-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given the pricer produces a return code

  Rule: Calculation return codes define adjustment combinations
    # Description: PPS-RTC codes 02-35 map to adjustment combinations (outlier, training, comorbid, low volume, etc.).
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - RTCCPY (Lines 000900-004400): Calculation return code definitions.

    @rule_id:REF-RTC-001
    Scenario: Interpret calculation return codes
      Given the calculator sets PPS-RTC
      When the return code is between 02 and 35
      Then the code maps to a defined adjustment combination
      And the meaning matches the return code table

  Rule: Calculation return codes define edit failures
    # Description: PPS-RTC codes 52-98 indicate validation errors or invalid inputs.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - RTCCPY (Lines 004500-008300): Calculation and driver error return codes.

    @rule_id:REF-RTC-002
    Scenario: Interpret validation error return codes
      Given the calculator or driver rejects a claim
      When the return code is between 50 and 99
      Then the code indicates the validation failure reason
      And the meaning matches the return code table
