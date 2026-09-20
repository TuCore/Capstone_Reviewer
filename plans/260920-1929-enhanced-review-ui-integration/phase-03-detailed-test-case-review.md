# Phase 3 — Add Detailed Test Case Review Engine

## Context Links

- [Plan](./plan.md)
- [Teacher-feedback interpretation](./reports/brainstorm-summary.md)
- `lib/core/extraction/test_case_schema.dart`
- `lib/core/services/hard_checks.dart`
- `lib/core/services/cross_check_engine.dart`
- `lib/features/review/review_bundle.dart`
- `lib/core/services/excel_export_service.dart`

## Overview

- Priority: Critical
- Status: Completed
- Goal: produce one grounded, inspectable quality review for every extracted test case instead of only aggregate/module findings.

## Scope Boundary

[INFERENCE] “Reviewer test case chi tiết” means row-level quality review. This phase does not claim full requirement traceability or business-logic correctness because current extraction has no authoritative requirement→test mapping.

The engine may state:

- A field is missing, vague, contradictory, duplicated, or malformed under a named rule.
- Execution metadata conflicts with status/bug/date fields.
- Existing duplicate/status-conflict/hard-check findings apply to a record.

The engine must not state:

- A scenario fully satisfies business requirements.
- A test case is semantically correct merely because no deterministic rule fired.
- A requirement is covered unless an explicit traceability contract exists.
- A numeric quality score without an approved rubric.

## Data Model

Create `lib/core/services/test_case_review_engine.dart` with immutable types:

```dart
enum TestCaseIssueSeverity { critical, high, medium, low, info }

enum ReviewedField {
  id,
  description,
  preCondition,
  steps,
  testData,
  expected,
  status,
  testDate,
  note,
  bug,
  record,
}

class TestCaseIssue {
  final String code;
  final ReviewedField field;
  final TestCaseIssueSeverity severity;
  final String message;
  final String evidence;
  final String correction;
}

class TestCaseReview {
  final TestCaseRecord record;
  final List<TestCaseIssue> issues;
  TestCaseIssueSeverity? get highestSeverity;
  bool get hasIssues;
}
```

Names may follow existing Dart conventions, but semantics above are fixed. Do not duplicate all record fields into another mutable model.

Extend `ReviewBundle` with required `List<TestCaseReview> caseReviews`. Clean cutover: update every constructor and caller; no optional compatibility default.

## Deterministic Rule Set

### Required/completeness

- Missing ID, description, steps, or expected result → high/critical based on whether record remains identifiable/executable.
- Missing precondition or test data → informational/recommended unless the recognized template marks it required; do not blindly fail all rows.

### Clarity/testability

- Reuse existing `scoreWording()` result for expected-result clarity.
- Vague expected result, evidence-free conclusion, or mixed multi-outcome text → field-specific issue.
- Empty steps plus non-empty expected result → non-executable procedure issue.
- Keep rule wording bounded; no inferred product behavior.

### Identity/integrity

- Attach matching `HardCheckFinding` through stable `caseIdentity(record)`.
- Attach `DuplicateIdFinding` to each affected record using canonical/raw ID and sheet.
- Distinguish exact duplicate content from duplicate ID and cross-sheet status conflict.

### Execution metadata

- Unknown/noncanonical status → warning with raw value.
- Failed status with empty bug and note → warning: missing defect evidence/reference.
- Executed status with empty date → informational/warning according to template evidence.
- Do not infer a failed application defect from status alone.

### Result invariant

- Preserve source order.
- Exactly one `TestCaseReview` per `TestCaseRecord`, including clean rows.
- Issues use stable codes so UI filters and Excel exports do not depend on localized messages.
- Severity ordering is centralized once.

## Pipeline Integration

In `UploadController.analyzeFiles()`:

1. Extract records.
2. Run existing hard checks and cross-check.
3. Run `TestCaseReviewEngine` with records plus reusable findings.
4. Construct `ReviewBundle(records: records, caseReviews: reviews, ...)`.
5. Keep AI verifier independent; do not merge AI claims into deterministic issue list.

## Excel Integration

Preserve existing workbook/sheets. Extend the existing Test Cases sheet with grounded columns:

- Review verdict/highest severity
- Issue count
- Issue codes
- Affected fields
- Concise corrections

Rows use the same `caseReviews` list consumed by UI. No second review computation inside exporter.

## Related Files

- Create: `lib/core/services/test_case_review_engine.dart`
- Modify: `lib/features/review/review_bundle.dart`
- Modify: `lib/features/upload/presentation/upload_controller.dart`
- Modify: `lib/core/services/excel_export_service.dart`
- Modify: constructor fixtures/tests that create `ReviewBundle`
- Add focused engine tests following existing service-test conventions

## Implementation Steps

1. Inventory existing hard-check and cross-check rule outputs; reuse instead of duplicating scans.
2. Define immutable issue/review types and centralized severity ordering.
3. Implement one-to-one review pipeline in source-record order.
4. Add field completeness and wording rules with bounded messages.
5. Attach hard checks and duplicate/status-conflict findings to affected rows.
6. Add execution-metadata consistency rules.
7. Add required `caseReviews` to `ReviewBundle`; migrate every constructor.
8. Produce reviews in upload pipeline before bundle construction.
9. Extend existing Excel Test Cases sheet from supplied reviews.
10. Add behavior tests for rules, attachment, ordering, and one-to-one invariant.

## Todo

- [ ] Define typed issue and per-case review model
- [ ] Centralize severity ordering and stable codes
- [ ] Implement deterministic field-level rules
- [ ] Reuse hard-check and cross-check findings
- [ ] Enforce one review per extracted record
- [ ] Extend `ReviewBundle` through clean cutover
- [ ] Feed reviews from upload pipeline
- [ ] Add grounded Excel review columns
- [ ] Cover rule boundaries and invariants

## Success Criteria

- `caseReviews.length == records.length` for empty, single-row, and large fixtures.
- Each review retains the exact source `TestCaseRecord`.
- Missing/vague fields produce issues on the correct field with stable code and evidence.
- Clean rows remain present with empty issue list.
- Duplicate/status conflicts attach only to affected records.
- Existing aggregate hard-check and cross-check output remains unchanged.
- Exporter consumes precomputed reviews; it does not rerun rules.
- No AI response can create or alter deterministic issues.

## Risk Assessment

- Optional fields vary across templates. Mitigation: classify missing optional fields as info unless schema/template proves required.
- `caseIdentity()` may collide for empty descriptions. Mitigation: combine canonical ID, sheet, and source order where attachment needs disambiguation.
- Existing `HardCheckFinding` lacks typed severity/field. Mitigation: map stable hard-check codes centrally; do not parse human message text.
- Hundreds of corrections can make Excel cells huge. Mitigation: concise joined summaries and stable codes; full detail remains in UI.

## Security Considerations

- Review is local deterministic computation; no additional document content sent to AI.
- Evidence strings derive from already extracted fields; never include API keys.
- Registration PII does not enter per-test-case records.

## Teacher Validation Gate

Before adding full RTM or AI-per-row review, show teacher one detailed row and ask one binary question:

> “Thầy muốn chi tiết theo từng dòng test case như mẫu này, hay bắt buộc thêm mapping từng requirement/use case sang test case?”

If teacher requires mapping, create a separate RTM plan; do not silently expand this merge.

## Next Step

Render `caseReviews` as the default dashboard tab and retain aggregate views as supporting evidence.