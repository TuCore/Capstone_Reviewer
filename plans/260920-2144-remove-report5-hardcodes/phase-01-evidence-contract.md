# Phase 1: Preserve Workbook Evidence and Availability

## Context Links

- [Plan](./plan.md)
- `lib/core/services/excel_service.dart:118-145`
- `lib/core/extraction/extraction_result.dart:3-27`
- `lib/core/extraction/test_case_schema.dart:1-56,190-252`
- `lib/core/extraction/sheet_classifier.dart:20-110`
- `lib/core/services/cross_check_engine.dart:20-120`
- Official `excel` 4.x contract: `Data` exposes row/column indices; sealed `CellValue` subtypes expose typed values; `FormulaCellValue` exposes formula text only, not a cached/evaluated result.

## Overview

- Priority: P1
- Status: Pending
- Effort: 2.5h
- Purpose: stop discarding source coordinates and cell semantics before rules run; model unavailable data explicitly.

## Requirements

### Functional

- Preserve sheet name, original 1-based row, 0-based column, display text, cell kind, typed date, and formula text.
- Split complete deterministic records from the prompt-budget subset. Prompt truncation must never delete records used for whole-workbook counts.
- Model each source as `complete`, `partial`, or `unsupported`, with a curated public reason code. Candidate test sheets skipped, truncated, or not fully classified make workbook totals partial.
- Word/PDF/DOCX extraction must report empty/image-only input and truncation instead of passing empty text as valid.
- Declared and computed metrics may be unavailable or partial. Only complete counts may be compared or called actual totals.

### Non-Functional

- No universal parser, formula evaluator, dynamic reflection, speculative template profiles, or second raw workbook representation.
- Clean cutover from `rawSheets`; migrate all callers rather than retain aliases.
- Immutable models; one full deterministic record list plus a bounded prompt projection, not two copied workbooks.

## Architecture

Create two focused model files:

1. `lib/core/extraction/workbook_snapshot.dart`
   - `WorkbookSnapshot`: normalized sheet lookup, ordered sheets, completeness, excluded candidate sheets/rows.
   - `WorkbookRow`: original Excel row number and cells.
   - `WorkbookCell`: original row/column/address, decoded value kind, display text, optional typed date/formula. Exact coordinates come from `Data`, never compacted list indexes.
   - Derived text-row access for classifier/record mapping without losing coordinates; raw-sheet evidence resolves header/value from the snapshot.
2. `lib/core/services/cross_check_models.dart`
   - `ExtractionAvailability`: complete/partial/unsupported plus closed diagnostic code and curated public message.
   - `SourceEvidence`: exact locator plus rule-specific typed/header/value data; arbitrary raw snippets/formulas prohibited.
   - `SafeEvidenceExcerpt`: escaped, control-character stripped, credential/PII-redacted, length-capped text for the few rules needing excerpts.
   - `MetricValue<T>`: available, partial/lower-bound, or unavailable with evidence.
   - `RuleOutcome<T>`: checked-clean, checked-with-findings, not-applicable, or unsupported. No detached diagnostic list.
   - `IntegrityFinding.evidence`: required for cross-check findings sourced from raw sheets.
   - `CrossCheckResult.ruleOutcomes`: authoritative keyed collection consumed by projection/UI/export; unsupported outcomes cannot vanish behind empty finding lists.
   - Canonical derivation helpers: comparisons require two available operands; percentage requires numerator, denominator, and denominator > 0; 0/0 is unavailable.
   - **Boundary with `hard_checks.dart`**: `RuleOutcome`, `CrossCheckResult.ruleOutcomes`, và `SourceEvidence` chỉ áp dụng cho findings do `CrossCheckEngine` sinh (raw sheet integrity, duplicate ID, metric, env, timeline). `HardCheckFinding` từ `lib/core/services/hard_checks.dart` (record-level syntax, wording, empty, sheet-type) giữ nguyên contract hiện tại, không bị suppress và không bịa exact-cell evidence.

`ExtractionResult.rawSheets` becomes `ExtractionResult.workbook`; its `records` remain the complete deterministic set while only prompt text is budget-truncated. Document extraction results receive the same availability contract. `CrossCheckEngine.run` consumes source availability and the snapshot. `TestCaseRecord` receives its original source row.

## Related Code Files

### Create

- `lib/core/extraction/workbook_snapshot.dart` — typed workbook evidence and completeness.
- `lib/core/services/cross_check_models.dart` — source/rule/metric availability contracts.
- `test/excel_service_test.dart` — decoded date/formula/coordinate/completeness behavior.

### Modify

