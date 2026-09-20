# Phase 5 — Clean, Verify, and Complete Merge

## Context Links

- [Plan](./plan.md)
- [Phase 1](./phase-01-safe-merge-boundary.md)
- [Phase 2](./phase-02-three-document-upload.md)
- [Phase 3](./phase-03-detailed-test-case-review.md)
- [Phase 4](./phase-04-grounded-dashboard.md)

## Overview

- Priority: Critical
- Status: Completed
- Goal: prove detailed reviewer, deterministic behavior, and UI integration; remove merge debris; create final merge commit.

## Cleanup Requirements

- Remove every source-only model/widget/service without a caller.
- Remove stale imports, optional-registration copy, conflict comments, and migration notes.
- Keep target docs, tests, fixtures, extraction modules, and plans.
- Do not add source `.vscode/settings.json`.
- Do not retain compatibility aliases for `ReviewAuditResult`, raw JSON review content, `proposalPath`, or source exporter signatures.
- Format only changed Dart files.

## Verification Order

1. Static diagnostics on changed files.
2. `flutter analyze`.
3. Targeted tests covering input preconditions, per-case engine invariants, bundle navigation, dashboard, and exporters.
4. Full `flutter test`.
5. Launch actual Windows app.
6. Confirm upload order and required-input transitions.
7. Run one complete three-document review using authorized test fixtures/key.
8. Inspect all six dashboard tabs.
9. Open multiple detailed test cases and exercise search/filter/sort.
10. Export PDF and Excel; compare aggregate and detailed rows against dashboard.
11. Resize window to narrow and standard laptop dimensions; inspect overflow and table scrolling.
12. Only then commit merge and push integration branch if requested.

## Behavioral Scenarios

| Scenario | Expected |
|---|---|
| Initial upload screen | Registration first/leftmost, then SRS, then Excel |
| Registration missing | Review disabled; explicit required copy |
| SRS missing | Review disabled |
| Excel missing | Review disabled |
| Invalid API key | Review disabled/error without key echo |
| Invalid registration file | FileGate reason; no AI call |
| Cancel during analysis | No navigation; stale result ignored; key wiped |
| 338 extracted records | Exactly 338 detailed reviews and 338 unfiltered rows |
| Test case has missing expected result | Field-specific deterministic issue with evidence |
| Test case has no rule finding | “No deterministic issue detected,” never “logically correct” |
| Filter by severity/module | Visible subset changes; source totals remain unchanged |
| Null cross-check | Dashboard shows unavailable state, not zero/clean |
| No verified findings | Neutral empty state, not “no gaps exist” |
| Findings exceed viewport | Lazy/scrollable list; no overflow |
| Export cancelled | No success toast; UI returns from exporting state |
| Export succeeds | Dashboard and Excel case-review rows/counts match |

## Test Policy

Keep/add only behavior-bearing tests:

- Required three-document enablement and upload-order semantics.
- One-to-one invariant: each `TestCaseRecord` yields one `TestCaseReview`.
- Field-level boundaries: missing expected, vague expected, duplicate/status conflict, unknown status, failed-without-bug metadata.
- Navigation receives `ReviewBundle`, never raw JSON.
- Detailed tab renders controlled row issue/evidence and honest clean-state wording.
- Dashboard renders deterministic discrepancy and verified quote from a controlled bundle.
- Excel detailed columns match review results.
- Null/empty state semantics where a plausible regression could falsely report success.

Do not test source text, widget implementation details, field forwarding, or decorative colors.

## Merge Completion

- Review staged diff for accidental backend/source acceptance.
- Confirm merge has two parents and target is first parent.
- Use merge message describing deterministic-core preservation, detailed reviewer, and grounded UI integration.
- Keep target branch unchanged until integration verification passes.
- Merge integration branch back without rewriting shared history.

## Todo

- [ ] Remove dead source files and imports
- [ ] Format changed Dart files
- [ ] Run static analysis
- [ ] Run targeted behavioral tests
- [ ] Run full test suite
- [ ] Smoke actual Windows flow and responsive dashboard
- [ ] Verify one-to-one detailed review invariant
- [ ] Verify upload order and required inputs
- [ ] Verify PDF/Excel aggregate and detail parity
- [ ] Review final staged diff
- [ ] Commit merge on integration branch
- [ ] Merge back only after approval

## Success Criteria

- No conflict markers or unmerged paths.
- No duplicate aggregate review-result model.
- No API-key persistence.
- No machine-specific editor settings.
- Analyze and tests pass.
- Real UI flow verified with three required documents.
- Every extracted record appears once in detailed reviewer.
- Dashboard and Excel detailed review agree.
- Aggregate dashboard/export values agree.
- Final merge is revertible with one merge revert.

## Risk Assessment

- Tests may pass while visual hierarchy fails. Mitigation: actual Windows smoke and resize checks.
- Per-case rules may overstate optional-field defects. Mitigation: fixture-driven rule boundaries and bounded wording.
- Export contract may drift during UI wiring. Mitigation: share `caseReviews` and compare output rows.
- Merge commit may accidentally include unrelated working-tree changes. Mitigation: start clean, inspect staged path list before commit.

## Security Considerations

- Use only authorized fixtures and API credentials during smoke test.
- Never commit keys, generated reports containing PII, or local export paths.
- Confirm errors remain redacted.

## Next Step

After verified merge, run code review before landing into shared target branch.
