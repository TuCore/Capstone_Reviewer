# Phase 2: Replace Report5 Rules with Preconditions

## Context Links

- [Plan](./plan.md)
- [Phase 1](./phase-01-evidence-contract.md)
- `lib/core/services/cross_check_engine.dart:122-658`
- `lib/core/services/registration_pii.dart:1-46`
- `lib/features/upload/presentation/upload_controller.dart:362-496`
- `lib/core/services/ai_service.dart:300-470`

## Overview

- Priority: P1
- Status: Pending
- Effort: 3h
- Purpose: remove fixture facts and make every deterministic conclusion conditional on identifiable source evidence.

## Rule Contract

```text
checkedClean(evidence)                 → preconditions met, no violation
checkedWithFindings(findings)         → preconditions met, violation observed
notApplicable(publicReasonCode)       → rule does not apply to recognized source
unsupported(publicReasonCode)         → source/schema incomplete or ambiguous
```

Each rule owns one `RuleOutcome`; consumers never infer success from an empty list. No branch may convert partial/unsupported into `0`, a Report5 value, “Khớp”, “100%”, `HIGH`, or a clean verdict.

## Related Code Files

### Modify

- `lib/core/services/cross_check_engine.dart`
- `lib/core/services/ai_service.dart`
- `lib/features/upload/presentation/upload_controller.dart`
- `lib/features/review/review_bundle.dart`
- `lib/core/services/registration_pii.dart`
- `test/cross_check_engine_test.dart`
- AI verifier tests covering generic prompt and entailment gate.

### Delete

- Machine-local Report5 golden test block in `test/cross_check_engine_test.dart`; replace with deterministic in-repo/generated fixtures.

## Implementation Steps

1. **Metrics**
   - Remove `contains('320')`, M01+M10 → 338, inferred 267/53/71, and M04/BIM explanation.
   - Define accepted labels, structural scope, label/value adjacency, numeric syntax, subtotal/grand-total precedence, and uniqueness per metric.
   - Zero candidates → unavailable. Multiple non-identical candidates → ambiguous/unsupported with candidate locators. Repeated equal candidates may resolve only under the documented precedence.
   - Thousands separators require an explicit locale-safe grammar; malformed numbers are unsupported.
   - Every formula metric is unavailable under `excel` 4.0.6.
   - Whole-workbook comparisons require complete extraction. Partial record counts remain labeled lower bounds and cannot drive discrepancy/concealed-fail findings.
   - Passed percentages use each source’s own passed/total pair and the Phase 1 derivation truth table.
2. **Broken sheet references**
   - Primary supported contract: bind one TOC table and find exactly one visible target column via normalized aliases: `sheet name`, `worksheet`, `tab`, `tên sheet`.
   - Plain text under that confirmed column is the target. Without the column, return unsupported.
   - Optional formula path applies only when `excel` returns a `FormulaCellValue` whose text matches the narrow same-workbook internal-anchor grammar. `excel` 4.0.6 exposes no native hyperlink model; do not claim or infer native hyperlink metadata.
   - Internal formula grammar requires a `#` same-workbook fragment and supports quoted sheet names, escaped apostrophes, and anchors.
   - Reject external workbook brackets, URI schemes, UNC paths, DDE/XLM/WEBSERVICE, named/dynamic targets, `#REF!`, malformed formulas, and native hyperlinks unavailable to the package as unsupported. Never export raw formula text.
   - Skip actual headers/section rows/blanks. A nonblank data cell in a confirmed target column must resolve to valid target, explicit broken reference, or unsupported; never silently disappear.
   - Compare normalized trim/case/Unicode sheet names, report original decoded target, attach exact source cell from `WorkbookSnapshot`.
3. **Environment**
   - Remove PostgreSQL/Supabase, Azure SQL, and `cloud → Viettel` defaults.
   - Compare only unique explicit labeled environment/database fields in expected source roles. One missing or conflicting side means unsupported, not “consistent”.
   - Evidence carries short sanitized extracted values, never surrounding source text.
4. **Dates and timeline**
   - Remove fixed 10/08, 23/07, and 21/08/2026 branches.
   - Prefer typed Excel dates. Accept text dates only under explicit labels and documented unambiguous formats/locale.
   - Validate year/month/day by round trip; reject normalized invalid dates such as 31/02. Compare date-only under one local-date policy; ambiguous text and formula-only dates are unsupported.
   - Compare only a labeled milestone date with a complete, labeled execution-date source.
