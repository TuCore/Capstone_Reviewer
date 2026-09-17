# Phase 1 — Inputs, state lock, key hygiene

## Overview

- Priority: P1. Một ca đánh giá = 1 SRS + 1 Excel + 1 đăng ký (optional).
- 3 ô cứng, mỗi ô đúng 1 file. Không danh sách động, không browse thư mục:
- nhiều Excel thì không biết thuộc về SRS nào nên cấm từ UI.
- Quyết user (2026-09-13): 3 ô cứng thay danh sách động.


## Requirements

- 3 ô cứng trên UploadScreen (thêm ô đăng ký cạnh 2 ô hiện có),
- mỗi ô đúng 1 file. Nút analyze đòi đủ SRS + Excel, đăng ký thiếu vẫn chạy.

- Phiếu đăng ký **optional** (transcript:41): analyze chạy với SRS+Excel;
  có đăng ký thì prompt thêm phần bối cảnh.
- Khóa pick/browse khi đang analyze + nút Cancel; mỗi lượt chạy gắn runId,
  kết quả về sai runId thì bỏ.
- `UploadState.copyWith`: tách `clearError()`, không để lỗi cũ kẹt lại.
- Key: check định dạng ngay khi nhập (sai hãng báo liền), che khi hiển thị,
  không in key/log payload ra console, xóa sau khi chạy xong.
- Xóa dead code `lib/app/app.dart`, `lib/app/router.dart` (main.dart tự định nghĩa app).
- `test/widget_test.dart` viết lại theo UploadScreen thật, cấm xóa cho xong.

## Related Code Files

- Modify: `lib/features/upload/presentation/upload_controller.dart`
- Modify: `lib/features/upload/presentation/upload_screen.dart`
- Modify: `lib/main.dart`; delete: `lib/app/app.dart`, `lib/app/router.dart`
- Rewrite: `test/widget_test.dart`

## Success Criteria

- SRS+Excel chạy được không cần đăng ký; đủ 3 file thì báo cáo có phần bối cảnh.
- Đổi file giữa lúc analyze không làm lệch kết quả; Cancel dừng thật.
- `flutter analyze` sạch, `flutter test` pass với test viết lại.
