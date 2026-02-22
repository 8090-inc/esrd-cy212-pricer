# Dependency Structure (CY2021.2 Pricer)

This document defines the dependency order between validation, calculation, and payment components for the CY2021.2 pricer.

## High-Level Flow
1. **Driver validation and routing (ESDRV212)**
   - Validate bill-thru date and exception rate.
   - Apply exception-rate overrides (pre-2011, Pacific Trust Territories).
   - Load wage index tables (MSA/CBSA/bundled) and apply special overrides.
   - Route to year-specific calculation module.

2. **Calculation validation (ESCAL212)**
   - Condition codes, provider type, special payment indicator, revenue code, QIP code.
   - DOB, height, weight, session count, service date, dialysis start date, outlier amount.
   - Comorbidity return code validation.

3. **Base wage computation**
   - Compute labor and non-labor components using base rate and wage index.
   - Derive base wage amount.

4. **Patient characteristic factors**
   - Age → age factor and pediatric flag.
   - BSA → BSA factor.
   - BMI → BMI factor and low BMI flag.
   - Onset → onset factor and onset flag.
   - Comorbidity → highest applicable multiplier and acute/chronic flags.
   - Low-volume and rural multipliers.

5. **Adjusted base wage**
   - Multiply base wage by all factors.

6. **Condition code adjustments**
   - Training add-on (73/87).
   - Per-diem logic for home dialysis (74 + 0841/0851).

7. **Payment assembly**
   - Compute final amounts with and without HDPA.
   - Add TDAPA and TPNIES.
   - Apply QIP reduction (non-AKI).
   - Apply network reduction.

8. **ETC HDPA selection**
   - Choose HDPA-adjusted or standard payment using ETC indicator.

9. **Outlier computation**
   - Compute outlier factors (age/BSA/BMI/onset/comorbid/low-vol/rural).
   - Compute predicted MAP vs imputed MAP.
   - Determine outlier payment; apply per-diem scaling if needed.

10. **Low-volume recovery payments**
   - Compute low-volume recovery PPS and outlier adjustments (if applicable).

11. **Return code resolution**
   - Assign PPS-RTC based on adjustment flags.

## Key Dependencies
- **Wage index lookups** must precede any base wage computation.
- **Age** must be computed before age factors, pediatric status, onset, and comorbidity logic.
- **Onset factor** influences comorbidity eligibility.
- **Training add-on** is suppressed if onset factor applies.
- **Per-diem logic** affects network reduction amount and outlier per-diem scaling.
- **QIP reduction** precedes network reduction in COBOL.
- **Network reduction** precedes HDPA selection in COBOL.
- **Outlier payment** depends on imputed MAP, predicted MAP, and fixed-dollar-loss by age band.
- **Return code** depends on final adjustment flags and outlier/low-volume status.
