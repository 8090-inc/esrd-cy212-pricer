# ESRD CY21.2 Mainframe Pricer - Reverse Engineering Artifacts

CMS ESRD PPS Pricer v2021.2 — COBOL mainframe source code that calculates Medicare reimbursement for dialysis facility claims. Prices outpatient dialysis treatments for patients with End-Stage Renal Disease under the Prospective Payment System. Includes 25 calculation modules spanning rate years 2005–2021, a driver program (ESDRV212), bundled services logic (ESBUN210), copybooks for bill input/output, base rates, and wage indices. Repo also contains reverse-engineered artifacts: human-readable rule docs, Gherkin business rules, system architecture diagrams, and validation tooling.

This repository contains both the original legacy COBOL source code for the Center for Medicare and Medicaid Services (CMS) End-Stage Renal Disease (ESRD) CY21.2 Pricer and the comprehensive suite of **reverse-engineered artifacts** generated from analyzing this codebase.

## Project Objective
The goal of this project was to exhaustively analyze the ~34 files in the ESRD Pricer legacy codebase (calculation modules, driver programs, reference data tables, and copybooks) and synthesize them into modern, human-readable documentation and machine-readable configurations.

## Generated Assets

The generated assets are organized into three primary directories:

### 1. `docs/` - Human Readable Documentation
These artifacts explain the system and business rules for human Subject Matter Experts (SMEs), Business Analysts, and Software Engineers.
* **[human_readable_rules.md](docs/human_readable_rules.md)**: Comprehensive rulebook covering logic, validations, formulas, data dictionary structures, and historical routing.
* **[system_architecture.md](docs/system_architecture.md)**: Mermaid.js UML sequence and component diagrams.
* **[dependency_structure.md](docs/dependency_structure.md)**: Execution order and dependency constraints.
* **[normalization_catalog.md](docs/normalization_catalog.md)**: Data prep/derived field specs, separate from business rules.
* **[gherkin_style_guide.md](docs/gherkin_style_guide.md)** & **[gherkin_exemplars.md](docs/gherkin_exemplars.md)**: Gherkin format and exemplar references.
* **[exemplar_rule_mapping.md](docs/exemplar_rule_mapping.md)**: Maps sample rules to authoritative Gherkin rule IDs.
* **[traceability_schema.md](docs/traceability_schema.md)** & **[traceability_matrix.csv](docs/traceability_matrix.csv)**: COBOL ↔ Gherkin ↔ Policy ↔ Test mapping.
* **[policy_version_index.csv](docs/policy_version_index.csv)** & **[policy_gap_log.md](docs/policy_gap_log.md)**: Policy version control and open gaps.
* **[regression_baseline_cases.csv](docs/regression_baseline_cases.csv)**: Canonical + auto-derived test cases.
* **[coverage_report.md](docs/coverage_report.md)**: Rule coverage by module.
* **[implementation_plan.md](docs/implementation_plan.md)** & **[task.md](docs/task.md)**: Project management artifacts.
* **[policies/](docs/policies/)**: Policy and example source files used for citation work.

### 2. `gherkin_rules/` - Machine Readable Business Logic (Gherkin)
These files are the authoritative, SME-readable rule specifications in Gherkin (`.feature`). They are denormalized and intent-focused, avoiding COBOL control flow.
* **[esdrv212.feature](gherkin_rules/esdrv212.feature)**: Driver validation, exception handling, and routing rules.
* **[escal212.feature](gherkin_rules/escal212.feature)**: CY2021.2 calculation rules.
* **[esdrv212_wage.feature](gherkin_rules/esdrv212_wage.feature)**: Wage index lookup and overrides.
* **[ _template.feature](gherkin_rules/_template.feature)**: Standard scenario template.

### 3. `rules/` - Legacy YAML Artifacts (Deprecated)
These files are legacy outputs from earlier iterations and are retained only for migration reference. They are no longer the active DSL.
* **[escal212_rules.yaml](rules/escal212_rules.yaml)**: Legacy extraction of CY2021.2 calculations.
* **[esdrv212_rules.yaml](rules/esdrv212_rules.yaml)**: Legacy driver routing rules.
* **[historical_calc_rules.yaml](rules/historical_calc_rules.yaml)**: Legacy routing abstraction.
* **[reference_table_rules.yaml](rules/reference_table_rules.yaml)**: Legacy reference table rules.
* **[copybook_rules.yaml](rules/copybook_rules.yaml)**: Legacy copybook mappings.

### 4. `scripts/` - Validation & Tooling
* **[rule_validator.py](scripts/rule_validator.py)**: YAML schema validator for legacy artifacts.
