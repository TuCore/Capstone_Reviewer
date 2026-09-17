# Phase 2 — Extraction spike + quality

## Overview

- Priority: P1. **Spike trước, code sau**: package hiện tại chưa chắc đọc được
  style heading — chứng minh rồi mới estimate.
> Tham khảo (không phải chuẩn đồ án): template đề thi PE môn SWT301-Q3
> gợi ý bộ cột ID | Description | Pre-Condition | Steps | Test Data |
> Expected Output | Status | Test date | Note. Chuẩn chính vẫn là file
> TestReport mẫu của thầy — cột nào lệch thì theo file thầy.



## Requirements

1. **Spike (0.5 ngày, chặn cả phase)**: chứng minh đọc được style Heading1–4
   trong docx (thêm `syncfusion_flutter_docx` hoặc parse `document.xml` tay).
   Rớt spike → chuyển yêu cầu thành đoán heading theo số thứ tự (1., 1.1, I., II.),
   estimate lại.
2. **Chặn trước khi parse, không chặn sau**: check dung lượng/số sheet/số dòng
   ngay lúc chọn file. Tầng: <10MB chạy thẳng, 10–60MB chia đoạn có tiến trình,
   >60MB từ chối kèm lý do. Không đẩy chuỗi >10MB qua isolate một lần.

3. **Nhận diện sheet theo nội dung, không theo tên**: giữ sheet có cột dạng
   mã test case + đủ dòng dữ liệu; còn lại liệt kê "sheet bỏ qua" cho user thấy.
   Kho đối chứng trong `test/fixtures/`: 3 template SWT301 + TestCaseTemplate.xls
   (giao.lang) + TestSceanrioTemplate.xlsx + 2 TestReport mẫu của thầy
   + 1 file đặt tên khác kiểu (tự bịa).



- Chuẩn hóa mã + từ đồng nghĩa Việt-Anh (đăng nhập/login, mật khẩu/password):
- SRS viết kiểu này, Excel viết kiểu khác mà cùng một việc thì vẫn ghép được.

4. **Cắt ngắn theo cấu trúc**: giữ cây heading + bảng use case + dòng test case
   đến cùng; cắt văn mô tả trước. Module nào nằm ngoài phần đọc được ghi
   `UNKNOWN`, % coverage chỉ tính trên phần đã đọc — cấm báo 100% giả.
5. `.doc` cũ và file đội lốt (đuôi docx nhưng ruột khác): loại ở tầng đọc file
   từng file một, file lỗi không kéo chết cả đợt.
6. Chuẩn bản ghi test case chung (cột bắt buộc + tên thay thế: ID/TC ID/TestCaseId)
   + chuẩn hóa mã (hoa/thường, gạch nối) + công thức % coverage ghi rõ trong file.

## Related Code Files

- Modify: `lib/core/services/excel_service.dart`
- Modify: `lib/core/services/document_service.dart`
- Modify: `lib/features/upload/presentation/upload_controller.dart`
- Test: golden JSON parse của TestReport mẫu (đúng module, đúng số dòng)

## Success Criteria

- Report3 mẫu chạy hết luồng theo tầng ở mục 2.
- Classifier đúng trên cả 3 file kho đối chứng, sheet lạ bị liệt kê chứ không nuốt bậy.
- File cắt ngắn → matrix có dòng `UNKNOWN`, không 100% giả.

## Completion

Done 2026-09-13. Spike passed: Report3 Heading1–4 via `archive` + `xml` (no
`syncfusion_flutter_docx`). Tests 21/21. Review 7.8/10, 0 critical; user
approved with warnings unfixed (chunked is label not stream; `.xls` reject at
extract).

