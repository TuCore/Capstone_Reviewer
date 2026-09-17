# Deterministic Engine & LLM-as-a-Verifier Architecture

## 1. Overview & Problem Statement

Hệ thống đánh giá đồ án Capstone yêu cầu độ chính xác và tính nhất quán tuyệt đối (**100% reproducible, zero hallucination**). Nếu giao toàn bộ việc đối chiếu số liệu hoặc kiểm tra toàn vẹn tài liệu cho LLM, hệ thống sẽ gặp các vấn đề cố hữu:
- Ảo giác số liệu (hallucination về số lượng test case, tỉ lệ pass/fail).
- Kết quả thiếu nhất quán qua các lượt chạy khác nhau.
- Bỏ sót các lỗi dữ liệu vi mô (trùng test case ID giữa các module, mâu thuẫn trạng thái Pass/Fail, lệch ngày tháng hay lệch cấu hình database).

Để giải quyết triệt để, kiến trúc chia tách nhiệm vụ thành **2 trụ cột cốt lõi**:
1. **Deterministic Code Engine (Pure Dart)**: Đảm nhận 100% kiểm tra toán học, tính toàn vẹn dữ liệu, quét xung đột, phát hiện lệch môi trường/tiến độ với tốc độ mili-giây, không phụ thuộc AI.
2. **LLM-as-a-Verifier (2-Pass Verification + Code Gatekeeper)**: Ứng dụng mô hình Generator-Verifier kết hợp rào chắn mã nguồn để phân tích định tính các ca test thiếu sót, loại bỏ triệt để các nhận định vô căn cứ.

---

## 2. Overall Pipeline Architecture

