# ESRD CY21.2 Mainframe Pricer - Reverse Engineering Artifacts

CMS ESRD PPS Pricer v2021.2 — COBOL mainframe source code that calculates Medicare reimbursement for dialysis facility claims. Prices outpatient dialysis treatments for patients with End-Stage Renal Disease under the Prospective Payment System. Includes 25 calculation modules spanning rate years 2005–2021, a driver program (ESDRV212), bundled services logic (ESBUN210), copybooks for bill input/output, base rates, and wage indices. Repo also contains reverse-engineered artifacts: human-readable rule docs, Gherkin business rules, system architecture diagrams, and validation tooling.

This repository contains both the original legacy COBOL source code for the Center for Medicare and Medicaid Services (CMS) End-Stage Renal Disease (ESRD) CY21.2 Pricer and the comprehensive suite of **reverse-engineered artifacts** generated from analyzing this codebase.

## Project Objective
The goal of this project was to exhaustively analyze the ~34 files in the ESRD Pricer legacy codebase (calculation modules, driver programs, reference data tables, and copybooks) and synthesize them into modern, human-readable documentation and machine-readable configurations.

## Generated Assets

The generated assets are organized into three primary directories:

### 1. `docs/` - Human Readable Documentation
These artifacts explain the system and business rules for human Subject Matter Experts (SMEs), Business Analysts, and Software Engineers.
* **[human_readable_rules.md](docs/human_readable_rules.md)**: The comprehensive rulebook. Details the procedural logic, validations, mathematical formulas, data dictionary structures, reference table mappings, and historical version routing logic.
* **[system_architecture.md](docs/system_architecture.md)**: Technical design document featuring Mermaid.js UML sequence and component diagrams that map the internal data flow, component interactions, and execution routing.
* **[rule_traceability.md](docs/rule_traceability.md)**: The lineage tracking matrix. This maps the human and machine-readable business rules back to their exact line origins within the legacy COBOL codebase, establishing code-to-rule provenance.
* **[implementation_plan.md](docs/implementation_plan.md)** & **[task.md](docs/task.md)**: Project management artifacts capturing the reverse engineering strategy, execution methodology, and phase tracking.

### 2. `gherkin_rules/` - Machine Readable Business Logic (Gherkin)
These files are the authoritative, SME-readable rule specifications in Gherkin (`.feature`). They are denormalized and intent-focused, avoiding COBOL control flow.
* **[esdrv212.feature](gherkin_rules/esdrv212.feature)**: Driver validation, exception handling, and routing rules.
* **[ _template.feature](gherkin_rules/_template.feature)**: Standard scenario template.

### 3. `rules/` - Legacy YAML Artifacts (Deprecated)
These files are legacy outputs from earlier iterations and are retained only for migration reference. They are no longer the active DSL.
* **[escal212_rules.yaml](rules/escal212_rules.yaml)**: Legacy extraction of CY2021.2 calculations.
* **[esdrv212_rules.yaml](rules/esdrv212_rules.yaml)**: Legacy driver routing rules.
* **[historical_calc_rules.yaml](rules/historical_calc_rules.yaml)**: Legacy routing abstraction.
* **[reference_table_rules.yaml](rules/reference_table_rules.yaml)**: Legacy reference table rules.
* **[copybook_rules.yaml](rules/copybook_rules.yaml)**: Legacy copybook mappings.

### 4. `scripts/` - Validation & Tooling
* **[rule_validator.py](scripts/rule_validator.py)**: A Python test harness used to syntactically validate the extracted YAML rules. It asserts that the abstracted logic adheres to the expected schema constraints so they are structurally sound and ready for ingestion into modern execution environments (e.g. Drools, JSON rules, modern application code).
