---
title: "Capstone Reviewer gap remediation"
description: "Close gaps between mentor requirements and current app: registration input, extraction quality, review depth, Excel export"
status: completed
lastUpdated: 2026-09-13

branch: main
tags: [feature, frontend, api]
blockedBy: []
blocks: []
created: 2026-09-13
---

# Capstone Reviewer gap remediation

## Overview

Audit đối chiếu transcript mentor + bộ report mẫu (New folder (3)) với codebase hiện tại.
App chạy được flow 2-file → AI → PDF, nhưng thiếu input phiếu đăng ký,
xuất Excel sai yêu cầu, extraction mất cấu trúc, prompt chưa ép trích use case.

Thứ tự làm: phase 2 (spike) trước để chốt số và dependency, rồi 1, rồi 3.

## Phases

| Phase | Name | Status |
|-------|------|--------|
| 1 | [Inputs, state lock, key hygiene](./phase-01-inputs-cleanup.md) | Completed |
| 2 | [Extraction spike + quality](./phase-02-extraction.md) | Completed |
| 3 | [Review depth and dual export](./phase-03-review-export.md) | Completed |

## Dependencies

- `excel`, `syncfusion_flutter_pdf`, `file_picker`, `archive`, `xml` đã có
- Phase 2 spike: Heading1–4 đọc được qua `archive` + `xml`. Không thêm `syncfusion_flutter_docx`. `docx_to_text` đã gỡ.

## Red Team Review

### Session — 2026-09-13
**Findings:** 15 (15 accepted, 0 rejected)
**Severity breakdown:** 7 Critical, 6 High, 2 Medium

| # | Finding | Severity | Disposition | Applied To |
|---|---------|----------|-------------|------------|
| 1 | Heading parse assumes style APIs stated packages lack | Critical | Accept | Phase 2 (spike-first) |
| 2 | Registration form mandatory vs transcript optional | Critical | Accept | Phase 1 (optional slot) |
| 3 | Size guard runs after full parse (OOM on 62MB) | Critical | Accept | Phase 2 (pre-parse gate) |
| 4 | N-file/browse with no concurrency lock | Critical | Accept | Phase 1 (runId + lock) |
| 5 | 2-pass prompt with no partial-failure contract | Critical | Accept | Phase 3 (single-pass default) |
| 6 | API key plaintext in state + URL query transport | Critical | Accept | Phase 1 + 3 (key hygiene) |
| 7 | Untrusted file content raw-interpolated into prompt | Critical | Accept | Phase 3 (tagged blocks) |
| 8 | Sheet skip-list tuned to one sample file | High | Accept | Phase 2 (content classifier + corpus) |
| 9 | Silent head-truncation fakes 100% coverage | High | Accept | Phase 2 (structure-aware cut + UNKNOWN) |
| 10 | Student PII shipped wholesale to 3 vendors | High | Accept | Phase 3 (minimization, light) |
| 11 | No provider↔key binding | High | Accept | Phase 3 (per-provider regex) |
| 12 | Timeout+retry with no numbers | High | Accept | Phase 3 (concrete values) |
| 13 | Export happy-path only (cancel/overwrite/traversal) | High | Accept | Phase 3 (export hygiene) |
| 14 | Hour estimates have no breakdown basis | Medium | Accept | plan.md (T-shirt, re-estimate post-spike) |
| 15 | Eyeball tests + "or delete" escape hatch | Medium | Accept | All phases (golden fixtures) |
