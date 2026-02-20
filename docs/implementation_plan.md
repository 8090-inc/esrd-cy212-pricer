# Implementation Plan: COBOL Pricer Reverse Engineering

## Goal Description
Reverse engineer the ESRD CY21.2 Mainframe Pricer COBOL codebase to create four key deliverables in three milestones (V1, V2, V3). **As explicitly requested, the final objective is to synthesize rules from EVERY single file in the repository (approx 34 files)**, covering the entire history of ESCAL components and reference data tables. The deliverables are:
1. Human-Readable Rule Book
2. Machine-Readable Rule Artifacts
3. System Architecture Documentation (UML/Sequence)
4. Rule to Manual Linkage (Source Code Provenance)

## Deliverables & Approach

### 1. Human-Readable Rule Book
- **Goal:** Identify, analyze, and normalize legacy rules/edits.
- **V1 Focus:** Identify rule boundaries in `ESDRV212` (Driver) and the initialization/validation setup in `ESCAL212` (Calculation).
- **Format:** Markdown document detailing:
  - **Rule Taxonomy:** Categorization of edits (e.g., Input Validation, Date Routing, Base Rate Calculation).
  - **Conditions/Actions:** The `IF/ELSE` conditions translated into natural language business rules.
  - **Call Graphs & Control Flow:** Visual text narratives of how control is passed (e.g., Driver -> Date Check -> Specific Year Calculator).
  - **Data Definitions:** Mapping of variables from interface copybooks (e.g., `BILLCPY`, `RTCCPY`).

### 2. Machine-Readable Rule Artifacts
- **Goal:** Model and export rules in a human-editable Domain Specific Language (DSL) with test harnesses and tooling.
- **V1 Focus:** Establish the YAML-based DSL format and tooling baseline.
- **Format & Tooling:**
  - **DSL:** YAML Rule Definition (`.yaml`). YAML is widely considered the most human-readable and easily editable data serialization standard, making it perfect for Business Analysts (SMEs) to read and modify without needing to learn programming syntax like Java/Drools.
  - **Artifacts:** `.yaml` files containing the extracted rules for V1.
  - **Test Harness:** A python script (`rule_validator.py`) using `PyYAML` to parse the YAML DSL files and validate basic structural syntax, ensuring the rules maintain valid compilation states.
  - **Discovery Environment:** Utilizing the local file system and Python to ensure repeatable reruns.

### 3. System Architecture Documentation
- **Goal:** UML Asciidraw diagrams and sequence diagrams representing the system.
- **V1 Focus:** The interaction between the macro components.
- **Format:** Markdown files utilizing Mermaid.js for embedding UML.
  - **Structural (Component Diagram):** Showing `DRIVER`, `CALCULATION MODULES`, and `COPYBOOKS` datasets.
  - **Behavioral (Sequence Diagram):** Showing the temporal flow from external invocation -> `ESDRV212` -> `ESCAL212` -> Response.

### 4. Rule to Manual Linkage (Traceability)
- **Goal:** Source code provenance and SME validation workflows.
- **V1 Focus:** Establishing the Traceability Matrix format tying the English rules to COBOL line numbers.
- **Format:** Markdown Table acting as the linkage map.
  - Columns: `Rule ID`, `Human Readable Description`, `File Name`, `Line Range`, `SME Review Status`.
  - **Workflow Definition:** Documenting the sampling strategy and review cycles necessary for baseline approval.

## Milestone Plan

### V1: Proof of Concept Slice
- **Scope:** Complete analysis of `ESDRV212` (Driver) and lines 1-1000 of `ESCAL212` (Initialization & Validation).
- Produce the 4 deliverables for this slice to establish formats and templates.
- **Verification:** USER review and approval of the formats, schema, and UML representations.

### V2: Expanded Slice
- **Scope:** Complete analysis of the remainder of `ESCAL212` (Core Calculations like Outlier, Age Factors, BMI, QIP).
- Expand the 4 deliverables using the V1 baselines.
- Update test harnesses and run regression validations against the growing YAML DSL rule set.

### V3: Complete Set (Every File Synthesized)
- **Scope:** Complete analysis and synthesis of rules from *every single file* remaining in the file system. This sweeping effort includes:
  - **Historical Calculation Modules (20 files):** `ESCAL056`, `ESCAL062`, `ESCAL070`, `ESCAL071`, `ESCAL080`, `ESCAL091`, `ESCAL100`, `ESCAL117`, `ESCAL122`, `ESCAL130`, `ESCAL140`, `ESCAL151`, `ESCAL160`, `ESCAL170`, `ESCAL171`, `ESCAL180`, `ESCAL191`, `ESCAL200`, `ESCAL202`.
  - **Data Definitions & Tables (11 files):** `BASECBSA`, `BASERATE`, `BILLCPY`, `BUNDCBSA`, `DSCNTRL`, `ESBUN210`, `ESCHI151`, `ESCOM151`, `ESWRT151`, `RTCCPY`, `WAGECPY`.
- Expand the 4 deliverables using the V1/V2 baselines to be completely exhaustive.
- Finalize all documentation representing the entire mainframe pricer subsystem.
- **Verification:** Comprehensive acceptance testing executing the python test harness against all gathered rules.

## User Review Required
- Please review the transition to using YAML (`.yaml`) as the Human-Editable DSL format, which generally offers superior readability for non-programmers compared to Drools.
