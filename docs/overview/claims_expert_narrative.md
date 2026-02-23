# Claims Expert Narrative: ESRD PPS Pricing (CY21.2)

This document provides a plain‑language narrative of how a dialysis claim is priced under the ESRD PPS rules represented in this repository. It is written for claims and policy experts and uses full sentences without technical program references.

## 1) Claim Intake and Basic Validity

A dialysis claim enters pricing with the required claim dates, provider information, and billing details. The claim must contain valid condition codes, revenue codes, provider type, special payment indicator, QIP code, and required dates. For non‑AKI claims, height, weight, dialysis session count, outlier total charges, and the comorbidity return code must also be present and valid, and height/weight must be within allowed limits. If required fields are missing or invalid, the claim is rejected with a return code that explains the reason. If a claim passes these checks, pricing continues.

## 2) Claim Type: ESRD vs AKI

The claim is evaluated to determine whether it is an ESRD dialysis claim or an Acute Kidney Injury (AKI) claim. AKI claims follow a simplified pricing path that bypasses ESRD case‑mix adjustments and does not apply the QIP reduction; the payment is set to the wage‑adjusted base amount. ESRD claims follow the full pricing path with patient‑level and facility‑level adjustments.

## 3) Geographic Wage Index

For ESRD claims, the system determines the appropriate wage index based on the facility’s location. The standard wage index is looked up using the facility’s CBSA or county mapping for the claim year. If a special wage index applies, the special value is used instead of the standard lookup. If the supplemental wage index indicator is on for the claim and the claim date is after September 30, 2020, any decrease greater than 5 percent is capped at 5 percent. The final wage index is then used to adjust the labor‑related portion of the base payment.

## 4) Base Payment

The base payment rate is split into a labor‑related portion and a non‑labor portion. The wage index is applied to the labor‑related portion, and the non‑labor portion remains unadjusted. The sum of these two portions produces the wage‑adjusted base payment amount, which is the starting point for the remaining adjustments.

## 5) Patient‑Level Adjustments

The pricing logic applies patient‑level adjustments to reflect clinical complexity. The patient’s age category is determined from the date of birth and service date. For pediatric patients, pediatric‑specific adjustments apply and adult‑only adjustments such as low‑volume and low‑BMI are bypassed. For adults, body surface area (BSA), body mass index (BMI), dialysis onset status (≤120 days), and comorbidities are evaluated. If multiple comorbidities are present, only the single highest‑paying comorbidity adjustment is applied. These factors combine into a patient‑level adjustment multiplier.

## 6) Facility‑Level Adjustments

Facility‑level adjustments are applied based on the facility’s characteristics. Low‑volume facilities receive a low‑volume adjustment if eligibility criteria are met. Rural facilities receive a rural adjustment when applicable. These adjustments are applied to the base payment after patient‑level factors are determined.

## 7) Add‑On Payments

Certain add‑on payments are applied when the claim meets eligibility criteria. Training add‑on payments apply when the claim reflects training services. TDAPA and TPNIES add‑ons apply to eligible claims with approved products. These add‑ons are layered on top of the adjusted base payment.

## 8) Quality Incentive Program (QIP) Reduction

For ESRD claims, a quality reduction may apply based on the facility’s QIP performance indicator. The QIP code determines the reduction factor, and the payment is reduced accordingly. AKI claims do not receive the QIP reduction.

## 9) ESRD Network Reduction

An ESRD network reduction is applied to the claim based on billing type. Per‑diem claims receive the per‑diem reduction amount, while standard ESRD claims receive the standard network reduction. This reduction is applied to the final payment amount.

## 10) Outlier Payment

Outlier eligibility is evaluated after base and adjustment calculations are complete. If the claim qualifies, the outlier payment is calculated based on imputed and predicted MAP values and applied to the final payment. Per‑diem claims apply the per‑diem scaling rules to outlier amounts where required.

## 11) Final Payment and Return Code

The final payment amount is assembled from the wage‑adjusted base payment, patient‑level adjustments, facility‑level adjustments, add‑ons, and reductions. The claim is assigned a return code that summarizes which adjustments or outcomes applied. The final payment and return code are set on the claim output record.

## 12) Historical Routing

Claims with older service dates are routed to year‑appropriate pricing logic to ensure historically accurate payment rules. Older service dates are priced under their historical rules.
