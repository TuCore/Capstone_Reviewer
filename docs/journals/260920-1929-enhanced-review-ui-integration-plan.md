---
title: "Enhanced review UI integration planning"
type: journal
created: 2026-09-20
plan: plans/260920-1929-enhanced-review-ui-integration/plan.md
---

# Enhanced Review UI Integration Planning

## Context

Analyzed merge from `origin/feature/enhanced-review-system` into `feature/deterministic-verifier` after user reported conflicts and decision ambiguity.

## What Happened

- Fetched source ref and computed branch divergence.
- Predicted six merge conflicts with `git merge-tree`.
- Compared AI, export, upload, and review contracts.
- Found source dashboard useful but source AI/result contract incompatible with deterministic truth.
- Agreed to preserve target engine, require all three documents, add deterministic review for every test-case row, and rebuild selected source UI against `ReviewBundle`.
- Recovered that `feature/simplified-report` has no separate detailed reviewer; teacher feedback therefore adds new scope.
- Created five-phase implementation plan; no source implementation or merge performed.

## Decisions

- `ReviewBundle` remains sole result source.
- Target AI verifier, extraction, cancellation, key hygiene, and exporters win conflicts.
- Registration becomes mandatory and appears first/leftmost before SRS and Excel.
- Detailed Test Cases becomes default tab with one grounded review per extracted record.
- Dashboard retains grounded Overview, Reconciliation, Integrity, Verified Findings, and Full Report tabs.
- AI-generated Scorecard/RTM, plaintext key storage, dead models/widgets, and machine-specific editor config are rejected.

## Next

Execute `/ck:cook plans/260920-1929-enhanced-review-ui-integration/plan.md --auto` when implementation is authorized.