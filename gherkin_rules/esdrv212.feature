Feature: Driver routing and exception handling (ESDRV212)
  # Description: Validates input, applies exception rate overrides, and routes claims to the correct calculation module by thru date.
  # COBOL: ESDRV212.0100-ENTER-DRIVER (lines 038000-082500)
  # Policy: Internal/No policy citation found (routing/control logic)
  # Effective: 2021-01-01 (Transmittal: TBD, Release: TBD)

  Background:
    Given the pricer receives a claim

  Rule: Reject claims with invalid or pre-cutoff thru dates
    # Description: Claims with non-numeric or pre-2005-04-01 thru dates are rejected with return code 98.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 039700-040000): IF B-THRU-DATE < 20050401 OR NOT NUMERIC -> MOVE 98 -> EXIT.

    @rule_id:DRV-001
    Scenario: Reject claims with invalid or pre-cutoff thru dates
      Given the claim thru date is before 2005-04-01 or is non-numeric
      When the driver validates the claim date
      Then the return code is 98
      And calculation is not executed

  Rule: Reject claims with non-numeric exception rate
    # Description: Exception rate must be numeric or the claim is rejected with return code 50.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 040200-040500): IF P-ESRD-RATE NOT NUMERIC -> MOVE 50 -> EXIT.

    @rule_id:DRV-002
    Scenario: Reject claims with non-numeric exception rate
      Given the exception rate is non-numeric
      When the driver validates the exception rate
      Then the return code is 50
      And calculation is not executed

  Rule: Apply exception rate for pre-2011 claims
    # Description: For claims before 2011, a positive exception rate overrides standard processing.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 042000-042400): IF B-THRU-DATE < 20110101 AND P-ESRD-RATE > 0 -> MOVE rate -> RTC 01 -> EXIT.

    @rule_id:DRV-003
    Scenario: Apply exception rate for pre-2011 claims
      Given the claim thru date is before 2011-01-01
      And the exception rate is greater than zero
      When the driver processes the claim
      Then the final payment equals the exception rate
      And the return code is 1

  Rule: Apply exception rate for Pacific Island Trust Territories during transition
    # Description: Trust Territories with positive exception rate are paid at exception rate during 2011-2013.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 042600-043300): IF 2011-2013 AND P-PACIFIC-IS-TRUST-TERR='2' AND rate>0 -> MOVE rate -> RTC 01 -> EXIT.

    @rule_id:DRV-004
    Scenario: Apply exception rate for Pacific Island Trust Territories (2011-2013)
      Given the claim thru date is between 2011-01-01 and 2013-12-31
      And the Pacific Island Trust Territories indicator equals 2
      And the exception rate is greater than zero
      When the driver processes the claim
      Then the final payment equals the exception rate
      And the return code is 1

  Rule: Route CY2021 claims to ESCAL212
    # Description: Claims in CY2021 are routed to the 21.2 calculator.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 052000-052800): IF 20210101-20211231 -> CALL ESCAL212.

    @rule_id:DRV-005
    Scenario: Route CY2021 claims to ESCAL212
      Given the claim thru date is between 2021-01-01 and 2021-12-31
      When the driver routes the claim
      Then the calculation module ESCAL212 is called

  Rule: Route CY2020 H2 claims to ESCAL202
    # Description: Claims in 2020-07-01 through 2020-12-31 are routed to ESCAL202.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 053600-054400): IF 20200701-20201231 -> CALL ESCAL202.

    @rule_id:DRV-006
    Scenario: Route CY2020 H2 claims to ESCAL202
      Given the claim thru date is between 2020-07-01 and 2020-12-31
      When the driver routes the claim
      Then the calculation module ESCAL202 is called

  Rule: Route CY2020 H1 claims to ESCAL200
    # Description: Claims in 2020-01-01 through 2020-06-30 are routed to ESCAL200.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 055200-056000): IF 20200101-20200630 -> CALL ESCAL200.

    @rule_id:DRV-007
    Scenario: Route CY2020 H1 claims to ESCAL200
      Given the claim thru date is between 2020-01-01 and 2020-06-30
      When the driver routes the claim
      Then the calculation module ESCAL200 is called

  Rule: Route CY2019 claims to ESCAL191
    # Description: Claims in CY2019 are routed to ESCAL191.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 056800-057600): IF 20190101-20191231 -> CALL ESCAL191.

    @rule_id:DRV-008
    Scenario: Route CY2019 claims to ESCAL191
      Given the claim thru date is between 2019-01-01 and 2019-12-31
      When the driver routes the claim
      Then the calculation module ESCAL191 is called

  Rule: Route CY2018 claims to ESCAL180
    # Description: Claims in CY2018 are routed to ESCAL180.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 058300-059100): IF 20180101-20181231 -> CALL ESCAL180.

    @rule_id:DRV-009
    Scenario: Route CY2018 claims to ESCAL180
      Given the claim thru date is between 2018-01-01 and 2018-12-31
      When the driver routes the claim
      Then the calculation module ESCAL180 is called

  Rule: Route CY2017 H2 claims to ESCAL171
    # Description: Claims in 2017-07-01 through 2017-12-31 are routed to ESCAL171.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 059800-060600): IF 20170701-20171231 -> CALL ESCAL171.

    @rule_id:DRV-010
    Scenario: Route CY2017 H2 claims to ESCAL171
      Given the claim thru date is between 2017-07-01 and 2017-12-31
      When the driver routes the claim
      Then the calculation module ESCAL171 is called

  Rule: Route CY2017 H1 claims to ESCAL170
    # Description: Claims in 2017-01-01 through 2017-06-30 are routed to ESCAL170.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 061300-062100): IF 20170101-20170630 -> CALL ESCAL170.

    @rule_id:DRV-011
    Scenario: Route CY2017 H1 claims to ESCAL170
      Given the claim thru date is between 2017-01-01 and 2017-06-30
      When the driver routes the claim
      Then the calculation module ESCAL170 is called

  Rule: Route CY2016 claims to ESCAL160
    # Description: Claims in CY2016 are routed to ESCAL160.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 062800-063600): IF 20160101-20161231 -> CALL ESCAL160.

    @rule_id:DRV-012
    Scenario: Route CY2016 claims to ESCAL160
      Given the claim thru date is between 2016-01-01 and 2016-12-31
      When the driver routes the claim
      Then the calculation module ESCAL160 is called

  Rule: Route CY2015 claims to ESCAL151
    # Description: Claims in CY2015 are routed to ESCAL151.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 064300-065100): IF 20150101-20151231 -> CALL ESCAL151.

    @rule_id:DRV-013
    Scenario: Route CY2015 claims to ESCAL151
      Given the claim thru date is between 2015-01-01 and 2015-12-31
      When the driver routes the claim
      Then the calculation module ESCAL151 is called

  Rule: Route CY2014 claims to ESCAL140
    # Description: Claims in CY2014 are routed to ESCAL140.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 065800-066600): IF 20140101-20141231 -> CALL ESCAL140.

    @rule_id:DRV-014
    Scenario: Route CY2014 claims to ESCAL140
      Given the claim thru date is between 2014-01-01 and 2014-12-31
      When the driver routes the claim
      Then the calculation module ESCAL140 is called

  Rule: Route CY2013 claims to ESCAL130
    # Description: Claims in CY2013 are routed to ESCAL130.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 067300-068100): IF 20130101-20131231 -> CALL ESCAL130.

    @rule_id:DRV-015
    Scenario: Route CY2013 claims to ESCAL130
      Given the claim thru date is between 2013-01-01 and 2013-12-31
      When the driver routes the claim
      Then the calculation module ESCAL130 is called

  Rule: Route CY2012 claims to ESCAL122
    # Description: Claims in CY2012 are routed to ESCAL122.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 068900-069700): IF 20120101-20121231 -> CALL ESCAL122.

    @rule_id:DRV-016
    Scenario: Route CY2012 claims to ESCAL122
      Given the claim thru date is between 2012-01-01 and 2012-12-31
      When the driver routes the claim
      Then the calculation module ESCAL122 is called

  Rule: Route CY2011 claims to ESCAL117
    # Description: Claims in CY2011 are routed to ESCAL117.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 070500-071300): IF 20110101-20111231 -> CALL ESCAL117.

    @rule_id:DRV-017
    Scenario: Route CY2011 claims to ESCAL117
      Given the claim thru date is between 2011-01-01 and 2011-12-31
      When the driver routes the claim
      Then the calculation module ESCAL117 is called

  Rule: Route CY2010 claims to ESCAL100
    # Description: Claims in CY2010 are routed to ESCAL100.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 072100-072800): IF 20100101-20101231 -> CALL ESCAL100.

    @rule_id:DRV-018
    Scenario: Route CY2010 claims to ESCAL100
      Given the claim thru date is between 2010-01-01 and 2010-12-31
      When the driver routes the claim
      Then the calculation module ESCAL100 is called

  Rule: Route CY2009 claims to ESCAL091
    # Description: Claims in CY2009 are routed to ESCAL091.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 073800-074500): IF 20090101-20091231 -> CALL ESCAL091.

    @rule_id:DRV-019
    Scenario: Route CY2009 claims to ESCAL091
      Given the claim thru date is between 2009-01-01 and 2009-12-31
      When the driver routes the claim
      Then the calculation module ESCAL091 is called

  Rule: Route CY2008 claims to ESCAL080
    # Description: Claims in CY2008 are routed to ESCAL080.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 075300-076000): IF 20080101-20081231 -> CALL ESCAL080.

    @rule_id:DRV-020
    Scenario: Route CY2008 claims to ESCAL080
      Given the claim thru date is between 2008-01-01 and 2008-12-31
      When the driver routes the claim
      Then the calculation module ESCAL080 is called

  Rule: Route CY2007 H2 claims to ESCAL071
    # Description: Claims in 2007-04-01 through 2007-12-31 are routed to ESCAL071.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 076800-077500): IF 20070401-20071231 -> CALL ESCAL071.

    @rule_id:DRV-021
    Scenario: Route CY2007 H2 claims to ESCAL071
      Given the claim thru date is between 2007-04-01 and 2007-12-31
      When the driver routes the claim
      Then the calculation module ESCAL071 is called

  Rule: Route CY2007 H1 claims to ESCAL070
    # Description: Claims in 2007-01-01 through 2007-03-31 are routed to ESCAL070.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 078300-079000): IF 20070101-20070331 -> CALL ESCAL070.

    @rule_id:DRV-022
    Scenario: Route CY2007 H1 claims to ESCAL070
      Given the claim thru date is between 2007-01-01 and 2007-03-31
      When the driver routes the claim
      Then the calculation module ESCAL070 is called

  Rule: Route CY2006 claims to ESCAL062
    # Description: Claims in CY2006 are routed to ESCAL062.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 079800-080500): IF 20060101-20061231 -> CALL ESCAL062.

    @rule_id:DRV-023
    Scenario: Route CY2006 claims to ESCAL062
      Given the claim thru date is between 2006-01-01 and 2006-12-31
      When the driver routes the claim
      Then the calculation module ESCAL062 is called

  Rule: Route CY2005 claims to ESCAL056
    # Description: Claims in 2005-04-01 through 2005-12-31 are routed to ESCAL056.
    # Policy Citations:
    # - Internal/No policy citation found
    # Code Path Citations:
    # - ESDRV212 (Lines 081300-081800): IF 20050401-20051231 -> CALL ESCAL056.

    @rule_id:DRV-024
    Scenario: Route CY2005 claims to ESCAL056
      Given the claim thru date is between 2005-04-01 and 2005-12-31
      When the driver routes the claim
      Then the calculation module ESCAL056 is called
