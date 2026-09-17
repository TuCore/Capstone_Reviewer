# Phase 3 — Review depth and dual export

## Overview

- Priority: P1. Mặc định 1 pass nhanh; pass 2 là tùy chọn nâng sâu.
  Format export chưa chốt với thầy (transcript:33 nhiễu) → giữ cả Excel + PDF.

## Requirements

- Lớp check cứng trước AI: dòng trùng nguyên văn, ô rỗng, thiếu cột chuẩn,
- tên gọi Anh-Việt không thống nhất, sheet sai loại file (UnitTest).
- File mẫu thực tế không có mã UC/TC → định danh bằng cặp
- (module/section + câu mô tả đã chuẩn hóa), không đòi mã.
- Đối chiếu ngược output AI: câu trích dẫn nào không có nguyên văn trong file
- thì đánh dấu BỊA, loại khỏi báo cáo.

- Đối chiếu số liệu báo cáo tổng (Report7 chương Testing: tổng số ca, % pass)
- với số đếm thực từ file Excel — lệch là lỗi riêng. Cần Report7 làm input
- optional thứ 4 (chưa chốt, hỏi user trước khi thêm ô).

- Phân loại ca thiếu theo taxonomy của template SWT301-Q3: Happy case,
- Unhappy case, Required field, Exception case. Status chỉ nhận
- PASSED/FAILED/Not Run/Untested/N/A.
- Số liệu do code tính, cấm AI đặt: % phủ = UC có ca phủ / tổng UC đã đọc,
- đếm lỗi theo severity, thống kê pass/fail/untested. AI chỉ viết nhận xét
- kèm mã trích dẫn — mọi con số trong báo cáo đều truy được về phép đếm.
- Chấm chất lượng diễn đạt từng ô test case: thiếu, mơ hồ, trộn nhiều ý,
- kết luận thiếu bằng chứng, đạt. Kèm danh sách từ cấm mơ hồ tiếng Việt
- ("đúng", "tốt", "hợp lệ" mà không có tiêu chí).



- AI chỉ 2 prompt, mỗi prompt chỉ mang phần việc của nó + tên luật cần dùng
- (không nhét 18 file reference): prompt 1 trích UC từng mục SRS,
- prompt 2 soi thiếu ca từng module. Reference nằm trên đĩa để dev tra,
- không nằm trong prompt.


- Prompt mặc định **1 pass**: trích use case + matrix phủ + lỗi sai logic +
  nhận xét cách diễn đạt + severity + % coverage, một lần gọi.
  Pass 2 (soi sâu từng use case) là cờ tùy chọn; kết quả pass 1 gắn với mã băm
  bộ file — đổi file thì chạy lại từ đầu, không dùng kết quả cũ.
- Nội dung file SV bọc trong khối đánh dấu, dặn AI coi đó là dữ liệu
  (không phải mệnh lệnh), kiểm tra báo cáo trả về đúng khung matrix.
- Phiếu đăng ký chỉ trích trường cần (tên đề tài, mô tả), bỏ tên/MSSV/email
  trước khi gửi AI.
- Check key đúng hãng trước khi gọi (sai thì chặn, không gửi nhầm sang hãng khác).
- Timeout + retry có số: kết nối 10s, đọc 90–180s mỗi pass, retry tối đa 2 lần
  chỉ khi lỗi 429/5xx/timeout (backoff tăng dần), lỗi sai key/dữ liệu cấm retry.
- Lỗi hiện ra tiếng Việt gọn (mạng/xác thực/hạn mức/parse), log chi tiết
  đã che key; xóa các `print` hiện tại.
- Excel (.xlsx) qua hộp Save-As: bấm Cancel thì thôi (không crash),
  ghi đè hỏi trước, ghi file tạm rồi đổi tên (không còn file 0KB),
  tên file làm sạch ký tự lạ, chữ tiếng Việt mở đúng.
- PDF giữ làm option phụ: render được bảng + heading 3 cấp; sửa README
  (đang ghi Save dialog nhưng code tự ghi Downloads).

## Related Code Files

- Modify: `lib/core/services/ai_service.dart`
- Create: `lib/core/services/excel_export_service.dart`
- Create: `lib/core/services/hard_checks.dart` (lớp check cứng)
- Modify: `lib/core/services/pdf_export_service.dart`
- Modify: `lib/features/review/presentation/review_screen.dart`
- Modify: `README.md`

## Success Criteria

- Report3 + TestReport mẫu: ra matrix phủ 10 module + % + severity,
  test case sai logic mẫu bị bắt.
- File .xlsx mở đúng tiếng Việt; Cancel/overwrite/file 0KB đều có test.
- Hỏi thầy 1 câu chốt định dạng chính (Excel/PDF/cả hai) trước khi đánh bóng UI.
