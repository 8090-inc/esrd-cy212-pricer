Feature: <Feature name>
  # Description: <short narrative summary>
  # COBOL: <PROGRAM>.<SECTION>.<PARAGRAPH> (lines <start>-<end>)
  # Policy: <Policy ID> <section/page/line>
  # Effective: <YYYY-MM-DD> (Transmittal: <ID>, Release: <ID>)

  Background:
    Given the pricer receives a claim

  Rule: <Rule title>
    # Description: <business rationale and intent>
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - <FILE> (Lines <start>-<end>): <what it proves>
    # - <FILE> (Lines <start>-<end>): <what it proves>

    @rule_id:<RULE-ID>
    Scenario: <Short rule intent>
      Given <preconditions>
      When <trigger>
      Then <outcome>
      And <observable outputs>

    @rule_id:<RULE-ID>
    Scenario Outline: <Parameterized rule intent>
      Given <preconditions with <vars>>
      When <trigger>
      Then <outcome>
      And <observable outputs>

      Examples:
        | var1 | var2 |
        | ...  | ...  |
