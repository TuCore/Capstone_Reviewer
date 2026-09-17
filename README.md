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
  - **Cổng dung lượng trước khi parse**: **<10MB** parse thẳng; **10–60MB** vẫn một lần isolate (hiện status, chưa stream); **>60MB** từ chối kèm lý do. Không đẩy chuỗi >10MB qua isolate.
- **Tài liệu SRS (Đặc tả)**:
  - Hỗ trợ **.pdf**
  - Hỗ trợ **.docx**: parse Heading1–4 qua `archive` + `xml` (không dùng `syncfusion_flutter_docx`)
  - **Từ chối .doc** cũ và file đội lốt (đuôi docx nhưng ruột khác)
- **Tài liệu Test Cases**:
  - Hỗ trợ **.xlsx** (package `excel`); nhận diện sheet theo nội dung, liệt kê **sheet bỏ qua**
  - **Từ chối .xls** (OLE) lúc extract
- **Cắt ngắn theo cấu trúc**: module nằm ngoài phần đọc được ghi **UNKNOWN**; % coverage chỉ tính trên phần đã đọc.

### 3. Giao diện tải lên
- 3 ô cứng: **Excel test case**, **SRS**, **phiếu đăng ký (không bắt buộc)**. Analyze khi đủ SRS + Excel + key đúng hãng.
- Đang chạy: khóa chọn file, nút **HỦY** (bỏ kết quả lượt cũ, xóa key).
- Key: che, báo sai hãng ngay, không log plaintext, xóa sau khi chạy.

### 4. Review và xuất file
- Hard check (trùng, trống, UnitTest) trước AI. % phủ do **code đếm**.
- Prompt 1 pass, khối tagged `<<SRS>>`. Quote không có trong file bị loại.
- **Xuất Excel** (Save As) là chuẩn nộp. PDF là bản đọc phụ (heading 3 + bảng). Hủy Save As không báo lỗi.

---
## 🏛️ Kiến trúc 4 Tầng & Cơ chế LLM-as-a-Verifier (Đảm bảo 100% Nhất quán)

Để giải quyết triệt để vấn đề ảo giác (hallucination), bịa số liệu, và đảm bảo **chạy 100 lần kết quả vẫn đồng nhất 100%**, hệ thống áp dụng kiến trúc 4 tầng kết hợp giữa **Deterministic Code Engine** và **LLM-as-a-Verifier**:

