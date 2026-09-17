---
title: "Deterministic Engine & LLM-as-a-Verifier Architecture"
description: "Ensure 100% reproducible, zero-hallucination reviews: Code Engine cross-checks numbers/integrity, LLM-as-a-Verifier checks qualitative gaps, dual export 4-part PDF & Excel"
status: completed
lastUpdated: 2026-09-17
branch: main
tags: [feature, ai, verification, export]
blockedBy: []
blocks: []
created: 2026-09-17
---

# Deterministic Engine & LLM-as-a-Verifier Architecture

## Overview

Người dùng yêu cầu hệ thống đánh giá đồ án Capstone phải đảm bảo **tính nhất quán tuyệt đối (chạy 100 lần kết quả vẫn đồng nhất, không bịp bợm, không ảo giác số liệu)**.
Kiến trúc giải quyết bằng 2 trụ cột:
1. **Deterministic Code Engine**: Đảm nhận 100% việc so khớp số học (Word vs Excel vs Thống kê), quét trùng ID liên sheet, phát hiện mâu thuẫn Pass/Fail, bắt lệch môi trường & hạn chót.
2. **LLM-as-a-Verifier (Generator & Verifier Loop)**: AI Pass 1 (Generator) đề xuất 5 nghi vấn, AI Pass 2 (Verifier) thẩm định nhị phân `TRUE/FALSE` dựa trên bằng chứng trích dẫn văn bản gốc.

## Phases

| Phase | Name | Status | Description |
|-------|------|--------|-------------|
| 1 | [Deterministic Code Engine](./phase-01-code-engine.md) | Completed | CrossCheckEngine thuần Dart: so khớp số liệu 3 nguồn, trùng ID, lệch database, lệch ngày |
| 2 | [LLM-as-a-Verifier](./phase-02-llm-verifier.md) | Completed | Tách luồng AI thành Generator (đề xuất) + Verifier (thẩm định nhị phân TRUE/FALSE) |
| 3 | [Dual Export 4 Parts](./phase-03-report-exporters.md) | Completed | Bố cục lại PDF & Excel thành 4 phần chuẩn mực (Bìa, Số liệu, Kỹ thuật, Đề xuất) |

## Architecture Diagram

```
[ĐẦU VÀO: Word Report + Excel TestReport + Phiếu đăng ký (tùy chọn)]
                           │
                           ▼
┌───────────────────────────────────────────────────────────┐
│ TẦNG 1: DETERMINISTIC CODE ENGINE (Chạy bằng Code thuần) │
│ - Độc lập hoàn toàn, không dùng AI, chạy trong 0.01 giây.  │
│ 1. So khớp số liệu 3 nguồn: Word 320 vs Excel 338.        │
│ 2. Quét trùng ID: TC-NOT-UI-05..07 ở M07 & M08.           │
│ 3. Quét mâu thuẫn trạng thái: Cùng ID nhưng M07 Pass, M08 Fail.│
│ 4. Soi lệch môi trường (PostgreSQL vs Azure SQL).         │
│ 5. Soi lệch tiến độ (Hạn chót 10/08 vs Test 21/08).       │
└──────────────────────────┬────────────────────────────────┘
                           │ (Chốt 100% sự thật số học)
                           ▼
┌───────────────────────────────────────────────────────────┐
│ TẦNG 2: GENERATOR (AI Pass 1 - Sinh giả thuyết định tính)│
│ - Chỉ đọc Use Case chức năng trong SRS và các ca test.   │
│ - Sinh 5 nhận định về ca test còn thiếu (Negative, Edge). │
└──────────────────────────┬────────────────────────────────┘
                           │ (Danh sách 5 nghi vấn dạng JSON)
                           ▼
┌───────────────────────────────────────────────────────────┐
│ TẦNG 3: LLM-AS-A-VERIFIER (AI Pass 2 - Thẩm định nhị phân)│
│ - Nhận từng nghi vấn từ Tầng 2, soi với tài liệu gốc:    │
│   * TRUE  ──► Giữ lại, trích dẫn nguyên văn.              │
│   * FALSE ──► Ảo giác / Không căn cứ ──► GẠCH BỎ NGAY.    │
└──────────────────────────┬────────────────────────────────┘
                           │ (Chỉ còn các nhận định ĐÚNG 100%)
                           ▼
┌───────────────────────────────────────────────────────────┐
│ TẦNG 4: REPORT EXPORTERS (XUẤT PDF & EXCEL 4 PHẦN)        │
│ - Phần 1: Bìa & Thông tin hành chính, công cụ test.       │
│ - Phần 2: Bảng Đối chiếu số liệu 3 nguồn (In từ Tầng 1).  │
│ - Phần 3: Bảng lỗi kỹ thuật Test Case & Trùng ID (Tầng 1).│
│ - Phần 4: Đề xuất bổ sung ca test còn thiếu (Đã qua Tầng 3)│
└───────────────────────────────────────────────────────────┘
```

