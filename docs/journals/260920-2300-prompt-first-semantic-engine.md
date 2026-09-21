# Journal: Prompt-First Semantic Review Engine Implementation

**Date:** 2026-09-21  
**Plan:** `plans/260920-2300-prompt-first-semantic-engine/plan.md`  
**Status:** COMPLETED (All 89 tests passing)

## 1. Objectives & Decisions
- **Zero-Regex Semantics in Dart:** Completely removed keyword regexes for database, environment, infrastructure, and use cases. Dart code now strictly handles mechanical tasks: raw ingestion, verbatim quote verification, 3-way counting, and deterministic consistency checks.
- **Full AI Document Understanding:**
  - **Pass 1 (Generator):** Prompt instructs LLM to ingest full text of 3 documents (SRS, Test Cases, Registration) and extract both `project_info` (topic, description, tech_stack, features) and 5-8 hypotheses across 6 universal testing axes (Tech Mismatch, Feature Omission, RBAC, Copy-Paste, Logic Violation, Wording).
  - **Pass 2 (Verifier):** Independent binary validation requiring verbatim exact quotes (`exact_quote`) for every verified claim.
  - **Pass 3 (Gatekeeper):** Verifies exact presence in source texts using whitespace-normalized containment checks (`containsLoose`), blocking 100% of hallucinated quotes.
- **Reporting & UI Synchronization:**
  - `ReviewReportComposer` prioritizes AI `project_info` over fallback "Chưa xác định", and displays findings by 6 axes.
  - `ExcelExportService` and `PdfExportService` consume `projectInfo` and 6-axis verified findings.
  - `OverviewTab` displays the Project Metadata Card (Topic, Description, Tech Stack chips).
  - `VerifiedFindingsTab` displays axis badges with color coding.

## 2. Verification Evidence
- `flutter test`: 89/89 tests passing (0 failures).
- `dart analyze`: 0 errors.
- Unit tests added for 6-axis hypothesis parsing, Gatekeeper hallucination blocking, and report composition.
