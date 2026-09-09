---
description: "Quy tắc chung cho Agent khi code dự án Capstone Reviewer, tránh Git conflict và tuân thủ kiến trúc."
---

# 🤖 Hướng Dẫn & Quy Tắc Dành Cho Agent (Capstone Reviewer Project)

Bạn là trợ lý AI (Agent) hỗ trợ lập trình viên (Dev 1, Dev 2 hoặc Dev 3) phát triển ứng dụng **Capstone Document Reviewer**. 
Để tránh **Git Conflict** và phá vỡ **Kiến trúc hệ thống**, bạn BẮT BUỘC PHẢI TUÂN THỦ nghiêm ngặt các quy tắc dưới đây trước khi thực hiện bất kỳ task nào.

## 1. Kiến Trúc Dự Án
- **Framework:** Flutter Desktop (100% Dart).
- **Kiến trúc:** Clean Architecture (Feature-First) kết hợp Isolates cho tác vụ nặng.
- **State Management:** Riverpod.
- **Routing:** GoRouter.

## 2. Phân Chia "Lãnh Thổ" (Tuyệt đối không lấn sân)
Mỗi Dev quản lý một thư mục riêng biệt. Khi user yêu cầu code, hãy xác định user đang đóng vai trò Dev nào và **CHỈ SỬA ĐỔI CODE TRONG THƯ MỤC CỦA DEV ĐÓ**:

*   **👨‍💻 Dev 1 (UI/UX Lead):**
    *   Thư mục: `lib/features/upload/`, `lib/app/` (routing), `lib/theme/`
    *   Trách nhiệm: Giao diện chính, Upload screen, Routing tổng, Theme (Material 3).
*   **👨‍💻 Dev 2 (Feature Dev):**
    *   Thư mục: `lib/features/history/`, `lib/features/settings/`, `lib/core/database/` (Isar DB), UI Chat.
    *   Trách nhiệm: Lịch sử chấm, Cài đặt, Local DB, Xuất PDF, Giao diện Chat.
*   **👨‍💻 Dev 3 (Logic & AI):**
    *   Thư mục: `lib/core/services/` (Gemini, Excel parser, PDF Extractor, Rule Checker)
    *   Trách nhiệm: Thuật toán bắt lỗi, trích xuất dữ liệu đa luồng (Isolate), giao tiếp với Gemini API.

**❌ QUY TẮC CẤM:** 
- Nếu bạn đang code cho Dev 1, KHÔNG ĐƯỢC tự ý sửa file trong `lib/core/services/` (của Dev 3).
- Nếu bạn đang code cho Dev 3, KHÔNG ĐƯỢC tự ý sửa file giao diện trong `lib/features/upload/`.
- File `pubspec.yaml` cần được cân nhắc kỹ trước khi thêm package mới để tránh conflict thư viện giữa các thành viên.

## 3. Giao Tiếp Giữa Các Thành Phần (Interface First)
- Dev 3 sẽ định nghĩa các **Interface** (Abstract classes) và **Model/Entity** trước (ví dụ: `IReviewService`, `ReviewResult`).
- Dev 1 và Dev 2 BẮT BUỘC phải dùng các **Mock Service** (kế thừa từ Interface) để làm UI, không chờ đợi code thuật toán AI hoàn thiện. Giữ cho UI hoàn toàn độc lập với Logic AI.

## 4. Git Workflow
- Cấm push code trực tiếp lên nhánh `develop` hoặc `main`.
- Luôn tạo nhánh riêng cho tính năng (ví dụ: `feature/devX-tên-chức-năng`).

## 5. Quy Trình Khởi Chạy Task
Mỗi khi user yêu cầu viết code:
1. Hỏi user xem họ đang đóng vai trò nào (Dev 1, Dev 2 hay Dev 3) nếu chưa rõ.
2. Kiểm tra xem các file dự định sửa có thuộc đúng "lãnh thổ" của Dev đó không.
3. Nếu task yêu cầu lấy dữ liệu từ module khác chưa hoàn thiện, hãy tạo/sử dụng Mock Data.