---

## Chi Tiết Toàn Bộ Danh Mục Kiểm Tra (Comprehensive Checklist)

### I. Kiểm tra Hành chính & Trang bìa (Cover & Setup)
- [x] Quét sót placeholder mẫu: `[Project Name]`, `Author Name`, `Company`, `Your University`.
- [x] So khớp ngày bìa (23/07/2026) vs ngày chốt bản v1.0 trong lịch sử sửa đổi (21/08/2026).
- [x] Kiểm tra thông tin bắt buộc: Tên đề tài, mã dự án, GVHD, nhóm sinh viên, học kỳ.
- [x] Kiểm tra chính tả / thuật ngữ tên đề tài và mô tả chung.

### II. Đối chiếu Số liệu 3 Bên (3-Way Consistency Check - Pure Dart Engine)
- [x] Tổng số ca: Word (320) vs Excel Statistics (338) vs Đếm thực tế (338) -> Bắt lệch 18 ca (M04).
- [x] Phân loại Manual vs Automated: Word (53 Manual) vs Excel thực tế (71 Manual).
- [x] Bắt gian lận số ca Fail: Word và Excel khai báo 0 Fail (100% Pass) vs Đếm thật có 34 ca FAILED.

### III. Lỗi Copy-Paste & Toàn vẹn Dữ liệu Excel (Internal Excel Integrity)
- [x] Quét trùng lặp Test Case ID giữa 2 module: `TC-NOT-UI-05`, `06`, `07` ở cả `M07_Notifications` lẫn `M08_Dashboard_Reports`.
- [x] Bắt mâu thuẫn kết quả Pass/Fail trên cùng ID: `TC-NOT-UI-06` ở M07 Pass, nhưng ở M08 Fail.
- [x] Bắt dán nhầm mô tả yêu cầu: Sheet `M09_User_Role_Permissions` dán nhầm mô tả Dashboard của M08.
- [x] Bắt gãy liên kết sheet: Kiểm tra cột `Sheet Name` trong mục lục `Test Cases` với danh sách sheet thực tế.

### IV. Lệch Môi trường & Tiến độ (Environment & Timeline Conflict)
- [x] Lệch Database: Word ghi `PostgreSQL (Supabase)` vs Excel ghi `Azure SQL` vs Đăng ký ghi `Viettel Cloud`.
- [x] Lệch tiến độ: Hạn chót phê duyệt (10/08/2026) vs Ngày thực hiện test trong Excel (21/08/2026).
- [x] Lệch phạm vi: Word chỉ nêu 6 module vs Excel test 10 module (có M06-M10).

### V. Đối chiếu Logic Nghiệp vụ & Bảo mật (Business Logic & Security Conflicts)
- [x] WIP Isolation: PM can thiệp xóa/sửa file trong WIP (`TC-DOC-ACT-001..006`).
- [x] Published Integrity: Tài liệu Published bị xóa/đổi tên (`TC-DOC-ACT-015..017`, `087..089`).
- [x] Thiếu kiểm thử chữ ký số giả mạo (tamper warning).

### VI. Kịch bản Kiểm thử Bổ sung (Missing Scenarios - LLM-as-a-Verifier)
- [x] Ca kiểm thử lỗi / nhập sai (Negative Tests).
- [x] Ca kiểm thử dữ liệu biên (Boundary Tests).
- [x] Ca kiểm thử ngoại lệ hệ thống (Exception / Timeout / Network drops).

### VII. Xuất Báo cáo 4 Phần Chuẩn Mực (Excel & PDF Dual Export)
- [x] Phần 1: Bìa & Môi trường kiểm thử.
- [x] Phần 2: Bảng Đối chiếu số liệu 3 bên & Tính nhất quán (In từ Code Engine).
- [x] Phần 3: Bảng lỗi kỹ thuật Test Case & Trùng ID (In từ Code Engine).
- [x] Phần 4: Đề xuất kịch bản test bổ sung (Đã qua Verifier thẩm định nhị phân).

---

## Completion Summary
- **Completion Date**: 2026-09-17
- **Status**: Completed (100%)
- **Test Results**: 51/51 unit & integration tests passing (`flutter test`).
  - CrossCheckEngine: 3-way metric cross-checking, duplicate ID detection, environment and timeline conflict tests passing.
  - LLM-as-a-Verifier: Generator & binary Verifier pipeline tests with mock prompts & gatekeeping passing.
  - Exporters: 4-part PDF and Excel export generation tests passing.