5. **Project-specific deterministic and AI rules**
   - Remove M08/M09-only copy-paste detection; do not replace it with unconditional all-pairs `HIGH`.
   - Remove `TC-DOC` and other sample identifiers as WIP/Published triggers.
   - Preserve WIP isolation, Published integrity, and tamper checks only when an explicit SRS-derived requirement/configured rule scope identifies the applicable entity/module and lifecycle states. No precondition → not-applicable. Conflicting/partial requirement evidence → unsupported.
   - Remove developer-authored M03, WIP, Published Integrity, digital-signature, or other Report5/BIM seeds/examples from generic AI prompts. Identical strings supplied by the user’s real SRS/test data remain allowed and must not be filtered.
   - Quote presence proves provenance only. A verifier result is not marked semantically verified unless the existing gate can establish entailment; otherwise downgrade to an unverified suggestion or omit.
   - Gate AI and cross-document rules on required source availability. Excel-only checks may continue when SRS/registration are unavailable, but the bundle must be explicitly partial.
   - Keep generic placeholder detection and duplicate/status-conflict checks; cross-check finding constructors require non-empty safe evidence.
   - **Boundary with `hard_checks.dart`**: Các check record-level trong `hard_checks.dart` (vague tokens, naming, empty, sheet-type) giữ nguyên quy tắc kỹ thuật chung; không gán rule outcomes hay buộc exact-cell coordinates trong đợt này.
6. **Registration and report composition**
   - Remove fixed BIM title, SU26SE017, Vercel, Azure/PostgreSQL, Playwright, and fixed 34/320/338 recommendations from `UploadController`.
   - Extract topic only from a unique labeled candidate. Conflicting candidates or template-example text make the field unavailable; equal duplicates may collapse with evidence.
   - Keep evidence-bearing registration context through `ReviewBundle`. Unknown fields are omitted or shown as `Chưa xác định`.
   - Build recommendations only from checked findings. Unsupported/not-applicable outcomes never generate remediation.
   - Replace “độ chính xác tuyệt đối” and “đúng sự thật” with cautious wording: deterministic comparison of recognized evidence from supplied documents.
7. **Public diagnostics and Markdown**
   - Replace `Report5 §5.2`, `Test Statistics`, and `M01-M10` with neutral source labels.
   - Public reasons come from closed diagnostic codes; no parser exceptions, paths, formulas, or arbitrary source text.
   - Source-derived Markdown values pass one escaping boundary: collapse newlines, remove bidi/control characters, escape headings/tables/HTML/links/images.
   - “Khớp” means “không thấy sai lệch giữa các nguồn đã cung cấp” and appears only for `checkedClean`.

## Todo List

- [ ] Remove all fixture-number, date, module, project, technology, recommendation, and AI prompt seeds.
- [ ] Implement strict candidate selection, ambiguity outcomes, and derived-value truth table.
- [ ] Gate metrics, sheet-link, environment, timeline, and AI rules by source completeness.
- [ ] Remove global BIM-specific deterministic and qualitative assumptions.
- [ ] Ground registration metadata and recommendations in checked outcomes.
- [ ] Add narrow safe internal-link grammar and Markdown/evidence sanitization.
- [ ] Replace skipped machine-local golden with deterministic scenarios.

## Regression Scenarios

- Unrelated workbook contains `M01_Authentication` and `M10_System_Settings`, no readable statistics: declared total unavailable; never 338.
- Prompt budget truncates records or a test-like sheet is skipped: observed count is partial/lower-bound; no total discrepancy.
- Word contains unrelated number `320`, conflicting totals, subtotals, or malformed/locale-ambiguous numbers: no invented metric.
- TOC description column contains `Uploading Various Formats`: zero broken-sheet findings.
- Valid target differs only by case/whitespace or uses quoted/escaped internal formula: valid.
- Missing explicit internal target: exactly one finding with source cell.
- External/URI/UNC/dynamic/malformed formula, conflicting target signals, duplicate TOC columns, or `#REF!`: unsupported, never missing-sheet `HIGH`.
- Invalid/ambiguous dates, missing database/milestone, empty/image-only SRS/PDF: unsupported/partial, never mismatch or clean.
- Generic prompt template contains no developer-authored M03/WIP/Published/digital-signature seed; the same strings remain intact when present in real user input.
- Explicit SRS lifecycle scope + violating rows trigger WIP/Published rule; similarly worded out-of-scope data returns not-applicable; partial/conflicting requirement evidence returns unsupported.
- Conflicting registration topics do not become report title.
- Two modules share generic requirement text: no automatic `HIGH` copy-paste finding.

## Success Criteria

- Generic production search finds none of the forbidden Report5 facts listed in plan success criteria, excluding historical plans and tests asserting absence.
- Every cross-check finding has required safe evidence and satisfied preconditions.
- Every rule has an explicit outcome; missing inputs render unsupported/partial, never implicit success.
- Unknown input never generates the screenshot’s cascade of `broken-sheet-link` findings.
- Report recommendations and AI findings are pure functions of current checked evidence, not seeded prose.

## Risks

- Removing project-specific rules reduces findings on the original sample. Correct tradeoff: fewer grounded findings beat false accusations.
- Labeled values can still be attacker-authored. Output wording states consistency among supplied evidence, never authenticity or correctness.
- Similar-requirement detection is deferred rather than generalized unsafely.

## Security Considerations

- All evidence and registration values cross `SafeEvidenceExcerpt`/structured-value boundaries before rendering; raw formulas and full rows are prohibited.
- Public diagnostic codes map to curated text. Sensitive parser details remain internal.
- Generic prompt and report text escape source-controlled Markdown structure.

## Next Steps

Phase 3 migrates every presentation/export consumer and proves identical grounded semantics across outputs.
