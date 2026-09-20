# Phase 4 — Build Grounded Review Dashboard

## Context Links

- [Plan](./plan.md)
- [Detailed Review Engine](./phase-03-detailed-test-case-review.md)
- [Brainstorm Summary](./reports/brainstorm-summary.md)
- `lib/features/review/review_bundle.dart`
- `lib/core/services/test_case_review_engine.dart`
- `lib/core/services/coverage_stats.dart`
- `lib/core/services/cross_check_engine.dart`
- `lib/core/services/hard_checks.dart`
- `lib/core/services/ai_service.dart` (`VerifiedFinding`)

## Overview

- Priority: High
- Status: Completed
- Goal: make row-level test-case review primary while reusing enhanced visual language for grounded aggregate data.

## Data Contract

`ReviewScreen` continues receiving `ReviewBundle` through constructor. Child widgets receive narrow typed fields; no duplicate aggregate result object.

```text
ReviewScreen(bundle)
├── DetailedTestCasesTab(records, caseReviews)          ← default
├── OverviewTab(stats, crossCheck)
├── ReconciliationTab(metricsComparison)
├── IntegrityTab(checks, duplicates, environment, timeline, integrity)
├── VerifiedFindingsTab(verifiedFindings)
└── FullReportTab(markdown)
```

Use `DefaultTabController` or local `TabController`. Do not add Riverpod result storage solely for tab selection. Preserve `_exportExcel`, `_exportPdf`, and local `isExporting` state.

## Detailed Test Cases UX

- Default tab on screen entry.
- Search: canonical/raw ID, description, sheet/module.
- Filters: module, review severity, execution status, issue code.
- Sort: highest severity, ID, module, execution status.
- Row summary: ID, module, shortened scenario, execution status, review label, issue count.
- Row activation opens accessible detail panel/dialog with original fields and grouped issues.
- Each issue shows affected field, severity text/icon, deterministic reason, evidence, correction guidance.
- Empty issue list means “No deterministic issue detected,” not “Test case logically correct.”
- Large suites use lazy rows; filter operation stays local over immutable `caseReviews`.

## Honest Semantics

- Per-case quality label derives from deterministic issue severity, not AI score.
- Coverage gauge displays `CoverageStats.coverage`, not AI score.
- Reconciliation table displays `ThreeWayMetricsComparison`, not RTM.
- Integrity badges display existing severity/status only.
- Verified tab displays `VerifiedFinding` claim, module, quote, verification state, explanation.
- Empty `crossCheck` produces explicit unavailable state; never zeros that imply clean results.
- Empty verified findings says no verified finding available; never “all clear.”

## Proposed Presentation Files

Create/refactor only files that earn a caller:

- `widgets/detailed_test_cases_tab.dart`
- `widgets/test_case_detail_dialog.dart`
- `widgets/overview_tab.dart`
- `widgets/reconciliation_tab.dart`
- `widgets/integrity_tab.dart`
- `widgets/verified_findings_tab.dart`
- `widgets/full_report_tab.dart`
- `widgets/metric_card.dart`
- `widgets/coverage_gauge.dart`

Source visual files are references, not fixed contracts:

- Refactor/rename `scorecard_tab.dart` → `overview_tab.dart`.
- Refactor/rename `rtm_tab.dart` → `reconciliation_tab.dart`.
- Refactor/rename `flaws_tab.dart` → `integrity_tab.dart`.
- Refactor/rename `score_gauge.dart` → `coverage_gauge.dart`.
- Replace `rtm_detail_dialog.dart` with `test_case_detail_dialog.dart`.
- Remove `suggestion_dialog.dart` unless converted to a grounded, called finding dialog.

## Interaction and Layout

- Scrollable desktop `TabBar`; keyboard-accessible labels and tooltips.
- Consistent spacing/color from app `Theme`; no hardcoded unrelated brand palette.
- Cards provide visible hover/focus/pressed states.
- Tables scroll horizontally instead of clipping.
- Detailed and finding lists use lazy builders.
- Severity never relies on color alone; include text/icon.
- Markdown remains selectable.
- Export actions remain visible and disabled only while export runs.

## Implementation Steps

1. Inventory source widget visual patterns and imports.
2. Define six grounded tabs above; select Detailed Test Cases initially.
3. Build detailed table, filters, sort, and detail panel from `caseReviews`.
4. Build overview metrics from `CoverageStats` and optional `CrossCheckResult`.
5. Build three-source table from `ThreeWayMetricsComparison`.
6. Aggregate integrity sections without recomputing findings.
7. Render verified findings with exact source quote.
8. Preserve full Markdown tab and exporter callbacks.
9. Replace misleading Scorecard/RTM/Suggestion naming.
10. Delete source result controller and model dependencies once last caller is migrated.
11. Verify all visible counts against `ReviewBundle` fields.

## Related Files

- Modify: `lib/features/review/presentation/review_screen.dart`
- Create/refactor: selected files under `lib/features/review/presentation/widgets/`
- Delete after migration:
  - `lib/features/review/presentation/review_controller.dart`
  - `lib/core/models/anti_pattern.dart`
  - `lib/core/models/metrics.dart`
  - `lib/core/models/review_audit_result.dart`
  - `lib/core/models/rtm_item.dart`
  - `lib/core/models/scorecard.dart`
  - `lib/core/models/test_case_suggestion.dart`
  - any source widget without a grounded caller

## Todo

- [ ] Make Detailed Test Cases default tab
- [ ] Add row search, filters, sorting, and detail panel
- [ ] Build remaining five grounded tabs
- [ ] Rebind visual components to target types
- [ ] Preserve export and Markdown behavior
- [ ] Handle null/empty states honestly
- [ ] Add accessible and responsive table/list behavior
- [ ] Remove duplicate source result contract
- [ ] Remove orphan widgets and imports

## Success Criteria

- Detailed tab row count equals `bundle.records.length` and `bundle.caseReviews.length`.
- Selecting a row exposes original fields plus only that row’s deterministic issues.
- Filters never alter source results or aggregate counts.
- Every number traces to a `ReviewBundle` field.
- No UI import references source result models.
- No tab is labeled Scorecard or RTM without corresponding deterministic contract.
- Tabs work with empty findings and null `crossCheck`.
- Existing exporter actions remain available.
- Dashboard remains usable at standard laptop width and narrow resized window.

## Risk Assessment

- Hundreds of rows plus dialogs can cause rebuild cost. Keep immutable lists, lazy rows, and local filter state.
- Source visual widgets may hide calculations inside `build()`. Rewrite rather than preserve those calculations.
- Nested scroll views can produce unbounded-height errors. Give each tab one primary scroll owner.
- “No deterministic issue” can be mistaken for semantic correctness. Use explicit bounded wording.

## Security Considerations

- Treat test content, finding strings, and Markdown as untrusted display data.
- No clickable external links without existing safe-launch policy.
- Never expose API key or raw registration PII in dashboard details.

## Next Step

Remove residual merge weight, run full verification, and create merge commit.
