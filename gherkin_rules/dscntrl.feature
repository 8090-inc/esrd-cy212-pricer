Feature: Dialog system control block (DSCNTRL)
  # Description: Defines runtime control codes used to distinguish mainframe and PC error handling paths.
  # COBOL: DSCNTRL (copylib)
  # Policy: Internal/No policy citation found
  # Effective: 2005-04-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given the driver evaluates environment-specific error codes

  Rule: Dialog system error codes define runtime error handling
    # Description: DS-ERROR-CODE and related flags determine mainframe vs PC error handling branches.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - DSCNTRL (Lines 003000-007400): DS-ERROR-CODE definitions and flags.

    @rule_id:REF-DS-001
    Scenario: Use dialog system error codes to branch runtime behavior
      Given the dialog system control block is loaded
      When the driver checks DS-ERROR-CODE or related flags
      Then the runtime path is determined by the control block values
      And error handling follows the appropriate environment rules
