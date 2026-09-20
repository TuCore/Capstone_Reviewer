# Phase 1 — Establish Safe Merge Boundary

## Context Links

- [Plan](./plan.md)
- [Brainstorm Summary](./reports/brainstorm-summary.md)
- [Completed deterministic plan](../260917-deterministic-verifier/plan.md)

## Overview

- Priority: Critical
- Status: Completed
- Goal: create abortable integration branch, start merge, preserve target contracts before UI adaptation.

## Requirements

- Start from latest `feature/deterministic-verifier` with clean working tree.
- Fetch both remote refs.
- Create `integration/enhanced-deterministic-ui`.
- Merge source with `--no-commit --no-ff`.
- Never resolve all conflicts with global ours/theirs.
- Keep target package/dependency state unless a selected UI file proves a missing dependency.

## Conflict Policy

| Conflict | Initial resolution | Rationale |
|---|---|---|
| `lib/core/services/ai_service.dart` | Target | Keeps retry, typed errors, tagged input, verifier, quote grounding |
| `lib/core/services/excel_export_service.dart` | Target | Keeps complete deterministic workbook and atomic write |
| `lib/core/services/pdf_export_service.dart` | Target | Keeps existing grounded report contract |
| `lib/features/upload/presentation/upload_controller.dart` | Target baseline | Phase 2 applies mandatory-registration change without source regressions |
| `lib/features/upload/presentation/upload_screen.dart` | Manual, target baseline | Phase 2 ports selected visual patterns |
| `lib/features/review/presentation/review_screen.dart` | Manual, target baseline | Phase 4 replaces body with grounded dashboard while retaining exports |

## Source Additions Quarantine

Immediately reject:

- `.vscode/settings.json`
- `lib/core/services/local_storage_service.dart`

Temporarily retain only as migration references, then remove in Phase 4/5 if no grounded caller:

- `lib/core/models/anti_pattern.dart`
- `lib/core/models/metrics.dart`
- `lib/core/models/review_audit_result.dart`
- `lib/core/models/rtm_item.dart`
- `lib/core/models/scorecard.dart`
- `lib/core/models/test_case_suggestion.dart`
- `lib/features/review/presentation/review_controller.dart`
- `lib/features/review/presentation/widgets/*`

Do not commit merge yet. Keep merge abortable through Phases 2–5.

## Implementation Steps

1. Verify current branch and clean tree.
2. Fetch target and source refs.
3. Re-run `git rev-list`, `git merge-base`, and `git merge-tree`; stop if source changed materially.
4. Create integration branch from target HEAD.
5. Start no-commit merge.
6. Resolve core conflicts per table.
7. Remove editor config and plaintext key storage.
8. Search for conflict markers.
9. Record source-only UI files and their imports before adaptation.

## Related Files

- Modify: six conflict files listed above.
- Delete: `.vscode/settings.json`, `lib/core/services/local_storage_service.dart`.
- Preserve: all extraction, cross-check, hard-check, verifier, and test files from target.

## Todo

- [ ] Create integration branch from latest target
- [ ] Start `--no-commit --no-ff` merge
- [ ] Apply file-level conflict policy
- [ ] Remove unsafe/machine-specific additions
- [ ] Confirm no conflict markers remain
- [ ] Keep merge uncommitted for adaptation

## Success Criteria

- Git index has no unmerged paths.
- Target public APIs still present: `ReviewBundle`, `AIService.runLlmVerifierPipeline`, `ExcelExportService.export`, `PdfExportService.exportReportToPdf`.
- No key-persistence import or absolute developer path remains.
- No merge commit created yet.

## Risks

- Source ref advances after analysis. Mitigation: recompute merge tree before starting.
- Accidental source backend acceptance. Mitigation: symbol-level checks against target API list.
- Long uncommitted merge. Mitigation: isolated branch, small phases, `git merge --abort` available.

## Security Considerations

- API key remains memory-only.
- Do not log merge-time sample keys or source payloads.
- Do not reintroduce raw AI JSON as trusted application state.

## Next Step

Proceed to mandatory input contract and upload UI while merge remains uncommitted.