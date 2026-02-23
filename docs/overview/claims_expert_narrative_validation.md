# Claims Expert Narrative Validation

Each sentence from `docs/overview/claims_expert_narrative.md` is validated against COBOL-linked rules.

| # | Sentence | Evidence (Rule ID → COBOL lines) | Status | Notes |
| --- | --- | --- | --- | --- |
| 1 | This document provides a plain‑language narrative of how a dialysis claim is priced under the ESRD PPS rules represented in this repository. | N/A | N/A |  |
| 2 | It is written for claims and policy experts and uses full sentences without technical program references. | N/A | N/A |  |
| 3 | A dialysis claim enters pricing with the required claim dates, provider information, and billing details. | DRV-001 (ESDRV212:039700-040000), CAL-000 (ESCAL212:079600-080000), CAL-001A (ESCAL212:080300-080800), CAL-001C (ESCAL212:083900-084500), CAL-001J (ESCAL212:088600-089000) | OK |  |
| 4 | The claim must contain valid condition codes, revenue codes, provider type, special payment indicator, QIP code, and required dates. | CAL-000 (ESCAL212:079600-080000), CAL-001C (ESCAL212:083900-084500), CAL-001A (ESCAL212:080300-080800), CAL-001B (ESCAL212:081100-081400), CAL-001D (ESCAL212:084800-085200), CAL-001J (ESCAL212:088600-089000), CAL-001K (ESCAL212:089300-089600) | OK |  |
| 5 | For non‑AKI claims, height, weight, dialysis session count, outlier total charges, and the comorbidity return code must also be present and valid, and height/weight must be within allowed limits. | CAL-001E (ESCAL212:082300-082800), CAL-001F (ESCAL212:083100-083600), CAL-001G (ESCAL212:085800-086200), CAL-001H (ESCAL212:086600-087000), CAL-001I (ESCAL212:087900-088300), CAL-001L (ESCAL212:089900-090200), CAL-001M (ESCAL212:091600-092300) | OK |  |
| 6 | If required fields are missing or invalid, the claim is rejected with a return code that explains the reason. | DRV-001 (ESDRV212:039700-040000), DRV-002 (ESDRV212:040200-040500), CAL-000 (ESCAL212:079600-080000) | OK |  |
| 7 | If a claim passes these checks, pricing continues. | DRV-001 (ESDRV212:039700-040000), CAL-000 (ESCAL212:079600-080000) | OK |  |
| 8 | The claim is evaluated to determine whether it is an ESRD dialysis claim or an Acute Kidney Injury (AKI) claim. | CAL-000 (ESCAL212:079600-080000), CAL-001P (ESCAL212:077700-079000) | OK |  |
| 9 | AKI claims follow a simplified pricing path that bypasses ESRD case‑mix adjustments and does not apply the QIP reduction; the payment is set to the wage‑adjusted base amount. | CAL-001P (ESCAL212:077700-079000), CAL-018 (ESCAL212:213200-215800) | OK |  |
| 10 | ESRD claims follow the full pricing path with patient‑level and facility‑level adjustments. | CAL-003A (ESCAL212:107600-108900), CAL-004 (ESCAL212:111700-112600), CAL-005 (ESCAL212:113100-113900), CAL-009 (ESCAL212:114400-116700), CAL-011 (ESCAL212:117200-121200), CAL-012 (ESCAL212:121700-122900), CAL-013 (ESCAL212:123400-123700) | OK |  |
| 11 | For ESRD claims, the system determines the appropriate wage index based on the facility’s location. | DRV-WAGE-008 (ESDRV212:106300-109100), DRV-WAGE-010 (ESDRV212:112200-114600) | OK |  |
| 12 | The standard wage index is looked up using the facility’s CBSA or county mapping for the claim year. | DRV-WAGE-008 (ESDRV212:106300-109100), DRV-WAGE-010 (ESDRV212:112200-114600) | OK |  |
| 13 | If a special wage index applies, the special value is used instead of the standard lookup. | DRV-WAGE-006 (ESDRV212:104500-104900), DRV-WAGE-007 (ESDRV212:105100-106100) | OK | Special wage index includes special payment indicator and children's hospital override (policy gap for DRV-WAGE-007). |
| 14 | If the supplemental wage index indicator is on for the claim and the claim date is after September 30, 2020, any decrease greater than 5 percent is capped at 5 percent. | DRV-WAGE-009 (ESDRV212:109300-111300) | OK |  |
| 15 | The final wage index is then used to adjust the labor‑related portion of the base payment. | CAL-002 (ESCAL212:093700-094500), DRV-WAGE-008 (ESDRV212:106300-109100) | OK |  |
| 16 | The base payment rate is split into a labor‑related portion and a non‑labor portion. | CAL-002 (ESCAL212:093700-094500) | OK |  |
| 17 | The wage index is applied to the labor‑related portion, and the non‑labor portion remains unadjusted. | CAL-002 (ESCAL212:093700-094500) | OK |  |
| 18 | The sum of these two portions produces the wage‑adjusted base payment amount, which is the starting point for the remaining adjustments. | CAL-002 (ESCAL212:093700-094500) | OK |  |
| 19 | The pricing logic applies patient‑level adjustments to reflect clinical complexity. | CAL-003A (ESCAL212:107600-108900), CAL-004 (ESCAL212:111700-112600), CAL-005 (ESCAL212:113100-113900), CAL-009 (ESCAL212:114400-116700), CAL-011 (ESCAL212:117200-121200) | OK |  |
| 20 | The patient’s age category is determined from the date of birth and service date. | CAL-008 (ESCAL212:094900-095500) | OK |  |
| 21 | For pediatric patients, pediatric‑specific adjustments apply and adult‑only adjustments such as low‑volume and low‑BMI are bypassed. | CAL-003A (ESCAL212:107600-108900), CAL-004B (ESCAL212:112000-112600), CAL-005 (ESCAL212:113100-113900), CAL-012 (ESCAL212:121700-122900) | OK |  |
| 22 | For adults, body surface area (BSA), body mass index (BMI), dialysis onset status (≤120 days), and comorbidities are evaluated. | CAL-004 (ESCAL212:111700-112600), CAL-005 (ESCAL212:113100-113900), CAL-009 (ESCAL212:114400-116700), CAL-011 (ESCAL212:117200-121200) | OK |  |
| 23 | If multiple comorbidities are present, only the single highest‑paying comorbidity adjustment is applied. | CAL-011 (ESCAL212:117200-121200) | OK |  |
| 24 | These factors combine into a patient‑level adjustment multiplier. | CAL-014 (ESCAL212:124200-124600) | OK |  |
| 25 | Facility‑level adjustments are applied based on the facility’s characteristics. | CAL-012 (ESCAL212:121700-122900), CAL-013 (ESCAL212:123400-123700) | OK |  |
| 26 | Low‑volume facilities receive a low‑volume adjustment if eligibility criteria are met. | CAL-012 (ESCAL212:121700-122900) | OK |  |
| 27 | Rural facilities receive a rural adjustment when applicable. | CAL-013 (ESCAL212:123400-123700) | OK |  |
| 28 | These adjustments are applied to the base payment after patient‑level factors are determined. | CAL-012 (ESCAL212:121700-122900), CAL-013 (ESCAL212:123400-123700), CAL-014 (ESCAL212:124200-124600) | OK |  |
| 29 | Certain add‑on payments are applied when the claim meets eligibility criteria. | CAL-015 (ESCAL212:125100-128200), CAL-017 (ESCAL212:131200-133300) | OK |  |
| 30 | Training add‑on payments apply when the claim reflects training services. | CAL-015 (ESCAL212:125100-128200) | OK |  |
| 31 | TDAPA and TPNIES add‑ons apply to eligible claims with approved products. | CAL-017 (ESCAL212:131200-133300) | OK |  |
| 32 | These add‑ons are layered on top of the adjusted base payment. | CAL-016 (ESCAL212:128700-130700), CAL-017 (ESCAL212:131200-133300) | OK |  |
| 33 | For ESRD claims, a quality reduction may apply based on the facility’s QIP performance indicator. | CAL-007 (ESCAL212:095900-097700), CAL-018 (ESCAL212:213200-215800) | OK |  |
| 34 | The QIP code determines the reduction factor, and the payment is reduced accordingly. | CAL-007 (ESCAL212:095900-097700), CAL-018 (ESCAL212:213200-215800) | OK |  |
| 35 | AKI claims do not receive the QIP reduction. | CAL-018 (ESCAL212:213200-215800), CAL-001P (ESCAL212:077700-079000) | OK |  |
| 36 | An ESRD network reduction is applied to the claim based on billing type. | CAL-019 (ESCAL212:134700-135100) | OK |  |
| 37 | Per‑diem claims receive the per‑diem reduction amount, while standard ESRD claims receive the standard network reduction. | CAL-019 (ESCAL212:134700-135100) | OK |  |
| 38 | This reduction is applied to the final payment amount. | CAL-019 (ESCAL212:134700-135100) | OK |  |
| 39 | Outlier eligibility is evaluated after base and adjustment calculations are complete. | CAL-021 (ESCAL212:145200-167900) | OK |  |
| 40 | If the claim qualifies, the outlier payment is calculated based on imputed and predicted MAP values and applied to the final payment. | CAL-021 (ESCAL212:145200-167900) | OK |  |
| 41 | Per‑diem claims apply the per‑diem scaling rules to outlier amounts where required. | CAL-021 (ESCAL212:145200-167900) | OK |  |
| 42 | The final payment amount is assembled from the wage‑adjusted base payment, patient‑level adjustments, facility‑level adjustments, add‑ons, and reductions. | CAL-016 (ESCAL212:128700-130700), CAL-017 (ESCAL212:131200-133300), CAL-018 (ESCAL212:213200-215800), CAL-019 (ESCAL212:134700-135100) | OK |  |
| 43 | The claim is assigned a return code that summarizes which adjustments or outcomes applied. | CAL-022 (ESCAL212:187000-204900) | OK |  |
| 44 | The final payment and return code are set on the claim output record. | CAL-016 (ESCAL212:128700-130700), CAL-022 (ESCAL212:187000-204900) | OK |  |
| 45 | Claims with older service dates are routed to year‑appropriate pricing logic to ensure historically accurate payment rules. | DRV-005 (ESDRV212:052000-052800) | OK |  |
| 46 | Older service dates are priced under their historical rules. | DRV-005 (ESDRV212:052000-052800) | OK |  |
