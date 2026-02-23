# Architecture Diagrams (New)

This document adds new diagrams to complement `docs/diagrams/system_architecture.md`. All diagrams use Mermaid for easy rendering.

## 1) System Context and Data Flow

```mermaid
flowchart LR
    Claim[External Claims System] -->|BILLCPY Input| Driver[ESDRV212 Driver]
    Driver -->|WAGECPY| Calc[ESCALxxx Calculator]
    Driver -->|MSA/CBSA Lookups| RefTables[ESWRT151 / ESCOM151 / ESBUN210 / ESCHI151]
    Calc -->|PPS-DATA-ALL + RTC| Driver
    Driver -->|Final Output| Claim

    Policy[CMS Policy Sources] -.-> Trace[Traceability Matrix]
    Cobol[COBOL Source] --> Trace
    Gherkin[Gherkin Rules] --> Trace
    Tests[Regression Cases] --> Trace
```

## 2) Pricing Pipeline (Business View)

```mermaid
flowchart TD
    Start[Claim Submitted] --> Vals[Validate Claim Elements]
    Vals --> Base[Compute Base Wage Amount]
    Base --> Factors[Apply Patient Factors\nAge, BSA, BMI, Onset, Comorbidity]
    Factors --> Facility[Apply Facility Factors\nLow-Volume, Rural]
    Facility --> Addons[Apply Add-Ons\nTraining, TDAPA, TPNIES]
    Addons --> QIP[Apply QIP Reduction]
    QIP --> Network[Apply Network Reduction]
    Network --> Outlier[Calculate Outlier Payment]
    Outlier --> Final[Assemble Final Payment + Return Code]
```

## 3) Wage Index Resolution Path

```mermaid
flowchart TD
    WageStart[Wage Index Needed] --> Special[Special Payment Indicator?]
    Special -- Yes --> SpecWI[Use Provider-Supplied Wage Index]
    Special -- No --> Child[Children's Hospital Override?]
    Child -- Yes --> ChildWI[Use Children’s Hospital Override Index]
    Child -- No --> CBSA[Lookup CBSA Wage Index]
    CBSA --> Cap[Apply 5% Decrease Cap (if enabled)]
    Cap --> WageDone[Wage Index Selected]
```

## 4) Rule Governance and Traceability

```mermaid
flowchart LR
    Cobol[COBOL Source Files] --> Gherkin[Gherkin Rule Files]
    Gherkin --> Trace[Traceability Matrix]
    Policy[Policy Version Index] --> Trace
    Trace --> Cases[Regression Baseline Cases]
    Cases --> Tests[Executable Test Fixtures]
    Trace --> Reviews[SME Review Cycle]
```
