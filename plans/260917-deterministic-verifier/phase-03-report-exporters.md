# Phase 3: Dual Report Exporters (PDF & Excel) (Status: Completed)
## Mục tiêu
Tái cấu trúc báo cáo xuất ra thành 4 phần chuyên nghiệp, tách bạch giữa sự thật số học (in từ Code Engine) và nhận xét định tính (đã qua Verifier lọc).

## Các phần báo cáo
1. **Phần 1: Bìa & Môi trường kiểm thử**:
   - Tên đề tài, mã dự án, nhóm sinh viên, ngày nộp (từ sheet `Cover`).
   - Môi trường test, công cụ test (từ sheet `Test Cases` mục lục).
   - Kiểm tra kỹ thuật bìa (placeholder sót lại, lỗi liên kết sheet).
2. **Phần 2: Bảng Đối chiếu số liệu & Tính nhất quán**:
   - Bảng so sánh 3 nguồn: Word vs Excel vs Dữ liệu đếm thật.
   - Chỉ rõ số ca lệch (18 ca), ca Fail bị che giấu (34 ca).
   - Bảng đối chiếu Môi trường (PostgreSQL vs Azure SQL) và Tiến độ (Hạn chót 10/08 vs Test 21/08).
3. **Phần 3: Danh sách lỗi vi phạm kỹ thuật**:
   - Bảng kê trùng lặp ID liên sheet (`TC-NOT-UI-05..07` ở cả M07 và M08).
   - Ca mâu thuẫn trạng thái Pass/Fail trên cùng 1 ID.
   - Các lỗi hard check (thiếu bước, thiếu kết quả mong đợi, từ ngữ mơ hồ).
4. **Phần 4: Kịch bản kiểm thử bổ sung (Đã qua Verifier)**:
   - Các ca test quan trọng còn thiếu (Negative, Exception, Boundary).
   - Khuyến nghị 3 hành động cần làm trước khi ra hội đồng.

## Định dạng xuất
- **File Excel (`capstone-review.xlsx`)**: 4 sheet tương ứng có style màu sắc, độ rộng cột chuẩn, kẻ bảng.
- **File PDF (`capstone-review.pdf`)**: Báo cáo tài liệu A4 in ấn chuẩn mực, trình bày theo các bảng biểu rõ ràng.

## Completion Details
- **Status**: Completed
- **Completion Date**: 2026-09-17
- **Implementation**: 4-part PDF & Excel export implementation completed with distinct sections for cover, cross-check metrics, technical defects, and verified recommendations.
- **Verification**: Exporter unit tests pass with valid PDF & Excel binary output validation.
