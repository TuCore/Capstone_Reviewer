---
title: "Detailed Test Case Review UI Integration"
description: "Merge enhanced UI while adding grounded per-test-case review and preserving deterministic truth, security, and exporters."
status: completed
priority: P1
effort: 18h
branch: feature/deterministic-verifier
tags: [feature, frontend, refactor, critical]
blockedBy: []
blocks: []
created: 2026-09-20
---

# Detailed Test Case Review UI Integration

## Overview

Integrate `origin/feature/enhanced-review-system` into `feature/deterministic-verifier` through an isolated merge. Preserve deterministic extraction, cross-checking, verifier, key hygiene, and cancellation. Add a deterministic review result for every extracted test case, then rebuild selected enhanced UI against `ReviewBundle`. Require registration, SRS, Excel, and valid API key; display registration first in the upload flow.

Research: [Brainstorm Summary](./reports/brainstorm-summary.md)

## Fixed Decisions

- Target engine wins every data/AI/export conflict.
- `ReviewBundle` remains sole aggregate review-result source.
- Every `TestCaseRecord` receives one deterministic `TestCaseReview`.
- Detailed Test Cases is the primary/default review tab; aggregate dashboard becomes secondary.
- All three documents mandatory.
- Upload order: Registration → SRS → Excel, left to right.
- Enhanced visuals allowed only after binding to deterministic fields.
- No AI-generated Scorecard/RTM until a separate deterministic scoring/traceability feature exists.
- No plaintext API-key persistence.
- No machine-specific `.vscode/settings.json`.
- Merge occurs on `integration/enhanced-deterministic-ui`, not directly on target.

## Architecture

```text
Registration + SRS + Excel + API key
                 │
                 ▼
 FileGate → extraction → List<TestCaseRecord>
                 │
                 ├── TestCaseReviewEngine → List<TestCaseReview>
                 ├── CrossCheckEngine → CrossCheckResult
                 ├── CoverageStats / HardCheckFinding
                 └── LLM verifier → VerifiedFinding
                              │
                              ▼
                         ReviewBundle
                              │
   ┌──────────────┬──────────┬───────────┬──────────┬──────────┬──────────┐
   ▼              ▼          ▼           ▼          ▼          ▼
Case details   Overview   Reconcile   Integrity   Verified   Full report
                              │
                              ▼
             Existing exporters + detailed Excel columns
```

## Phases

| Phase | Name | Status |
|---|---|---|
| 1 | [Establish Safe Merge Boundary](./phase-01-safe-merge-boundary.md) | Completed |
| 2 | [Enforce Three-Document Upload Contract](./phase-02-three-document-upload.md) | Completed |
| 3 | [Add Detailed Test Case Review Engine](./phase-03-detailed-test-case-review.md) | Completed |
| 4 | [Build Grounded Review Dashboard](./phase-04-grounded-dashboard.md) | Completed |
| 5 | [Clean, Verify, and Complete Merge](./phase-05-verification-and-merge.md) | Completed |

## Cross-Plan Dependencies

No active blocker. Builds on completed plans:

- [`260913-gap-remediation`](../260913-gap-remediation/plan.md)
- [`260917-deterministic-verifier`](../260917-deterministic-verifier/plan.md)

New product decision supersedes their optional-registration behavior: registration is now mandatory.

## Merge Inputs

| Role | Ref | Commit |
|---|---|---|
| Target | `feature/deterministic-verifier` | `360e23ed957e8b36c8b29151317212d66cf12929` |
| Source | `origin/feature/enhanced-review-system` | `5ffd1444898196d008db1073588782c479a70b49` |
| Merge base | — | `2deda3bad9387df25254c1427ca4b203bf2296a1` |

Re-fetch source before execution; commit may advance. If it advances, repeat merge-tree analysis before applying this plan.

## Non-Goals

- Numeric test-case quality score without a defined rubric.
- Requirement-level RTM engine.
- AI review of every row or AI-owned verdicts.
- New AI prompt contract.
- Full PDF/Excel redesign; only extend existing Test Cases sheet with grounded review columns.
- API-key persistence.
- Mobile/web redesign.
- Changes to unrelated hardcoded report content.

## Success Criteria

- Clean merge ancestry; no unresolved markers.
- Review blocked until three valid documents and valid API key exist.
- Registration upload card appears first/leftmost.
- Every extracted test case has exactly one detailed review result.
- Per-case findings identify field, rule, severity, evidence, and actionable correction without invented logic claims.
- Existing deterministic engine and exporter behavior preserved.
- Detailed Test Cases opens by default; aggregate tabs expose only grounded `ReviewBundle` fields.
- Excel Test Cases output includes the same per-case review verdict/issues shown in UI.
- No duplicate aggregate result models or dead source widgets remain.
- UI responsive on Windows desktop at narrow and standard laptop widths.
- `flutter analyze` and full `flutter test` pass.
- Actual Windows smoke flow and both exports verified.

## Rollback

Before merge commit: `git merge --abort` on integration branch. After merge commit: revert merge with `git revert -m 1 <merge-commit>`; never force-push shared branches.

## Handoff

Implementation command:

```text
/ck:cook plans/260920-1929-enhanced-review-ui-integration/plan.md --auto
```