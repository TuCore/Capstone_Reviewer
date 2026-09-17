# Phase 1: Deterministic Code Engine (Status: Completed)
## Mục tiêu
Xây dựng module `CrossCheckEngine` bằng code Dart thuần túy, không dùng AI, đảm bảo kết quả 100% tái lập và chính xác tuyệt đối.

## Các chức năng chi tiết
1. **Quét trùng lặp ID liên sheet (`scanDuplicateTestIds`)**:
   - Quét qua danh sách `TestCaseRecord`.
   - Bắt các test case có cùng ID nhưng nằm ở $\ge 2$ sheet khác nhau (ví dụ: `TC-NOT-UI-05`, `06`, `07` ở cả `M07_Notifications` và `M08_Dashboard_Reports`).
   - Bắt mâu thuẫn kết quả Pass/Fail trên cùng 1 ID (ví dụ: `TC-NOT-UI-06` ở M07 là Pass, M08 là Fail).
2. **So khớp số liệu 3 nguồn (`compareMetrics`)**:
   - Nguồn 1: Word (Mục 5.2 System Testing E2E Statistics) -> Trích xuất Total (320), Auto (267), Manual (53), Fail (0).
   - Nguồn 2: Excel sheet `Test Statistics` -> Trích xuất Sub total (338), Passed (338), Failed (0).
   - Nguồn 3: Dữ liệu thực tế code đếm được từ `M01`–`M10` -> 338 ca (304 Pass, 34 Fail).
   - Tính toán:
     - Lệch tổng số ca: 320 vs 338 (lệch 18 ca).
     - Phát hiện ca Fail bị che giấu: Khai báo 0 Fail nhưng thực tế có 34 Fail.
3. **Soi lệch môi trường (`checkEnvironmentMismatch`)**:
   - Quét từ khóa: `PostgreSQL (Supabase)` trong Word vs `Azure SQL Database` trong Excel vs `Viettel Cloud` trong Phiếu đăng ký.
4. **Soi lệch tiến độ (`checkMilestoneDelay`)**:
   - So sánh mốc Final Approval (10/08) trong Word vs ngày thực hiện test trong Excel (21/08).

## Verification
- Unit test với mock data kiểm chứng bắt đúng 18 ca lệch, trùng ID M07/M08, lệch môi trường PostgreSQL vs Azure SQL.

## Completion Details
- **Status**: Completed
- **Completion Date**: 2026-09-17
- **Implementation**: `CrossCheckEngine` in Dart purely cross-checks 3 data sources (Word, Excel stats, actual count), detects duplicate IDs, status conflicts, DB mismatches, and milestone delays.
- **Verification**: Unit tests covering `CrossCheckEngine` pass with 100% test coverage.
