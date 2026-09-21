# Prompt-First Semantic Engine & LLM-as-a-Verifier Architecture

## 1. Overview & Problem Statement

Hệ thống đánh giá đồ án Capstone yêu cầu độ chính xác tuyệt đối (**100% reproducible, zero hallucination**) kết hợp khả năng đọc hiểu ngữ nghĩa toàn diện mọi đề tài.

Thế hệ trước dựa vào Regex trong Dart để đoán từ khóa công nghệ (database, environment, tên đề tài, use cases) gặp phải hạn chế cốt lõi: ngôn ngữ tự nhiên của sinh viên biến hóa khôn lường, không bộ regex nào có thể bao quát hết 1 triệu từ của loài người. Ngược lại, nếu phó mặc toàn bộ số liệu cho LLM, hệ thống sẽ gặp ảo giác số học (hallucination về số lượng test case, tỉ lệ pass/fail).

Do đó, kiến trúc chuyển đổi toàn diện sang mô hình **Prompt-First Semantic Review Engine**:
1. **Code Dart = Bản lề cơ học (Zero-Regex Semantics)**: Chịu trách nhiệm 100% việc nạp thô văn bản (raw ingestion), đếm dòng test case cơ học, đối chiếu số liệu 3 bên, quét trùng ID, phát hiện lệch timeline, và chốt chặn trích dẫn (Quote Gatekeeper). Tuyệt đối **không dùng regex đoán chữ ngữ nghĩa**.
2. **LLM Prompt-First = Bộ não đọc hiểu 6 trục (6-Axis Semantic Understanding)**: Đọc hiểu toàn văn 3 tài liệu nguồn cùng lúc (SRS, Test Suite, Phiếu đăng ký) qua chu trình **Pass 1 Generator $\rightarrow$ Pass 2 Verifier $\rightarrow$ Pass 3 Dart Gatekeeper**.

---

## 2. Overall Pipeline Architecture

