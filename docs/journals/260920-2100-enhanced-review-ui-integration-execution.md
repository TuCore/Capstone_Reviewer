# Journal: Enhanced Review UI Integration with Deterministic Engine

- **Date:** 2026-09-20
- **Branch:** `integration/enhanced-deterministic-ui`
- **Source:** `origin/feature/enhanced-review-system`
- **Target:** `feature/deterministic-verifier`
- **Status:** Complete & Verified

## Problem & Objectives

Integrate enhanced UI/UX components from `origin/feature/enhanced-review-system` into `feature/deterministic-verifier` without regressing the deterministic verifier core (`CrossCheckEngine`, `FileGate`, `QuoteGuard`, cancellation, and memory-only API key hygiene).

Address teacher feedback:
1. Require 3 documents: Registration / Proposal, SRS, and Excel Test Cases.
2. Provide row-level detailed review for each extracted test case.
3. Make Detailed Test Cases the primary/default review tab.
4. Keep zero hallucination: discard ungrounded AI-generated Scorecard/RTM and plaintext key storage.

## Key Changes Implemented

1. **Deterministic Row-Level Review Engine (`TestCaseReviewEngine`):**
   - Implemented `lib/core/services/test_case_review_engine.dart` with immutable `TestCaseIssue` and `TestCaseReview` types.
   - Enforced strict 1-to-1 mapping preserving source order and original `TestCaseRecord`.
   - Deterministic rules for required fields (missing ID, description, steps, expected), wording quality (`scoreWording` integration), attached hard checks and duplicate ID / status conflicts, and execution metadata consistency.
   - Grounded verdict label: "Không phát hiện lỗi theo rule deterministic" for clean records.

2. **Three-Document Upload Flow:**
   - Updated `UploadState.canAnalyze` and `UploadController.analyzeFiles` to mandate `registrationPath`, `srsPath`, `excelPath`, and valid API key.
   - Reordered drop zone cards left-to-right: **Registration → SRS → Excel**.
   - Added missing inputs guidance text when review button is locked.

3. **Grounded 6-Tab Dashboard (`ReviewScreen`):**
   - Tab 0 (Default): `DetailedTestCasesTab` with search, module/severity/status filters, sorting, summary stat chips, lazy list, and `TestCaseDetailDialog`.
   - Tab 1: `OverviewTab` with animated `CoverageGauge`, metric cards, discrepancy alerts, and module breakdown.
   - Tab 2: `ReconciliationTab` with 3-way comparison table (Word SRS vs Excel vs Actual), environment mismatches, and timeline conflicts.
   - Tab 3: `IntegrityTab` with duplicate IDs, status conflicts, cross-check integrity findings, and hard checks.
   - Tab 4: `VerifiedFindingsTab` with 2-pass binary LLM verifier findings and verbatim quotes.
   - Tab 5: `FullReportTab` with markdown report reader.

4. **Excel Export Enhancement:**
   - Extended `ExcelExportService.export` and `buildWorkbook` with detailed review columns in `Test_cases` sheet: quality verdict, issue count, issue codes, affected fields, and detailed corrections.

5. **Pruned Dead Code:**
   - Removed ungrounded models: `ReviewAuditResult`, `Scorecard`, `RTMItem`, `ReviewMetrics`, `AntiPattern`, `TestCaseSuggestion`.
   - Removed ungrounded widgets: `scorecard_tab.dart`, `rtm_tab.dart`, `flaws_tab.dart`, `rtm_detail_dialog.dart`, `suggestion_dialog.dart`, `score_gauge.dart`.
   - Removed unused `review_controller.dart`, `local_storage_service.dart`, and `.vscode/settings.json`.

## Verification Evidence

- `flutter analyze`: 0 issues found.
- `flutter test`: 63/63 tests passing (unit tests, extraction goldens, export tests, widget tests).
- `flutter build windows`: Release build successful (`build\windows\x64\runner\Release\capstone_reviewer.exe`).
- Subagent code review: 100% PASS on deterministic engine preservation, layout constraints, clean cutover, 1-to-1 invariant, and 3-document contract.

## Advisory Blockers Resolved

1. **Status Canonicalization & Verification:**
   - Standardized `normalizeStatus()` in `hard_checks.dart` to map `skipped`/`skip`/`untested`/`pending`/`blocked` to `'Untested'`, while keeping `'PASSED'`, `'FAILED'`, `'Not Run'`, `'N/A'`.
   - Added `isKnownStatus()` and exposed static forwarding on `TestCaseReviewEngine`.
   - Normalized case-insensitivity on `'FAILED'` / `'Failed'` check for bug note requirement.

2. **Hard-Check Complete Attachment:**
   - Extended `TestCaseReviewEngine` to attach all 5 hard-check finding codes: `sheet-type` (`unit-test-type`), `duplicate` (`exact-duplicate`), `naming` (`naming-inconsistent`), `empty` (`hard-check-empty`), and `wording` (`hard-check-wording`).

3. **UI Null-Semantics & Bounded Claims:**
   - Replaced green verified badge in `TestCaseDetailDialog` with neutral icon and bounded disclaimer: `"Không phát hiện vấn đề theo các rule deterministic đã chạy; không kết luận testcase đúng."`
   - In `OverviewTab` and `IntegrityTab`, added honest unavailable notices when `crossCheck == null` instead of falsely reporting 0 fails or clean scan. Fallback to `stats` data for Excel counts.
   - Added issue code filter (`_selectedIssueCode`) and horizontal scroll bar in `DetailedTestCasesTab`.
   - Kept export buttons visible and disabled with progress indicator in `ReviewScreen` during export.

4. **Automated Verification:**
   - All 67 automated tests passed (`flutter test`).
   - `flutter analyze`: 0 issues.
   - `flutter build windows`: binary built successfully at `build\windows\x64\runner\Release\capstone_reviewer.exe`.
