# Phase 3: Migrate Outputs and Prove No Fabrication

## Context Links

- [Plan](./plan.md)
- [Phase 1](./phase-01-evidence-contract.md)
- [Phase 2](./phase-02-grounded-rules.md)
- `lib/core/services/excel_export_service.dart:14-594`
- `lib/features/review/presentation/widgets/overview_tab.dart:20-133`
- `lib/features/review/presentation/widgets/reconciliation_tab.dart:4-145`
- `lib/features/review/presentation/widgets/integrity_tab.dart:1-120`
- `test/phase3_export_test.dart:29-166`

## Overview

- Priority: P1
- Status: Pending
- Effort: 2.5h
- Purpose: make UI, Markdown/PDF, and Excel honor the same availability/evidence contract; lock behavior with false-positive regressions.

## Related Code Files

### Modify

- `lib/core/services/excel_export_service.dart`
- `lib/core/services/cross_check_models.dart`
- `lib/features/review/review_bundle.dart`
- `lib/features/review/presentation/review_screen.dart`
- `lib/features/review/presentation/widgets/overview_tab.dart`
- `lib/features/review/presentation/widgets/reconciliation_tab.dart`
- `lib/features/review/presentation/widgets/integrity_tab.dart`
- `lib/features/upload/presentation/upload_controller.dart`
- `test/phase3_export_test.dart`
- `test/cross_check_engine_test.dart`
- `test/extraction_golden_test.dart` — remove both absolute-path early-return Report5 tests.
- `test/widget_test.dart` — migrate every direct `ReviewBundle` constructor at existing widget fixtures.

### Create/Extend

- `lib/core/services/review_report_composer.dart` — pure Markdown/recommendation composer; controller contains no report prose.
- `test/excel_service_test.dart`
- `test/review_report_composer_test.dart`
- `test/review_projection_test.dart`
- `test/upload_controller_review_test.dart` — exercise the production controller→bundle→composer wiring with complete, partial, and unsupported sources.
- Use generated minimal workbooks/row snapshots; add a binary fixture only if generated encode→decode cannot reproduce a package edge.

## Implementation Steps

1. Capture the current dirty-worktree baseline for every affected file before edits: hash plus user-owned diff/hunks. Implementation commits/staging include task-owned hunks only.
2. Add required structured `RegistrationContext` and per-source `ExtractionAvailability` to `ReviewBundle`; migrate all constructors/callers, including both fixtures in `test/widget_test.dart`. `RegistrationContext` currently supplies only topic/description: project code, frontend, database, and tools stay omitted/`Chưa xác định` until a real typed extractor exists. Do not infer them from `toPromptBlock()`.
3. Build one canonical presentation projection in `cross_check_models.dart`:
   - formatted value/`N/A`/lower-bound labels;
   - percentages and differences from the shared truth table;
   - status counts from explicit `RuleOutcome`;
   - checked, partial, unsupported, and finding summaries.
   UI, Markdown/PDF, and Excel consume this projection and may not recompute semantics.
4. Extract `ReviewReportComposer` from `UploadController`:
   - pure input: bundle facts, canonical projection, checked findings;
   - source-derived text passes structured Markdown escaping;
   - recommendations come only from checked findings;
   - unsupported/not-applicable never becomes clean verdict/remediation.
5. Update Overview:
   - complete actual record counts remain visible;
   - partial observations display `Đã đọc ít nhất N` and never appear as a total;
   - declared metrics show value + source only when available, otherwise `Chưa khả dụng` with curated reason;
   - no missing value becomes zero/discrepancy.
6. Update Reconciliation:
   - render canonical projection cells only;
   - difference/status/percentage are `N/A` unless derivation contract succeeds;
   - “Khớp” only for `checkedClean`.
7. Update Integrity:
   - cross-check findings display safe source locators/typed evidence;
   - unsupported/not-applicable/partial outcomes are informational and excluded from HIGH/CRITICAL finding badges.
8. Rewrite Excel output:
   - use unique extracted registration topic; omit unknown optional administrative rows or show `Chưa xác định`;
   - consume canonical projection; no 320/338/267/53/71 fallback or Report5/M01-M10 labels;
   - keep all source-controlled strings as literal `TextCellValue`; forbid `FormulaCellValue`, formula strings, external links, or DDE in report exports;
   - escaped safe evidence only; recommendation rows derive from checked findings.