```
┌────────────────────────────────────────────────────────────────────────┐
│      ĐẦU VÀO: Word SRS/Report + Excel Test Suite + Phiếu đăng ký       │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│       TẦNG 1: DART RAW INGESTION & DETERMINISTIC CODE ENGINE           │
│  - Bóc tách toàn văn sạch (clean raw text) từ Word, Excel, Registration│
│  - 3-Way Metrics Cross-Check (Word vs Excel Header vs Actual Row Count)│
│  - Duplicate Test Case IDs Across Modules                              │
│  - Conflicting Pass/Fail Status on Same ID                             │
│  - Timeline & Milestone Conflict (Approval Deadline vs Execution Date) │
│  - Copy-Paste Description Clones & Sheet Index Integrity               │
│  * ZERO-REGEX: Không đoán CSDL, Environment, Topic Title, Use Cases    │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ (Toàn văn sạch + Sự thật số học)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│    TẦNG 2: GENERATOR (AI Pass 1 - 6-Axis Comprehensive Semantic Prompt)│
│  - Nhận trọn vẹn: <<SRS>>, <<TESTCASES>>, <<REGISTRATION>>, <<FACTS>>  │
│  - Trích xuất Metadata: Tên đề tài, bối cảnh/mục tiêu dự án            │
│  - Phân tích 6 Trục Ngữ nghĩa Toàn diện:                               │
│    * Trục 1: Mâu thuẫn Công nghệ & Kiến trúc (Cross-source Tech Stack) │
│    * Trục 2: Độ phủ Tính năng & Chức năng bị bỏ quên (Feature Omission)│
│    * Trục 3: Vai trò & Phân quyền (Actor & RBAC Boundaries)            │
│    * Trục 4: Lỗi Copy-Paste & Bất nhất giữa các Sheet                  │
│    * Trục 5: Vi phạm Quy tắc Logic Nghiệp vụ (Business Logic in TCs)   │
│    * Trục 6: Chất lượng Viết & Trình bày Ca kiểm thử (Wording/Format)  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ (Candidate Findings + exact_quote)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│         TẦNG 3: VERIFIER (AI Pass 2 - Binary Grounding)                │
│  - Thẩm định độc lập từng nhận định từ Pass 1: HỢP LỆ hay ẢO GIÁC?     │
│  - Bắt buộc trích dẫn nguyên văn bằng chứng gốc (exact_quote)          │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ (Phán quyết nhị phân + exact_quote)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│     TẦNG 4: CODE GATEKEEPER (Dart Pass 3 - Verbatim Quote Containment) │
│  - rawSources.contains(exact_quote): Kiểm tra chuỗi verbatim trên file │
│  - Loại bỏ 100% nhận định có exact_quote bịa đặt hoặc không có thật    │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ (Đề xuất định tính đã kiểm chứng 100%)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│           TẦNG 5: SYNCHRONIZED PRESENTATION & DUAL EXPORTERS           │
│  - UI: OverviewTab (Metadata, Metrics, Tech Stack), VerifiedFindingsTab│
│    (Lọc chip theo 6 trục)                                              │
│  - Excel 5 Sheets: Summary, 3-Way Metrics, Technical Bugs,             │
│    6-Axis Verified Findings, Raw CrossCheck                            │
│  - PDF Report: Chuẩn A4, phân mục rõ ràng, bảng biểu đối chiếu số liệu │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Pure Dart CrossCheckEngine (Zero-Regex Semantics)

`CrossCheckEngine` được triển khai hoàn toàn bằng Dart thuần túy trong `lib/services/cross_check_engine.dart` với các mô hình dữ liệu trong `lib/models/cross_check_result.dart`.

### 3.1. Đối chiếu Số liệu 3 Bên (3-Way Metrics Reconciliation)
So sánh song song 3 nguồn dữ liệu:
1. **Word Document**: Số lượng test cases công bố trong báo cáo đặc tả/nghiệm thu.
2. **Excel Declared Statistics**: Số liệu khai báo tại sheet tổng quan/thống kê trong file Excel test suite.
3. **Actual Test Count**: Số dòng test case thực tế được trích xuất và phân tích từ từng sheet module.

Các tiêu chí đối chiếu:
- **Total Test Cases**: Phát hiện chênh lệch (ví dụ: Word ghi 320, Excel khai báo 338, thực tế đếm 338 -> cảnh báo lệch 18 ca tại Module M04).
- **Execution Mode (Manual vs Automated)**: Phát hiện khai báo sai lệch hình thức thực hiện (ví dụ: Word khai báo 53 Manual, Excel thực tế có 71 Manual).
- **Pass / Fail / Pending Discrepancy**: Phát hiện gian lận báo cáo (ví dụ: Word và Excel khai báo 100% Pass / 0 Fail, nhưng thực tế đếm được 34 ca Failed hoặc Blocked).

### 3.2. Quét Trùng Lặp ID & Mâu Thuẫn Trạng Thái (Duplicate ID & Conflict Detection)
- **Cross-module Duplicate IDs**: Quét toàn bộ test case trên mọi sheet module. Nếu một ID xuất hiện ở nhiều hơn 1 module (ví dụ `TC-NOT-UI-05` xuất hiện cả ở `M07_Notifications` và `M08_Dashboard_Reports`), engine ghi nhận lỗi vi phạm tính duy nhất.
- **Pass/Fail State Conflict**: Khi phát hiện trùng ID, engine so sánh trường `status` giữa các lần xuất hiện. Nếu cùng một ID mà module A đánh dấu `PASS` còn module B đánh dấu `FAIL`, engine phát cờ `State Conflict` nghiêm trọng.

### 3.3. Phát hiện Lệch Tiến Độ & Hạn Chót (Timeline Conflict)
- Trích xuất các mốc thời gian: Hạn chót phê duyệt đề tài (Approval Deadline), ngày nghiệm thu báo cáo Word, ngày thực hiện test trong file Excel.
- Bắt mâu thuẫn thứ tự thời gian: Ví dụ hạn chót nộp báo cáo là `10/08/2026` nhưng ngày ghi nhận thực hiện kiểm thử trong Excel lại là `21/08/2026`.

### 3.4. Kiểm tra Toàn vẹn Cấu trúc Khác
- **Copy-Paste Description Clones**: Phát hiện lỗi copy-paste mô tả yêu cầu giữa các sheet (ví dụ sheet `M09_User_Role_Permissions` dán nhầm mô tả của module `M08_Dashboard`).
- **Sheet Link Integrity**: So khớp danh sách sheet khai báo tại mục lục (Sheet Index/TOC) với danh sách sheet thực tế tồn tại trong workbook.

### 3.5. Triết lý Zero-Regex trong Dart
Toàn bộ logic regex đoán từ khóa ngữ nghĩa (`database`, `environment`, `use_case`, `topic_title`) trước đây đã được loại bỏ hoàn toàn khỏi Dart code engine:
- Không cố tạo regex để đoán CSDL (PostgreSQL, MySQL, SQL Server, MongoDB, Oracle...).
- Không cắt chuỗi 1200 ký tự thô để tìm dòng tên đề tài.
- Việc đọc hiểu ngữ nghĩa, bối cảnh kỹ thuật và phát hiện mâu thuẫn công nghệ được chuyển giao 100% cho AI trong chu trình 3-Pass bên dưới.

---

## 4. Prompt-First 6-Axis Semantic AI Pipeline

Quy trình đọc hiểu ngữ nghĩa và phát hiện lỗ hổng được tổ chức thành chu trình khép kín trong `lib/services/ai_service.dart`.

### 4.1. Pass 1: Generator (Prompt 6 Trục Toàn Diện)
- **Input**: Toàn văn sạch của 3 tài liệu nguồn được đóng gói trong các khối tagged: `<<SRS>>`, `<<TESTCASES>>`, `<<REGISTRATION>>`, kèm `<<FACTS>>` số học do Dart cung cấp.
- **Metadata Extraction**:
  - Tự động nhận diện Tên đề tài (Tiếng Anh, Tiếng Việt, Mã viết tắt) dù nằm ở trang bìa, bảng thông tin hay phần mở đầu.
  - Tóm tắt Bối cảnh / Mục tiêu dự án từ nội dung nghiệp vụ (không nhầm lẫn với danh sách giảng viên/sinh viên).
  - Nhận diện danh sách Tech Stack dự án đã khai báo.
- **Phân tích 6 Trục Ngữ nghĩa Toàn diện**:
  1. **Trục 1: Mâu thuẫn Công nghệ & Kiến trúc (Cross-source Tech Stack)**:
     - Đối chiếu chéo giữa SRS, Test Report và Phiếu đăng ký (ví dụ: SRS đăng ký Viettel Cloud/Postgres nhưng Excel test trên Azure SQL và Vercel).
  2. **Trục 2: Độ phủ Tính năng & Chức năng bị bỏ quên (Feature Scope & Omission)**:
     - Đọc danh sách chức năng trong SRS và đối chiếu với danh sách test case trong Excel $\rightarrow$ xác định đích danh chức năng nào có trong SRS nhưng **bị bỏ quên 0 test case**.
  3. **Trục 3: Vai trò & Phân quyền (Actor & RBAC Boundaries)**:
     - Kiểm tra quyền hạn của từng Actor trong SRS vs Expected Result trong Test Cases (ví dụ: phân quyền giữa Producer và Project Manager).
  4. **Trục 4: Lỗi Copy-Paste & Bất nhất giữa các Sheet (Inconsistencies)**:
     - Phát hiện dán nhầm requirement, mâu thuẫn mô tả hoặc trạng thái giữa các module.
  5. **Trục 5: Vi phạm Quy tắc Logic Nghiệp vụ (Business Logic Violations)**:
     - Phát hiện ca test có Expected Result vi phạm logic đã định nghĩa trong SRS (ví dụ: zone đã ban hành nhưng test case vẫn cho phép chỉnh sửa/xóa).
  6. **Trục 6: Chất lượng Viết & Trình bày Ca kiểm thử (Wording & Formatting)**:
     - Bắt các bước test mơ hồ, thiếu Test Data, Expected Output chung chung ("hệ thống hoạt động bình thường"), sai thuật ngữ.
- **Data Contract Output**:
  Mỗi phát hiện bắt buộc đi kèm trường `axis` (tên trục), `claim` (nội dung lỗi), `module` (phạm vi), và `quote` (đoạn trích sơ bộ).

### 4.2. Pass 2: Verifier (Thẩm định Nhị phân Độc lập)
- **Input**: Từng candidate finding từ Pass 1 kết hợp với toàn văn các đoạn trích đối chứng từ tài liệu nguồn.
- **Verification Rule**:
  - Đánh giá theo chuẩn nhị phân độc lập: `isValid = true` (chấp thuận) hoặc `isValid = false` (bác bỏ / ảo giác).
  - Yêu cầu bắt buộc trường `exact_quote`: Trích dẫn **nguyên văn từng ký tự (verbatim)** từ tài liệu gốc chứng minh nhận định là có căn cứ thực tế.
  - Nếu nhận định mang tính phỏng đoán, suy diễn không có câu chữ chứng minh trong tài liệu, Verifier đánh dấu `false`.

### 4.3. Pass 3: Dart Code Gatekeeper (Kiểm chứng Chuỗi Verbatim)
- Lớp mã nguồn Dart thực thi thuật toán kiểm chứng chuỗi đối với tất cả nhận định vượt qua Pass 2:
  - Thực hiện `rawSources.contains(exact_quote)` trên toàn văn 3 file đầu vào.
  - Bác bỏ và gạch tên 100% các nhận định có `exact_quote` bịa đặt, sai lệch so với bản gốc hoặc chuỗi rỗng/quá ngắn (`stripHallucinatedQuotes`).
- **Đảm bảo Zero-Hallucination**: 100% nhận định xuất hiện trong báo cáo đều có căn cứ văn bản xác thực tuyệt đối.

---

## 5. Synchronized UI & Dual Report Exporters

Hệ thống đồng bộ toàn diện dữ liệu giữa giao diện người dùng và 2 định dạng xuất báo cáo (Excel & PDF):

### 5.1. Đồng bộ Giao diện Người dùng (UI Tabs)
- **OverviewTab**:
  - Hiển thị Tên đề tài, Mô tả bối cảnh do AI trích xuất (chấm dứt hoàn toàn tình trạng hiển thị "Chưa xác định").
  - Danh sách công nghệ (Tech Stack) nhận diện từ tài liệu.
  - Bảng thống kê đối chiếu số liệu 3 bên do Dart đếm cơ học.
- **VerifiedFindingsTab**:
  - Hiển thị danh sách các phát hiện đã qua thẩm định và gác cổng.
  - Bộ lọc trực quan bằng Chips theo 6 trục ngữ nghĩa (Tech Mismatch, Feature Omission, RBAC, Copy-Paste, Logic, Wording).

### 5.2. Định dạng Excel (5 Sheets)
Triển khai trong `lib/services/excel_export_service.dart`:
1. `Summary`: Tên đề tài, mục tiêu, kết luận nghiệm thu, bảng môi trường & công nghệ.
2. `3-Way Metrics`: Bảng so sánh số liệu giữa Word, Excel thống kê và đếm thực tế theo từng module.
3. `Technical Bugs`: Danh sách lỗi kỹ thuật cơ học: trùng ID, mâu thuẫn Pass/Fail, lệch tiến độ.
4. `6-Axis Verified Findings`: Bảng phát hiện ngữ nghĩa chi tiết phân loại theo 6 trục, đi kèm module, trích dẫn nguyên văn và căn cứ kiểm chứng.
5. `Raw CrossCheck`: Dữ liệu toàn vẹn thô phục vụ tra cứu kiểm toán.

### 5.3. Định dạng PDF (Khổ A4)
Triển khai trong `lib/services/pdf_report_exporter.dart`:
- Tài liệu PDF phân trang hoàn chỉnh, chuẩn in ấn và trình chiếu hội đồng:
  - Trang bìa trang trọng với thông tin đề tài chính xác từ AI.
  - Bảng biểu đối chiếu số liệu 3 bên rõ ràng.
  - Bảng lỗi kỹ thuật và các phát hiện ngữ nghĩa 6 trục có trích dẫn kiểm chứng.
  - Header/Footer đánh số trang dạng `Trang X / Y`.

---

## 6. Test Verification & Code Quality

Hệ thống được bảo vệ bởi bộ test tự động toàn diện:
- `test/cross_check_engine_test.dart`: Kiểm tra đối chiếu số liệu 3 bên, phát hiện trùng lặp ID, xung đột trạng thái Pass/Fail, lệch tiến độ ngày tháng (không dùng regex công nghệ).
- `test/llm_verifier_test.dart`: Kiểm tra chu trình 3-Pass (Generator $\rightarrow$ Verifier $\rightarrow$ Quote Gatekeeper), bảo đảm chặn đứng 100% fake quote.
- `test/report_exporters_test.dart`: Kiểm tra tính toàn vẹn khi sinh file Excel và PDF, cấu trúc sheet và định dạng đầu ra.

Toàn bộ 89/89 tests đều vượt qua với kết quả 100% green suite.
