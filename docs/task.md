# COBOL Codebase Reverse Engineering Plan

## Milestones

### V1: Initial Slice (Proof of Concept)
- [x] Define the exact file scope for V1 (`ESDRV212` and first half of `ESCAL212`).
- [/] Create Human-Readable Rule Book (Taxonomy, Conditions, Call Graphs).
- [x] Create Machine-Readable Rule Schema (JSON Schema).
- [x] Extract V1 Rules into JSON format.
- [x] Create Python Import Test Harness (`rule_validator.py`) to baseline the discovery environment.
- [x] Create System Architecture Documentation (UML Sequence and Component diagrams using Mermaid).
- [x] Create Rule to Manual Linkage (Traceability Matrix with SME workflow narrative).
- [x] Run acceptance testing / review with USER.

### V2: Expanded Slice
- [x] Expand the slice to cover the core calculation logic in `ESCAL212`.
- [x] Update Human-Readable Rule Book with complex calculations.
- [x] Extract V2 Rules into YAML format.
- [x] Run Python Test Harness against V2 Rules.
- [x] Update System Architecture Documentation.
- [x] Update Rule to Manual Linkage.
- [x] Run acceptance testing / review with USER.

### V3: Complete Set (Every File Synthesized)
- [x] Extract data definitions and validations from Copybooks (`BILLCPY`, `RTCCPY`, `WAGECPY`).
- [x] Extract rules from Reference Tables (`ESBUN210`, `ESCHI151`, `ESCOM151`, `ESWRT151`, `BASECBSA`, `BASERATE`, `BUNDCBSA`, `DSCNTRL`).
- [x] Synthesize rules from Historical Calculation Modules (`ESCAL056` -> `ESCAL202`).
- [x] Exhaustively update Human-Readable Rule Book.
- [x] Exhaustively update YAML DSL configurations.
- [x] Run Python Test Harness against final full rule set.
- [x] Update Traceability Matrix and Architecture for complete set.
- [x] Run acceptance testing / review with USER.