```
[ĐẦU VÀO: Word Report/SRS + Excel TestReport + Phiếu đăng ký (tùy chọn)]
                                 │
                                 ▼
┌────────────────────────────────────────────────────────────────────────┐
│ TẦNG 1: DETERMINISTIC CODE ENGINE (Chạy bằng Code thuần - 0.01 giây)   │
│ 1. Đối chiếu số liệu 3 bên (Cross-Check Metrics):                       │
│    - Đếm thực tế trong Excel M01-M10 vs Số liệu Word (5.2) vs Thống kê.│
│    - Bắt độ lệch test case (ví dụ 320 vs 338), ca Fail bị che giấu.    │
│ 2. Quét lỗi copy-paste & mâu thuẫn nội bộ Excel:                       │
│    - Bắt trùng ID liên sheet (ví dụ TC-NOT-UI-05..07 ở cả M07 & M08).  │
│    - Bắt mâu thuẫn kết quả Pass/Fail trên cùng một ID.                 │
│    - Bắt dán nhầm mô tả requirement giữa các module.                   │
│ 3. Soi môi trường & Tiến độ:                                           │
│    - Lệch Database (PostgreSQL/Supabase vs Azure SQL vs Viettel Cloud).│
│    - Lệch hạn chót phê duyệt (10/08) vs Ngày test thực tế (21/08).     │
└────────────────────────────────┬───────────────────────────────────────┘
                                 │ (Chốt xong 100% sự thật số học)
                                 ▼
┌────────────────────────────────────────────────────────────────────────┐
│ TẦNG 2: GENERATOR (AI Pass 1 - Sinh giả thuyết định tính)              │
│ - Chỉ đọc phần Use Case chức năng trong SRS và các ca test.            │
│ - Sinh 5 nhận định về ca test còn thiếu: Negative test, Boundary,      │
│   và vi phạm logic nghiệp vụ (WIP isolation, Published zone).          │
└────────────────────────────────┬───────────────────────────────────────┘
                                 │ (Danh sách nhận định sơ bộ)
                                 ▼
┌────────────────────────────────────────────────────────────────────────┐
│ TẦNG 3: LLM-AS-A-VERIFIER (AI Pass 2 - Thẩm định nhị phân TRUE/FALSE)  │
│ - Hoạt động độc lập, nhận từng nhận định của Tầng 2.                   │
│ - Kiểm tra đối chiếu với văn bản gốc:                                  │
│     * Nhận định có bằng chứng câu chữ thật -> Trả về TRUE (Giữ lại).   │
│     * Nhận định ảo giác / phỏng đoán        -> Trả về FALSE (Loại bỏ). │
└────────────────────────────────┬───────────────────────────────────────┘
                                 │ (Chỉ giữ lại các nhận định đúng 100%)
                                 ▼
┌────────────────────────────────────────────────────────────────────────┐
│ TẦNG 4: REPORT EXPORTERS (XUẤT BÁO CÁO 4 PHẦN CHUẨN MỰC)               │
│ - Phần 1: Bìa & Thông tin hành chính, công cụ, môi trường test.        │
│ - Phần 2: Bảng Đối chiếu số liệu 3 nguồn & Tính nhất quán (Từ Tầng 1). │
│ - Phần 3: Bảng kê lỗi kỹ thuật Test Case & Trùng ID nội bộ (Từ Tầng 1).│
│ - Phần 4: Đề xuất kịch bản test còn thiếu cần bổ sung (Đã qua Tầng 3). │
│                                                                        │
│ Hỗ trợ 2 định dạng:                                                    │
│   + File Excel (.xlsx): 4 sheet chuyên nghiệp, có style & bảng biểu.   │
│   + File PDF (.pdf): Báo cáo in ấn A4 chuẩn mực cho hội đồng.          │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Luồng Hoạt Động (End-to-End Workflow)

1. **Nạp Dữ Liệu (Inputs)**:
   - Chọn AI Provider (Gemini / Claude / ChatGPT) và nhập API Key.
   - Nạp file **Test Report (.xlsx)** (bắt buộc, hỗ trợ các sheet `M01`–`M10`, tự động loại bỏ sheet mục lục/bìa, chặn file UnitTest `F01_`).
   - Nạp file **SRS/Report (.docx/.pdf)** (bắt buộc).
   - Nạp file **Phiếu đăng ký (.docx/.pdf)** (tùy chọn, bổ sung bối cảnh ban đầu).

2. **Trích Xuất & Kiểm Tra Cứng (Isolates Background)**:
   - `ExcelService`: Bóc tách toàn bộ test case chi tiết từ các sheet module.
   - `DocumentService`: Chỉ trích xuất phần Use Cases / Functional Requirements, loại bỏ phần râu ria (Database, Kiến trúc).
   - `CrossCheckEngine`: So khớp số liệu, phát hiện trùng ID, lệch môi trường và lệch tiến độ.

3. **Đánh Giá Hai Pha (Generator & Verifier Loop)**:
   - **Pha 1 (Generator)**: Phân tích nghiệp vụ và đề xuất 5 lỗ hổng kiểm thử.
   - **Pha 2 (Verifier)**: Đóng vai thẩm phán nhị phân, kiểm tra chéo bằng chứng gốc và loại bỏ hoàn toàn nhận định không có căn cứ.

4. **Xuất Kết Quả Đa Định Dạng**:
   - Người dùng xem trực tiếp trên ứng dụng (`ReviewScreen`).
   - Bấm **"Xuất Excel"** nhận file `capstone-review.xlsx`.
   - Bấm **"Xuất PDF"** nhận file `capstone-review.pdf`.

---

## 🛠️ Công nghệ & Kiến trúc (Tech Stack)

- **Framework**: Flutter (Windows Desktop)
- **Ngôn ngữ**: Dart
- **State Management**: `flutter_riverpod`
- **File & Data Handling**:
  - `file_picker` (Native File Dialog & Picker)
  - `excel` (Parse .xlsx)
  - `archive` + `xml` (Parse .docx Heading1–4)
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