- `lib/core/services/excel_service.dart` — one-pass typed cell normalization; full records separated from prompt projection.
- `lib/core/services/document_service.dart` — available/partial/unsupported document extraction.
- `lib/core/extraction/extraction_result.dart` — expose snapshot and source availability.
- `lib/core/extraction/test_case_schema.dart` — source row and reusable header-column lookup.
- `lib/core/extraction/sheet_classifier.dart` — consume derived text rows and identify skipped candidate test sheets.
- `lib/core/services/cross_check_engine.dart` — adopt metric/evidence/outcome types.
- `lib/features/review/review_bundle.dart` — carry per-source extraction availability.
- `lib/features/upload/presentation/upload_controller.dart` — pass workbook/source states instead of `rawSheets`/bare empty strings.
- `test/cross_check_engine_test.dart` — build snapshot and availability fixtures.

## Implementation Steps

1. Add `WorkbookCell` conversion using exhaustive `CellValue` switching:
   - Obtain coordinates from `Data.rowIndex`, `Data.columnIndex`, and `cellIndex`.
   - `DateCellValue`/`DateTimeCellValue` → typed date under one date-only/local policy plus normalized display text.
   - Every decoded `FormulaCellValue` → formula kind and unavailable numeric value; never parse it as a metric.
   - Numeric/text/bool/time → stable display text and kind.
2. Replace `_readRows()` with snapshot construction. Preserve source row numbers even when empty rows are omitted from derived text rows.
3. Change `_cutSheets()` so budget reduction affects prompt rendering only. `ExtractionResult.records` comes from the full classified record set.
4. Compute workbook completeness: intentional non-test sheets do not degrade it; skipped test-like sheets, row caps, malformed regions, or unknown candidate modules produce partial/unsupported with evidence.
5. Add document-level availability in `document_service.dart`; empty/image-only PDF, empty DOCX text, parse failure, and truncation cannot masquerade as available.
6. Clean-cut all `rawSheets` references to `workbook`; no deprecated field or dual-write shim.
7. Add generic `findUniqueHeaderColumn(row, aliases)` using existing `foldHeader`; do not extend test-case `CanonicalField` with unrelated TOC semantics.
8. Replace non-null/zero-sentinel fields in `ThreeWayMetricsComparison`: declared total/pass/fail/manual/auto, actual manual/auto, `totalDiscrepancy`, `concealedFails`, and percentages become availability-aware values. Actual total/pass/fail are available only for complete extraction.
9. Attach `SourceEvidence` to raw-sheet `IntegrityFinding` and each parsed `MetricValue`; add `CrossCheckResult.ruleOutcomes` as the sole diagnostics/status path.
10. Implement one derivation truth table: both operands required for difference/concealed-fail checks; denominator must be > 0 for percentages; valid raw zero remains available.
11. Add encode→decode extraction tests with `DateCellValue`, `DateTimeCellValue`, `FormulaCellValue`, blank rows, shifted headers, prompt truncation, skipped candidate sheets, and empty documents. Direct subtype construction alone is insufficient proof.

## Todo List

- [ ] Add workbook snapshot, source availability, safe evidence, and sealed rule outcomes.
- [ ] Separate full deterministic records from bounded prompt content.
- [ ] Preserve typed cells and original coordinates through encode/decode.
- [ ] Clean-cut `rawSheets` callers to `workbook`.
- [ ] Gate whole-workbook metrics on complete extraction; remove every zero sentinel from source and derived fields.
- [ ] Attach evidence and authoritative per-rule outcomes to `CrossCheckResult`.
- [ ] Propagate empty/partial document status to the bundle.
- [ ] Prove formula, date, coordinate, truncation, and skipped-sheet behavior without machine-local fixtures.

## Success Criteria

- Cover date cells no longer collapse to unexplained serial text when the package identifies a date type.
- Every formula metric is unavailable; no cached result is inferred.
- A cross-check finding can cite `Sheet!D14` using original workbook coordinates.
- Missing, partial, and declared-zero metrics remain distinct.
- Prompt truncation does not change the full deterministic record count; incomplete classification prevents authoritative total comparisons.
- Empty/image-only or truncated documents are explicit source states, not valid empty text.

## Risks

- `excel` may not expose native hyperlinks. Do not claim native-link evidence; explicit target columns or the narrow internal-formula grammar in Phase 2 are the only supported signals.
- Availability migration can expose hidden assumptions in UI/exporters. Phase 3 owns every consumer; compiler errors are migration checklist, not reasons to restore defaults.
- Before source edits, capture the existing per-file diff/hash and mark user-owned hunks. Never stash, reset, checkout, or stage those hunks with task work.

## Security Considerations

- Evidence locators are safe metadata. Any displayed excerpt must pass `SafeEvidenceExcerpt`; never store/export raw formulas, credentials, PII, control characters, or unlimited source text.
- Public unavailable reasons use closed diagnostic codes and curated messages; parser exceptions, XML, filenames, and absolute paths stay internal.
- No external formula, macro, or link execution.

## Next Steps

Phase 2 consumes the typed snapshot and availability model. Do not start output migration before engine semantics compile.
