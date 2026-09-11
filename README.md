# Capstone Reviewer 🚀

**Capstone Reviewer** là một ứng dụng Desktop (Windows) được xây dựng bằng Flutter, tích hợp sức mạnh của các mô hình Trí tuệ Nhân tạo (Generative AI) nhằm mục đích tự động hóa quá trình đánh giá (review) tài liệu đồ án (Capstone Project). 

Ứng dụng giúp đối chiếu chéo giữa **Tài liệu Đặc tả Yêu cầu (SRS)** và **Kịch bản Kiểm thử (Test Cases)** để phát hiện các lỗ hổng, tính toán độ bao phủ yêu cầu (Requirement Coverage) và đưa ra các khuyến nghị hành động cho đội ngũ phát triển.

---

## ✨ Các tính năng nổi bật đã hoàn thiện

### 1. 🧠 Tích hợp Đa nền tảng AI (Multi-AI Integration)
- Hỗ trợ linh hoạt chuyển đổi giữa 3 mô hình ngôn ngữ lớn mạnh nhất hiện nay:
  - **Google Gemini**
  - **OpenAI ChatGPT**
  - **Anthropic Claude**
- Kiến trúc mở (Service-Oriented Architecture), cho phép người dùng nhập trực tiếp API Key của nền tảng tương ứng để sử dụng mà không bị phụ thuộc vào một nhà cung cấp duy nhất.

### 2. 📂 Xử lý Đa định dạng Tài liệu
Xây dựng các module trích xuất văn bản mạnh mẽ chạy ngầm để không làm ảnh hưởng đến hiệu suất UI:
- **Tài liệu SRS (Đặc tả)**: Trích xuất nội dung từ các định dạng văn bản phổ biến:
  - Hỗ trợ **.pdf** 
  - Hỗ trợ **.docx**, **.doc** (Tích hợp `docx_to_text`)
- **Tài liệu Test Cases**: Trích xuất dữ liệu dạng bảng biểu từ Excel:
  - Hỗ trợ **.xlsx**, **.xls** (Tích hợp package `excel`)

### 3. 🎨 Giao diện Người dùng Hiện đại & Tối ưu
- **Quản lý trạng thái thông minh**: Sử dụng kiến trúc `Riverpod` giúp đồng bộ UI tức thì khi có thay đổi (chọn file, xóa file, đổi AI Provider, v.v).
- **Trải nghiệm trực quan**: 
  - Thiết kế UI dạng Drop-zone rõ ràng để người dùng dễ dàng theo dõi file đã chọn.
  - Hỗ trợ nút xóa file linh hoạt với cơ chế dọn dẹp bộ nhớ an toàn (tránh treo trạng thái).
  - Kết quả trả về được hiển thị dưới định dạng **Markdown** trực tiếp trên ứng dụng, hỗ trợ đánh dấu (highlight), bôi đậm, list danh sách đẹp mắt.

### 4. 📄 Tính năng Xuất Báo Cáo PDF Tiếng Việt Toàn Diện
- **Hiển thị tiếng Việt (UTF-8) chuẩn xác**: Tích hợp trực tiếp bộ font `Roboto` (Regular & Bold) chuẩn TrueType (TTF) vào lõi thư viện PDF. Xử lý triệt để lỗi "ô vuông" (missing glyphs) khi xuất các văn bản có dấu tiếng Việt.
- **Hỗ trợ định dạng tự động**: Thuật toán bóc tách Markdown để tự động chuyển đổi các thẻ Heading (`#`, `##`), danh sách (`-`), và văn bản thường thành các style PDF tương ứng.
- **Cơ chế lưu file An toàn (Safe File Export)**: 
  - Loại bỏ lỗi sập ứng dụng (`Null check operator`) do giới hạn quyền hệ thống trên Windows.
  - Triển khai **hộp thoại Lưu file (Save As Dialog)** bản địa thông qua `file_picker`, trao toàn quyền cho người dùng chọn thư mục lưu trữ và đặt tên file báo cáo.

---

## 🛠️ Công nghệ & Kiến trúc (Tech Stack)

- **Framework**: Flutter (Windows Desktop)
- **Ngôn ngữ**: Dart
- **State Management**: `flutter_riverpod`
- **File & Data Handling**:
  - `file_picker` (Native File Dialog & Picker)
  - `excel` (Parse file spreadsheet)
  - `docx_to_text` (Parse Microsoft Word doc/docx)
  - `pdf` & `syncfusion_flutter_pdf` (Generate & Export PDF)
- **AI Packages**:
  - `google_generative_ai` (Gemini SDK)
  - `http` (Custom API Call cho ChatGPT & Claude)
- **UI Components**: `flutter_markdown`

---

## 🚀 Hướng dẫn Chạy ứng dụng (Dành cho Developer)

**1. Khôi phục thư viện:**
```bash
flutter pub get
```

**2. Chạy ứng dụng trên môi trường Windows (Chế độ Release để tối ưu hiệu năng):**
```bash
flutter run -d windows --release
```

**3. Build file .exe để phân phối:**
```bash
flutter build windows
```
*(File thực thi sẽ nằm tại: `build\windows\x64\runner\Release\capstone_reviewer.exe`)*

---
*Báo cáo được tổng hợp để theo dõi tiến độ hoàn thiện của dự án Capstone Reviewer.*
