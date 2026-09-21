---
title: "LLM-First Semantic Review & Mechanical Dart Foundation"
description: "Chuyển toàn bộ việc bắt lỗi ngữ nghĩa (công nghệ, phạm vi, copy-paste, chính tả, logic nghiệp vụ) sang LLM tổng quát; Dart chỉ giữ bản lề cơ học (đếm số, trích xuất raw text, quote guard)."
status: completed
priority: P1
effort: 8h
branch: feature/deterministic-verifier
tags: [refactor, architecture, ai-review]
blockedBy: []
blocks: []
created: 2026-09-20
---

# LLM-First Semantic Review & Mechanical Dart Foundation

## 1. Bối cảnh & Vấn đề kiến trúc cũ
- **Vấn đề:** Code Dart đang cố gắng làm việc của LLM (dùng regex bắt tĩnh `database:`, `# heading` để tìm Use Case, đếm từ để chấm điểm diễn đạt).
- **Hậu quả:** 
  - Đổi template tài liệu là regex vỡ: Bỏ sót lệch CSDL/Cloud (`Environment: Vercel, Azure SQL` vs `PostgreSQL`), đếm nhầm 5 use case từ tiêu đề chương Word, lấy nhầm cột `Round 1` thay vì `Round 3` dẫn đến báo sai 34 ca FAILED.
  - Càng vá regex càng đẻ ra bug, không bao giờ tổng quát được cho mọi đồ án (Web, Mobile, AI, IoT...).

---

## 2. Kiến trúc mới: Tách bạch rõ 2 tầng

```mermaid
flowchart TD
    subgraph INPUT["3 NGUỒN TÀI LIỆU NGUYÊN BẢN"]
        A[Word / PDF: SRS & Đặc tả]
        B[Excel: Test Report / Test Cases]
        C[Word / PDF / Plain: Phiếu đăng ký đề tài]
    end

    subgraph DART["TẦNG 1: DART MECHANICAL FOUNDATION (Cơ học, 0% đoán chữ)"]
        D1[Excel Parser: Đọc toàn bộ rows, lấy đúng cột Status vòng cuối]
        D2[Document Parser: Bóc text thô sạch, không cắt gọt ngữ nghĩa]
        D3[Mechanical Metrics: Đếm tổng ca thực tế, map duplicate ID]
        D4[Quote Guard / Gatekeeper: Chặn AI bịa trích dẫn]
    end

    subgraph LLM["TẦNG 2: LLM-FIRST SEMANTIC REVIEW (Ngữ nghĩa tổng quát cho mọi đồ án)"]
        E1[Trục 1: Soi chéo Tech Stack 3 nguồn: FE, BE, DB, Cloud, Security]
        E2[Trục 2: Soi phạm vi & Độ phủ: Chức năng SRS nào bị bỏ quên 0 test case]
        E3[Trục 3: Soi Actor & Phân quyền: Quyền hạn SRS vs Expected Result]
        E4[Trục 4: Soi lỗi Copy-Paste: Dán nhầm requirement giữa các sheet]
        E5[Trục 5: Soi Logic kiểm thử: Expected Result mâu thuẫn luật nghiệp vụ]
        E6[Trục 6: Soi chất lượng viết: Mơ hồ, thiếu data, sai chính tả, format]
    end

    subgraph OUTPUT["TẦNG 3: REPORT COMPOSER & EXPORTER"]
        F1[Report Composer: Ghép số liệu cơ học + 6 trục phân tích AI]
        F2[Export PDF: Render Markdown, bảng biểu, Unicode tiếng Việt sạch]
        F3[Export Excel: Bảng tra cứu, chống injection]
    end

    INPUT --> DART
    DART -->|Raw text + Mechanical facts| LLM
    LLM -->|Verified Semantic Findings| OUTPUT
    DART -->|Mechanical counts| OUTPUT
```

---

## 3. Các Phase triển khai chi tiết

### Phase 1: Chuẩn hóa tầng trích xuất cơ học (Dart Mechanical Foundation)
1. **Sửa Header Resolver (`test_case_schema.dart`):**
   - Không dùng `putIfAbsent` gây đè cột cũ.
   - Thêm cơ chế `Latest Round Priority`: Ưu tiên `Final Status / Actual Result` $\rightarrow$ Nếu có `Round 1, Round 2, Round 3` thì tự động lấy Round có số lớn nhất (`Round 3`), bỏ qua các Round trước.
2. **Loại bỏ regex ngữ nghĩa rác trong Dart:**
   - Bỏ regex tìm `database:` cứng trong `cross_check_engine.dart`.
   - Bỏ logic bóc Use Case bằng `# heading` trong `coverage_stats.dart`. Chuyển việc đánh giá độ phủ nghiệp vụ sang LLM.
   - Giữ lại các phép đếm cơ học thuần túy: Tổng số ca trong Excel, số ca theo từng sheet, Map trùng ID kỹ thuật.

### Phase 2: Nâng cấp Prompt & Pipeline AI Tổng Quát (`ai_service.dart`)
1. **Xây dựng Prompt Review 6 Trục (Domain-Agnostic):**
   - Đưa toàn văn `<<SRS>>`, `<<TESTCASES>>`, `<<REGISTRATION>>`, `<<MECHANICAL_METRICS>>` vào prompt.
   - Yêu cầu AI duyệt đồng thời 6 trục:
     1. Mâu thuẫn Tech Stack giữa các tài liệu (bất kể công nghệ gì).
     2. Độ phủ tính năng: Tính năng có trong SRS nhưng thiếu test trong Excel.
     3. Vai trò & Phân quyền: Mâu thuẫn quyền hạn giữa SRS và Expected Result.
     4. Lỗi copy-paste: Sheet này dán nhầm requirement của sheet kia.
     5. Lỗi logic kiểm thử: Expected Result cho phép hành vi vi phạm nghiệp vụ.
     6. Chất lượng viết: Mơ hồ, thiếu data, format lộn xộn.
2. **Quote Guard & Gatekeeper:**
   - Mọi lỗi AI chỉ ra phải có quote chứng minh từ 1 trong 3 file. Code Gatekeeper kiểm tra quote thật trước khi duyệt.

### Phase 3: Hoàn thiện Báo cáo & Giao diện
1. **`review_report_composer.dart`:**
   - Ghép phần báo cáo số liệu cơ học (do Dart đếm) và 6 trục phân tích ngữ nghĩa (do AI phân tích).
2. **Cập nhật UI & Exporters:**
   - Đảm bảo hiển thị đầy đủ các phát hiện ngữ nghĩa trên UI (Tab Tổng quan, Tab Chi tiết).
   - Xuất PDF & Excel đồng bộ.

### Phase 4: Kiểm thử & Xác minh
1. Viết unit test cho `Latest Round Priority` (đảm bảo chọn đúng Round 3, không bị báo 34 fail).
2. Viết test cho prompt tổng quát và quote gatekeeper.
3. Chạy `flutter test` xác nhận toàn bộ test suite pass.
