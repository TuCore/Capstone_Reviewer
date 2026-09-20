---
title: "Enhanced review UI integration brainstorm"
type: report
status: final
created: 2026-09-20
sourceBranch: origin/feature/enhanced-review-system
sourceCommit: 5ffd1444898196d008db1073588782c479a70b49
targetBranch: feature/deterministic-verifier
targetCommit: 360e23ed957e8b36c8b29151317212d66cf12929
mergeBase: 2deda3bad9387df25254c1427ca4b203bf2296a1
---

# Enhanced Review UI Integration Brainstorm

## Summary

Merge ancestry from `feature/enhanced-review-system`, preserve deterministic engine, add grounded review for every extracted test case, and selectively rebuild enhanced UI against `ReviewBundle`. Require registration, SRS, Excel, and valid API key before review. Place registration first/leftmost in upload UI. Reject source AI-generated metrics, plaintext key persistence, duplicate result models, and machine-specific editor config.

## Problem

Direct merge produces six content conflicts and a deeper contract conflict:

- Target computes counts, coverage, integrity findings, and three-way comparisons in Dart.
- Source asks AI to generate scorecard, RTM, metrics, anti-patterns, and suggestions as JSON.
- Source dashboard depends on its AI-owned `ReviewAuditResult` contract.
- Accepting source wholesale would regress determinism, quote grounding, cancellation, key hygiene, exporters, and tests.

## Evidence

- Branch divergence: target 7 unique commits; source 2 unique commits.
- `feature/simplified-report` contains the deterministic work before the latest two small UI/extraction changes; it does not contain a separate detailed reviewer.
- Current implementation emphasizes aggregate coverage, three-way totals, duplicates, and module-level findings.
- `TestCaseRecord` already retains ID, description, precondition, steps, test data, expected result, status, date, note, and bug fields; enough for grounded row-level review.
- Git conflicts:
  - `lib/core/services/ai_service.dart`
  - `lib/core/services/excel_export_service.dart`
  - `lib/core/services/pdf_export_service.dart`
  - `lib/features/review/presentation/review_screen.dart`
  - `lib/features/upload/presentation/upload_controller.dart`
  - `lib/features/upload/presentation/upload_screen.dart`
- Source adds 22 files but no tests.
- Source persists API key through `LocalStorageService` without secure storage.
- Source adds `.vscode/settings.json` with absolute path `D:/PRM393/Capstone_Reviewer/windows`.
- Source Scorecard/RTM cannot be truthfully populated from current `ReviewBundle`; fake mapping would mislabel aggregate module comparisons as requirement traceability.
- [INFERENCE] Teacher feedback “review test case chi tiết” most safely means one inspectable review result per test-case row, not only aggregate metrics. Exact requirement-level RTM intent remains unconfirmed.

## Evaluated Approaches

| Approach | Benefits | Costs/Risks | Decision |
|---|---|---|---|
| Merge source wholesale | Fastest mechanical resolution | Replaces deterministic truth with ungrounded AI JSON; key persistence; duplicate contracts | Rejected |
| Keep target, skip source | Lowest risk | Loses useful dashboard and visual work | Rejected |
| Preserve target engine, selectively integrate source UI | Real metrics plus better UX; one data source | Requires manual UI rebinding and semantic renaming | Selected |
| Add real Scorecard and RTM engine now | Full source dashboard semantics | New scoring and traceability subsystem; outside merge scope | Deferred |

## Approved Design

### Source of truth

`ReviewBundle` remains sole aggregate result contract:

- `CoverageStats`
- `List<HardCheckFinding>`
- `List<TestCaseRecord>`
- `List<TestCaseReview>`
- `CrossCheckResult`
- `List<VerifiedFinding>`
- grounded Markdown report

No UI-side metric recomputation. No AI-owned numeric truth.

### Required inputs and layout

Review requires all four:

1. Registration/proposal document
2. SRS document
3. Excel test cases
4. Valid provider-specific API key

Upload cards appear in that exact left-to-right order. Registration still passes through `FileGate`, PII minimization, deterministic cross-check, and verifier source list.

