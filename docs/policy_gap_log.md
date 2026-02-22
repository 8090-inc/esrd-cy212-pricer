# Policy Gaps & Mismatches Log (CY2021.2)

This log captures discrepancies between COBOL logic, DSL artifacts, and published CMS policy.

## Mismatches (Policy vs COBOL)
1. **Revenue Code 0880 not accepted by COBOL validation.**  
   Policy allows 0880 in the per-treatment claim data table, but COBOL only accepts 0821/0831/0841/0851/0881.  
   Impact: Legitimate 0880 claims would be rejected with RTC 57.

## Coverage Gaps (Policy vs DSL/Human Docs)
1. **Revenue code `0880` policy allowance vs COBOL validation.**  
   Policy allows 0880, COBOL rejects it. This is a policy/code mismatch and remains open.

## Resolved in This Pass
1. **Network fee reduction added to DSL.**  
   Implemented as CAL-019.

2. **Outlier policy added to DSL.**  
   Implemented as CAL-021, with supporting factor steps.

3. **TDAPA/TPNIES added to DSL.**  
   Implemented as CAL-017.

4. **ETC HDPA policy added to DSL.**  
   Implemented as CAL-020.

5. **Supplemental wage index cap added to DSL.**  
   Implemented as REF-WAGE-004.

2. **Children's hospital wage index override not found in Addendum A.**
   Parsed CMS-1732-F Addendum A wage index file (county CBSA crosswalk). It contains county wage index data only; no provider-specific children's hospital override list is present.