```
┌────────────────────────────────────────────────────────────────────────┐
│               ĐẦU VÀO (Word SRS/Report, Excel Test Suite)              │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│             TẦNG 1: PURE DART DETERMINISTIC CODE ENGINE                │
│  - 3-Way Metrics Cross-Check (Word vs Excel Header vs Actual Row Count) │
│  - Duplicate Test Case IDs Across Modules                              │
│  - Conflicting Pass/Fail Status on Same ID                             │
│  - Environment & Tech Stack Mismatch (e.g., PostgreSQL vs Azure SQL)   │
│  - Timeline & Milestone Conflict (Approval Deadline vs Execution Date) │
│  - Placeholder & Copy-Paste Detection                                  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ (Bộ dữ liệu sự thật số học)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│             TẦNG 2: GENERATOR (LLM Pass 1 - Hypothesis Generation)     │
│  - Phân tích Use Cases / SRS và danh sách ca test hiện có              │
│  - Sinh tối đa 5 đề xuất kịch bản còn thiếu (Negative, Edge, Security) │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ (Candidate Missing Scenarios)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│             TẦNG 3: VERIFIER (LLM Pass 2 - Binary Grounding)           │
│  - Thẩm định độc lập từng ứng viên: TRUE (hợp lệ) hoặc FALSE (bác bỏ)  │
│  - Buộc trích dẫn trực tiếp (exact quote) từ ngữ cảnh tài liệu gốc     │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│             TẦNG 4: CODE GATEKEEPER (Strict Deterministic Filter)      │
│  - Kiểm tra xâu trích dẫn (quote matching) trên tài liệu gốc           │
│  - Bác bỏ nếu trích dẫn bịa đặt hoặc thiếu căn cứ                      │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ (Đề xuất định tính đã kiểm chứng)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│             TẦNG 5: 4-PART DUAL REPORT EXPORTERS                       │
│  - Excel 5 Sheets: Summary, 3-Way Metrics, Technical Bugs, Missing     │
│    Scenarios, Raw CrossCheck                                           │
│  - PDF A4 4 Parts: Cover, 3-Way Metrics Table, Technical Findings,     │
│    Verified Recommendations                                            │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Pure Dart CrossCheckEngine

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

### 3.3. Phát hiện Lệch Môi Trường & Cơ Sở Dữ Liệu (Environment Mismatch)
- Đối chiếu cấu hình kỹ thuật giữa Word SRS, Excel Test Setup và thông tin đăng ký đề tài.
- Bắt các từ khóa xung đột công nghệ: ví dụ Word ghi `PostgreSQL (Supabase)` trong khi Excel ghi `Azure SQL`, hoặc backend ghi `NodeJS` nhưng test environment lại cấu hình `Spring Boot`.

### 3.4. Phát hiện Lệch Tiến Độ & Hạn Chót (Timeline Conflict)
- Trích xuất các mốc thời gian: Hạn chót phê duyệt đề tài (Approval Deadline), ngày nghiệm thu báo cáo Word, ngày thực hiện test trong file Excel.
- Bắt mâu thuẫn thứ tự thời gian: Ví dụ hạn chót nộp báo cáo là `10/08/2026` nhưng ngày ghi nhận thực hiện kiểm thử trong Excel lại là `21/08/2026`.

### 3.5. Kiểm tra Toàn vẹn Khác
- **Copy-Paste Description Clones**: Phát hiện lỗi copy-paste mô tả yêu cầu giữa các sheet (ví dụ sheet `M09_User_Role_Permissions` dán nhầm mô tả của module `M08_Dashboard`).
- **Sheet Link Integrity**: So khớp danh sách sheet khai báo tại mục lục (Sheet Index/TOC) với danh sách sheet thực tế tồn tại trong workbook.

---

## 4. LLM-as-a-Verifier Architecture

Quy trình đánh giá định tính được tổ chức thành chu trình khép kín trong `lib/services/llm_verifier_service.dart`.

### 4.1. Pass 1: Generator (Đề xuất giả thuyết định tính)
- **Input**: Đặc tả Use Case trong SRS, danh sách test case hiện có, bối cảnh nghiệp vụ.
- **Output**: Danh sách JSON gồm tối đa 5 đề xuất kịch bản kiểm thử bị thiếu (Boundary, Negative, Security/Tamper, System Exception).
- **Prompt Guardrails**: Generator chỉ được phép nêu các giả thuyết cần thiết nhất, không bịa đặt các module không tồn tại trong tài liệu.

### 4.2. Pass 2: Verifier (Thẩm định nhị phân có đối chứng)
- **Input**: Mỗi candidate scenario từ Pass 1 kết hợp với toàn văn các đoạn trích liên quan từ tài liệu gốc.
- **Verification Rule**:
  - Đánh giá theo chuẩn nhị phân: `isValid = true` (chấp thuận) hoặc `isValid = false` (bác bỏ).
  - Yêu cầu bắt buộc trường `groundingQuote`: Trích dẫn nguyên văn bằng chứng từ tài liệu chứng minh rằng kịch bản này thực sự bắt buộc hoặc còn thiếu trong hệ thống.
  - Nếu kịch bản không có căn cứ từ tài liệu hoặc dựa trên suy đoán vô căn cứ, Verifier đánh dấu `false`.

### 4.3. Code Gatekeeper (Lớp chốt chặn bằng mã nguồn)
- Sau khi LLM Pass 2 trả về kết quả `true`, lớp mã nguồn Dart chạy thuật toán kiểm tra đối khớp chuỗi (`quote matching`):
  - Tìm kiếm `groundingQuote` trong văn bản gốc.
  - Nếu trích dẫn không tồn tại trong tài liệu (hallucinated quote) hoặc chuỗi quá ngắn/rỗng, Code Gatekeeper lập tức hạ cờ và loại bỏ đề xuất đó khỏi báo cáo cuối cùng.
- Đảm bảo 100% các khuyến nghị lọt vào báo cáo đều có bằng chứng văn bản kiểm chứng được.

---

## 5. 4-Part Dual Report Exporters

Hệ thống xuất kết quả đánh giá đồng bộ ra 2 định dạng: Excel (`lib/services/excel_report_exporter.dart`) và PDF (`lib/services/pdf_report_exporter.dart`). Cả hai đều tuân thủ cấu trúc chuẩn 4 phần.

### 5.1. Bố cục Chuẩn 4 Phần (4-Part Standard Layout)
1. **Phần 1: Bìa & Thiết lập Môi trường (Cover & Administrative Information)**
   - Tên đề tài, mã dự án, nhóm sinh viên, giảng viên hướng dẫn, ngày đánh giá.
   - Bảng môi trường kiểm thử (hệ điều hành, database, tools, phiên bản tài liệu).
2. **Phần 2: Bảng Đối chiếu Số liệu 3 Bên (3-Way Metrics Reconciliation)**
   - So sánh trực tiếp: Word vs Excel Khai báo vs Đếm thực tế.
   - Thống kê chi tiết: Tổng số ca, Manual vs Automation, Pass/Fail/Pending, số lượng theo từng module.
   - Cảnh báo chênh lệch số học và bất thường dữ liệu.
3. **Phần 3: Bảng Lỗi Kỹ thuật Test Case (Technical Findings & Integrity Audit)**
   - Danh sách ID trùng lặp giữa các module và mâu thuẫn Pass/Fail.
   - Danh sách lỗi copy-paste mô tả, lệch tiến độ ngày tháng, lệch cấu hình công nghệ.
4. **Phần 4: Kịch bản Kiểm thử Đề xuất Bổ sung (Verified Missing Scenarios)**
   - Các kịch bản kiểm thử biên, kiểm thử lỗi, kiểm thử bảo mật đã vượt qua chu trình LLM Verifier và Code Gatekeeper.
   - Đi kèm lý do khuyến nghị và trích dẫn bằng chứng tài liệu.

### 5.2. Định dạng Excel (5 Sheets)
File Excel kết quả bao gồm 5 worksheets chi tiết:
1. `Summary`: Bìa, điểm số tổng quan, kết luận nghiệm thu và thông số môi trường.
2. `3-Way Metrics`: Bảng ma trận so sánh số liệu giữa Word, Excel thống kê và đếm thực tế theo từng module.
3. `Technical Bugs`: Bảng chi tiết toàn bộ lỗi kỹ thuật, trùng ID, mâu thuẫn kết quả Pass/Fail và lệch tiến độ/môi trường.
4. `Missing Scenarios`: Danh sách các ca kiểm thử bổ sung đã được thẩm định.
5. `Raw CrossCheck`: Dữ liệu kiểm tra toàn vẹn thô từ `CrossCheckEngine` để phục vụ audit/debug khi cần.

### 5.3. Định dạng PDF (Khổ A4)
- Tài liệu PDF phân trang hoàn chỉnh, tối ưu cho in ấn và trình chiếu hội đồng:
  - Trang bìa trang trọng với typography rõ ràng.
  - Bảng biểu có màu sắc trực quan (Pass: Xanh, Fail/Warning: Đỏ/Cam).
  - Tách trang rõ ràng giữa các phần, hỗ trợ Header/Footer đánh số trang dạng `Trang X / Y`.

---

## 6. Test Verification & Code Quality

Hệ thống được bảo vệ bởi bộ unit & integration tests toàn diện trong thư mục `test/`:
- `test/cross_check_engine_test.dart`: Kiểm tra tính chính xác của thuật toán so khớp số liệu 3 bên, phát hiện trùng lặp ID, xung đột trạng thái Pass/Fail, lệch môi trường và lệch ngày tháng.
- `test/llm_verifier_test.dart`: Kiểm tra chu trình lọc Generator -> Verifier -> Code Gatekeeper, đảm bảo quote matching loại bỏ triệt để hallucinated suggestions.
- `test/report_exporters_test.dart`: Kiểm tra tính toàn vẹn khi sinh file Excel và PDF, cấu trúc sheet và định dạng đầu ra.

Tất cả các bài test đều vượt qua 100% với thời gian thực thi tối ưu.