9. Keep PDF grounded by rendering only `ReviewReportComposer` output; no parallel project metadata/recommendation path.
10. Replace tests pinning SU26SE017/Report5 with input-driven assertions. Delete both machine-local early-return tests in `test/extraction_golden_test.dart`. Test production composer and controller wiring instead of reconstructing expected Markdown in test code.
11. Add contract and behavior tests:
   - complete vs partial vs unsupported source matrix;
   - empty findings with unsupported rule never yields clean;
   - missing metric, declared zero, 0/0, one-sided operands, conflicting candidates;
   - prompt truncation/skipped candidate sheet never produces authoritative total;
   - description-column false positive, normalized valid target, true missing target, hostile/external formula;
   - formula total unavailable; typed date/location survives encode→decode;
   - developer-authored generic AI template/report contains no Report5 seeds, while identical strings from real user input remain unmodified;
   - synthetic non-Report5 topic/metrics appear in UI/Markdown/Excel; absent project metadata renders unavailable/omitted, never Report5 defaults;
   - production `UploadController` path preserves complete/partial/unsupported states into `ReviewBundle` and composer;
   - UI/Markdown/Excel projection parity for values/statuses/percentages;
   - Markdown control/link/image payload is escaped;
   - Excel payload beginning `=`, `+`, `-`, `@` remains literal text: decoded cell is `TextCellValue` and generated worksheet XML contains no `<f>` for that cell;
   - secret/PII canary never appears in Markdown/PDF input/Excel;
   - neither absolute-path Report5 golden nor any early-return pass remains.
12. Verification sequence:
   - `dart format` only changed Dart files.
   - focused tests: extraction, cross-check, AI verifier, composer, projection, export.
   - `flutter test`.
   - `flutter analyze`.
   - Launch Windows app, upload non-Report5 complete and partial fixtures, verify Overview/Reconciliation/Integrity/Full report.
   - Export Excel/PDF and inspect values, unavailable states, escaped evidence, and absence of Report5 claims.
   - Repeat screenshot scenario; feature names must not become sheet targets. Exercise one explicit missing target.
13. Before completion, compare current diff to baseline: no user-owned hunk changed, staged, or included in rollback instructions.

## Todo List

- [ ] Preserve dirty-worktree baseline and isolate task-owned hunks.
- [ ] Propagate required registration and source availability through every `ReviewBundle` constructor.
- [ ] Make canonical projection the only UI/Markdown/PDF/Excel semantic source.
- [ ] Extract production report composition and test controller wiring.
- [ ] Remove Excel fallbacks and enforce literal-text sinks.
- [ ] Replace both absolute-path golden blocks and Report5-pinning export tests.
- [ ] Render partial/unsupported/evidence states consistently.
- [ ] Add false-positive, lifecycle-scope, partial-input, injection, parity, and non-fabrication regressions.
- [ ] Run focused, full, analyzer, Windows UI, and export verification.

## Success Criteria

- Non-Report5 input contains no Report5 project facts in UI, AI prompt/result seed, Markdown, PDF, or Excel.
- Complete, partial, and unsupported inputs produce distinct outcomes in every surface.
- UI and exports agree on every metric, percentage, status, evidence locator, and unavailable state.
- Screenshot reproduction yields zero false `broken-sheet-link` findings.
- A deliberately missing explicit internal sheet target produces one actionable finding with safe source address.
- Tests run from repository/generated data, exercise the production composer/projection, and cannot pass by returning early.
- Hostile evidence remains escaped/literal and secret/PII canaries reach no output sink.
- Full verification passes without modifying, staging, or reverting pre-existing user work.

## Risks

- Existing exporter/UI tests pin wrong behavior; delete incidental assertions rather than rewording them around another implementation detail.
- Current user edits touch exporter/UI/controller files. Re-read and patch surgically against the recorded baseline.
- `Chưa xác định` can clutter reports. Omit optional metadata; show explicit unavailable only for requested comparisons.
- If presentation parity reveals an unmodeled state, extend canonical projection; never add output-local fallback logic.

## Security Considerations

- All evidence is rule-specific typed data or `SafeEvidenceExcerpt`; registration topic remains sanitized and uniqueness-checked.
- `TextCellValue` is the only sink for source-controlled Excel content; Markdown uses one escaping boundary before PDF rendering.
- Public output never includes raw formulas, control/bidi structure, exception text, paths, full rows, credentials, or student PII.

## Rollback

Revert only task-owned commits/hunks identified against the captured baseline. Never `git reset`, blanket checkout, or restore a file containing pre-existing user edits. Do not restore sample defaults; if a rule cannot be evidence-safe, leave it unsupported.