### Detailed test-case reviewer

Every extracted `TestCaseRecord` produces exactly one `TestCaseReview` containing:

- Stable identity: sheet/module, raw ID, canonical ID.
- Original fields: description, precondition, steps, test data, expected result, execution status, date, note, bug.
- Field-level issues: rule code, affected field, severity, message, source evidence, correction guidance.
- Overall quality label derived from highest deterministic issue severity; no opaque numeric score.
- Attached duplicate/status-conflict findings from existing engines.

Initial deterministic rules cover completeness, testability/wording, duplicate/inconsistent identity, execution metadata consistency, and known hard checks. They must not claim business-logic correctness that code cannot prove. AI findings remain separately labeled and visible only after verifier/gatekeeper approval.

### Dashboard information architecture

1. **Detailed Test Cases** — default tab; searchable/filterable row list and detail panel.
2. **Overview** — real coverage, actual Pass/Fail/Untested, discrepancy alerts.
3. **Three-way reconciliation** — Word vs Excel declaration vs actual records.
4. **Integrity findings** — duplicate IDs, status conflicts, hard checks, environment/timeline conflicts.
5. **Verified findings** — only gatekeeper-approved qualitative findings with source quote.
6. **Full report** — existing selectable Markdown and existing PDF/Excel actions.

Source Scorecard and RTM labels are not retained because current engine does not produce those contracts. Visual patterns may be reused after semantic rebinding.

## File Decisions

| File/surface | Decision |
|---|---|
| `ai_service.dart` | Keep target implementation |
| `test_case_review_engine.dart` | Create deterministic row-level reviewer and typed issue model |
| `review_bundle.dart` | Add `caseReviews`; keep sole aggregate contract |
| `excel_export_service.dart` | Keep target workbook; extend Test Cases sheet with review columns |
| `pdf_export_service.dart` | Keep target grounded report exporter |
| `upload_controller.dart` | Keep target pipeline; make registration mandatory |
| `upload_screen.dart` | Manual hybrid; order Registration → SRS → Excel |
| `review_screen.dart` | Manual hybrid; detailed reviewer first, grounded aggregate tabs after |
| Source models (`ReviewAuditResult`, Scorecard, RTM, metrics, anti-pattern, suggestions) | Remove after UI migration |
| `review_controller.dart` | Remove unless reduced to presentation-only state with no duplicate result storage; local widget state preferred |
| Source review widgets | Keep only after rebinding and honest renaming |
| `local_storage_service.dart` | Remove |
| `.vscode/settings.json` | Remove |

## Risks

- “Detailed” may mean requirement-level RTM rather than row-level quality review → plan records this uncertainty; validate with teacher before expanding traceability scope.
- False-positive field rules → distinguish required, recommended, and informational fields; avoid penalizing optional fields blindly.
- UI count drift from exports → widgets and Excel consume the same `List<TestCaseReview>`.
- Misleading RTM/Scorecard labels → remove or rename; no inferred traceability/scoring.
- Hundreds of test cases stutter → paginated/lazy list and client-side filters over immutable results.
- Merge remains unresolved too long → isolated integration branch; abortable until verification.
- Registration requirement breaks old two-file flow → explicit disabled-state copy and regression coverage.

## Success Metrics

- Upload order is Registration → SRS → Excel.
- Missing any required input keeps Review disabled and explains requirement.
- Detailed tab contains exactly one row per extracted test case.
- Each issue names affected field, deterministic rule, severity, evidence, and correction.
- Dashboard and Excel detailed-review values match.
- Aggregate dashboard numbers equal `ReviewBundle` and exported files.
- No source AI-generated metrics reach UI or exporters.
- API key never written to disk or included in errors.
- Existing deterministic tests pass.
- `flutter analyze` clean.
- Windows smoke flow succeeds: select three files, run review, inspect six tabs, open a test-case detail, filter issues, export PDF and Excel.

## Next Step

Execute implementation plan in parent directory. No implementation performed during brainstorm.