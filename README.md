# ESRD CY21.2 Mainframe Pricer - Reverse Engineering Artifacts

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

### 2. `rules/` - Machine Readable Business Logic (YAML)
These files abstract the legacy business logic into a vendor-neutral, declarative YAML schema. They represent the executable rules of the system, decoupled from the complex COBOL runtime environment.
* **[escal212_rules.yaml](rules/escal212_rules.yaml)**: The core mathematical pricing calculations, adjustments, case-mix logic, and multiplier assignments.
* **[esdrv212_rules.yaml](rules/esdrv212_rules.yaml)**: The high-level orchestration, transition exception overrides, and routing boundaries executed by the driver program.
* **[historical_calc_rules.yaml](rules/historical_calc_rules.yaml)**: The abstracted logical routing governing the execution of 20 legacy calculation modules (`ESCAL056` -> `ESCAL202`).
* **[reference_table_rules.yaml](rules/reference_table_rules.yaml)**: Base rate lookups and geographic wage index modifiers modeled from hardcoded copybooks and flat files.
* **[copybook_rules.yaml](rules/copybook_rules.yaml)**: Input interface schemas (`BILLCPY`) and outcome semantic code mappings (`RTCCPY`).

### 3. `scripts/` - Validation & Tooling
* **[rule_validator.py](scripts/rule_validator.py)**: A Python test harness used to syntactically validate the extracted YAML rules. It asserts that the abstracted logic adheres to the expected schema constraints so they are structurally sound and ready for ingestion into modern execution environments (e.g. Drools, JSON rules, modern application code).
