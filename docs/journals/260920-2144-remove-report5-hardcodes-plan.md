# Remove Report5 Hardcodes Plan

---
date: 2026-09-20
type: planning
plan: plans/260920-2144-remove-report5-hardcodes/plan.md
branch: feature/deterministic-verifier
---

## Context

Integrity UI emitted repeated `broken-sheet-link` findings for ordinary feature names. Investigation showed the generic review pipeline embeds facts from the Report5/BIM sample across deterministic rules, AI prompts, controller Markdown, UI assumptions, and Excel export.

## What Happened

- Confirmed quoted feature names came from `row[2]`; the dangerous hardcode was the assumption that every third cell in `Test Cases` is a sheet name.
- Audited fixture fallbacks including 320/338/267/53/71, M01-M10/M03/M04, fixed 2026 dates, technologies, project metadata, percentages, and recommendations.
- Found prompt-budget truncation can feed partial records into whole-workbook counts.
- Found empty/unsupported documents and empty finding lists can appear as successful checks.
- Wrote three-phase implementation plan and ran three-persona adversarial review.

## Decisions

- Do not attempt universal document parsing.
- Unsupported or ambiguous input returns explicit unavailable/partial state; never guesses.
- Whole-workbook totals require complete extraction.
- Every cross-check rule returns a typed outcome and source-bound evidence.
- Remove Report5 assumptions from deterministic rules, AI prompts, report composition, UI, Markdown/PDF, and Excel.
- One canonical projection owns percentages, differences, and statuses across all outputs.
- Preserve current dirty-worktree user changes; implementation owns only its hunks.

## Implementation & Verification

- **Phase 1 (Evidence Contract)**:
  - Tạo `WorkbookSnapshot`, `WorkbookSheet`, `WorkbookRow`, `WorkbookCell` giữ nguyên tọa độ gốc và kiểu cell từ package `excel`.
  - Tạo `cross_check_models.dart` với `ExtractionAvailability`, `SourceEvidence`, `MetricValue<T>`, `RuleOutcome<T>`, `CanonicalPresentationProjection`.
  - Tách prompt truncation khỏi deterministic record set trong `excel_service.dart`.
  - Cập nhật `heading_docx.dart` trả availability chuẩn (`EMPTY_DOCUMENT`, `PROMPT_BUDGET_TRUNCATED`, `complete`).

- **Phase 2 (Grounded Rules)**:
  - Xóa toàn bộ số liệu và giả định Report5 trong `cross_check_engine.dart` (320, 338, 267, 53, 71, M04 BIM Viewer, PostgreSQL, Azure SQL, Viettel Cloud, ngày tháng 8/2026, rule M08/M09).
  - Sửa lỗi đọc sai sheet trong mục lục: chỉ kiểm tra link sheet khi có cột Tên Sheet rõ ràng; không lấy cứng cột 3 (`row[2]`).
  - Xóa seed Report5 do developer viết trong prompt template `ai_service.dart`.

- **Phase 3 (Consumers & Regressions)**:
  - Tạo `ReviewReportComposer` sinh Markdown báo cáo động từ `RegistrationContext` và kết quả cross-check thực tế.
  - Cập nhật `UploadController`, `ExcelExportService` dùng chung nguồn dữ liệu canonical và ngăn chặn formula injection (`TextCellValue`).
  - Xóa các test pass ảo trong `extraction_golden_test.dart`.
  - Cập nhật UI widgets (`overview_tab.dart`, `reconciliation_tab.dart`) và `ReviewBundle`.
  - Toàn bộ 80 tests trong test suite pass 100%. `flutter analyze` 0 error/0 warning.
