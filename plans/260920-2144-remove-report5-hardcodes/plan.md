---
title: "Remove Report5 Hardcodes and Fail Safely"
description: "Remove fixture-specific claims from review, preserve source evidence, and return unavailable instead of guessing unsupported document layouts."
status: completed
priority: P1
effort: 10h
branch: feature/deterministic-verifier
tags: [bugfix, refactor, critical]
blockedBy: []
blocks: []
created: 2026-09-20
---

# Remove Report5 Hardcodes and Fail Safely

## Overview

Make the generic Capstone Reviewer truthful across unknown document formats without trying to parse every template. Remove every Report5/BIM-specific fact from production paths. A rule may emit a finding only after its source preconditions are satisfied; otherwise it reports `unavailable`/`unsupported`, never substitutes `0`, fixture values, or a project-specific conclusion.

## Fixed Decisions

- Goal is safe abstention, not universal template coverage.
- Static rule IDs, severity labels, UI copy, and header aliases are valid hardcodes.
- Project facts, counts, dates, module names, technologies, percentages, recommendations, and AI examples must be source-bound.
- Generic engine gets no `Report5Profile`, `LegacyFptProfile`, or speculative adapter layer.
- Every decoded `FormulaCellValue` is unavailable for numeric comparison under `excel` 4.0.6; no formula evaluator or cached-value guess.
- Whole-workbook counts are authoritative only when extraction completeness is `complete`; partial observations are labeled lower bounds and never compared as totals.
- Each rule returns a typed outcome: checked-clean, checked-with-findings, not-applicable, or unsupported. Empty finding lists never imply success.
- Report5-specific WIP/Published, M03 prompt seeds, and M08/M09 rules leave generic production paths.
- Existing user modifications in affected files are user-owned; implementation records a baseline and stages/reverts only task-owned hunks.

## Scope Challenge

- Existing code: `foldHeader`, `mapHeaders`, sheet classification, registration topic extraction, normalized statuses, and literal `TextCellValue` export are reusable.
- Minimum change: source completeness, typed workbook evidence, sealed rule outcomes, optional metrics, grounded AI/report composition, one presentation projection, consumer migration, regression coverage.
- Complexity: cross-layer migration across extraction, deterministic rules, AI prompt, controller, UI, Markdown/PDF, Excel, and tests. Three sequential phases avoid parallel contract drift.
- Scope Boundary: Contract `RuleOutcome`, `CrossCheckResult.ruleOutcomes`, và `SourceEvidence` chỉ quản lý outputs của `CrossCheckEngine`. `HardCheckFinding` từ `lib/core/services/hard_checks.dart` nằm ngoài contract này, giữ nguyên luồng hiện tại, không bịa evidence và không bị suppress.
- Selected mode: HOLD SCOPE. Remove false claims completely; do not promise unsupported formats.

## Cross-Plan Dependencies

No active blocker. Builds on completed plans [`260917-deterministic-verifier`](../260917-deterministic-verifier/plan.md) and [`260920-1929-enhanced-review-ui-integration`](../260920-1929-enhanced-review-ui-integration/plan.md). No bidirectional frontmatter update required because both are completed.

## Architecture

```text
XLSX/Data cells     Word/PDF/Registration
       │                       │
       ▼                       ▼
typed snapshot + per-source ExtractionAvailability
       │                       │
       └──────────────┬────────┘
                      ▼
              sealed RuleOutcome
       checked │ finding │ unsupported
                      ▼
       canonical report projection
       ├─ UI
       ├─ Markdown → PDF
       └─ Excel
```

## Phases

| Phase | Name | Status |
|---|---|---|
| 1 | [Preserve Workbook Evidence and Availability](./phase-01-evidence-contract.md) | Pending |
| 2 | [Replace Report5 Rules with Preconditions](./phase-02-grounded-rules.md) | Pending |
| 3 | [Migrate Outputs and Prove No Fabrication](./phase-03-consumers-and-regression.md) | Pending |

## Non-Goals

- Parsing every Word/Excel template.
- Evaluating arbitrary Excel formulas.
- Requirement-level RTM or new AI features beyond removing seeded Report5/BIM assumptions.
- Reintroducing project-specific business rules through hidden template profiles.
- Deep VBA/OLE/external-OOXML threat scanning; track separately if macro-enabled inputs enter supported scope.
- Redesigning dashboard visuals or report layout beyond truthful unavailable/evidence states.

## Success Criteria

- No generic production path injects Report5/BIM/SU26SE017, `320/338/267/53/71`, M01-M10, M03/M04, fixed 2026 dates, fixed technologies, or fixed recommendations.
- Unknown or partial input produces explicit unavailable/partial outcomes, never zero-based discrepancy, clean verdict, `HIGH` finding, or authoritative “actual total”.
- Broken-sheet rule ignores description columns, rejects external/dynamic formulas, matches valid targets after normalization, and reports a truly missing internal target with exact source cell.
- Generic AI prompts contain no CDE/WIP/Published/digital-signature/module seed; quote presence alone is not labeled semantic verification.
- UI, Markdown, PDF, and Excel render one canonical projection without recomputing verdicts or percentages.
- Public evidence/reasons contain safe typed values or capped escaped excerpts, never raw formulas, secrets, PII, parser exceptions, or absolute paths.
- No test depends on an absolute machine path or returns early as a passing golden.
- Focused tests, full `flutter test`, `flutter analyze`, and Windows smoke upload/export pass.

## Red Team Review

### Session — 2026-09-20

**Findings:** 22 raw, 14 deduplicated (12 accepted, 2 rejected)
**Severity:** 5 Critical, 15 High, 2 Medium before deduplication.

| # | Finding | Severity | Disposition | Applied To |
|---|---|---|---|---|
| 1 | Partial extraction presented as actual total | Critical | Accept | Phases 1, 3 |
| 2 | Unsupported document input not modeled | Critical | Accept | Phases 1, 2 |
| 3 | Empty finding lists can render as success | Critical | Accept | All phases |
| 4 | Report5 assumptions remain in AI prompt | Critical | Accept | Phase 2 |
| 5 | Formula/date/package assumptions are loose | High | Accept | Phases 1, 2 |
| 6 | Metric/header candidate ambiguity undefined | High | Accept | Phase 2 |
| 7 | Outputs recompute semantics independently | High | Accept | Phase 3 |
| 8 | Production controller composition untested | High | Accept | Phase 3 |
| 9 | Evidence/reasons can leak or inject content | High | Accept | All phases |
| 10 | Internal-link formula grammar undefined | High | Accept | Phase 2 |
| 11 | Registration first-match can select template text | Medium | Accept | Phase 2 |
| 12 | Dirty-worktree rollback can erase user hunks | High | Accept | Phases 1, 3 |
| 13 | Require exact-cell evidence for every existing hard-check family | High | Reject | Separate hard-check provenance refactor; this plan guarantees cross-check findings only |
| 14 | Deep-scan VBA/OLE/external OOXML parts | High | Reject | Separate file-security scope; current plan never evaluates formulas/macros |

**Decision:** User approved applying filtered findings. Scope remains removal of fabricated claims, not universal parsing or a broad security rewrite.

## Handoff

```text
/ck:cook D:/AShiroru/ProgramCode/Project/Team/prm-prj/lab1/Capstone_Reviewer/plans/260920-2144-remove-report5-hardcodes/plan.md
```
