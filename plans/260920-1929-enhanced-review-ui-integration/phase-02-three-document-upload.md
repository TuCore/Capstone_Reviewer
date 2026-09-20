# Phase 2 — Enforce Three-Document Upload Contract

## Context Links

- [Plan](./plan.md)
- [Phase 1](./phase-01-safe-merge-boundary.md)
- `lib/features/upload/presentation/upload_controller.dart`
- `lib/features/upload/presentation/upload_screen.dart`

## Overview

- Priority: High
- Status: Completed
- Goal: require registration, SRS, Excel, and valid API key without losing target validation, cancellation, or result contract.

## Functional Requirements

- `UploadState.canAnalyze` requires `registrationPath != null`.
- `analyzeFiles()` rejects missing registration before any extraction/network work.
- Registration passes `FileGate.inspect()` independently.
- File-size/chunked status includes registration document.
- Registration extraction always runs after required preconditions pass.
- Registration text still goes through `extractRegistrationContext()` minimization.
- Result remains `Future<ReviewBundle?>`.
- Cancel, stale-run protection, deep pass, key validation, key redaction, and post-run key wipe remain unchanged.

## Upload UI Design

- Keep target `LayoutBuilder`, scrolling, narrow-height protection, error/status banners, and cancel action.
- Port source visual hierarchy only: distinct icons/colors, required subtitle, selected-file state.
- Exact left-to-right card order: **Registration/Proposal → SRS → Excel Test Cases**.
- Registration card is first because it establishes project scope/context before technical documents.
- Every drop zone says `Bắt buộc` and lists accepted formats.
- Review button disabled state includes concise helper text naming missing inputs.
- Never persist API key.
- Do not accept legacy `.doc` if `FileGate` rejects it; displayed format copy must match actual gate behavior.

## Implementation Steps

1. Add registration to `canAnalyze` predicate.
2. Replace optional-input error copy with explicit three-document requirement.
3. Inspect registration with `FileGate`; surface its reject reason.
4. Include registration file size band in loading-state decision.
5. Remove nullable registration extraction branch after precondition; keep minimized prompt block.
6. Reorder upload cards to Registration, SRS, Excel.
7. Update registration title/subtitle from optional to required.
8. Add subtitles to all drop zones; retain responsive sizing.
9. Make missing-input guidance derive from state, not duplicated booleans in UI.
10. Update existing behavioral coverage for disabled/enabled Review transition and card order semantics.

## Related Files

- Modify: `lib/features/upload/presentation/upload_controller.dart`
- Modify: `lib/features/upload/presentation/upload_screen.dart`
- Modify: existing upload/widget tests that cover button enablement and navigation

## Todo

- [ ] Require registration in controller preconditions
- [ ] Gate and extract registration deterministically
- [ ] Preserve key/cancel/stale-run behavior
- [ ] Polish three required drop zones
- [ ] Add missing-input guidance
- [ ] Cover required-input boundary

## Success Criteria

- Registration card is first/leftmost at desktop width and first in reading/focus order.
- Missing registration prevents review before file parsing or AI calls.
- Three valid paths plus valid API key enable review.
- Invalid registration surfaces `FileGate` reason.
- Successful flow still navigates with `ReviewScreen(bundle: result)`.
- Cancelled/stale operations never navigate.

## Risk Assessment

- `copyWith` cannot currently clear nullable paths because `null` means retain; existing clear methods rebuild state. Do not casually replace them with nullable `copyWith` calls.
- UI copy may advertise `.doc` although gate rejects it. Copy must follow actual accepted kinds.
- Registration may contain PII. Preserve minimization before AI dispatch.

## Security Considerations

- Keep `ApiKeyFormat.normalize/errorFor/redact`.
- Keep key out of persistent storage and error strings.
- Send only minimized registration context to AI.

## Next Step

Add deterministic review output for every extracted test case.
