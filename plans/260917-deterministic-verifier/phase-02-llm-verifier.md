# Phase 2: LLM-as-a-Verifier Integration (Status: Completed)
## Mục tiêu
Loại bỏ hoàn toàn hiện tượng AI bịa đặt / ảo giác bằng kiến trúc hai pha: Generator (sinh giả thuyết) và Verifier (thẩm định nhị phân TRUE/FALSE).

## Các bước thực hiện
1. **Pass 1 (Generator)**:
   - Input: Chỉ truyền Use Cases chức năng từ SRS và danh sách Test Cases tóm tắt.
   - Nhiệm vụ: Đề xuất danh sách tối đa 5–7 nghi vấn về lỗ hổng kiểm thử (Unhappy path, Boundary test, WIP isolation rule).
   - Output định dạng JSON: `{"findings": [{"id": "1", "claim": "...", "module": "M03"}]}`.
2. **Pass 2 (Verifier - Thẩm định nhị phân)**:
   - Input: Từng `claim` từ Pass 1 + Trích đoạn tài liệu gốc liên quan.
   - Prompt Verifier:
     > *"Bạn là chuyên gia kiểm định dữ liệu độc lập. Dựa vào tài liệu gốc, nhận định sau ĐÚNG hay SAI? Trả lời JSON: is_verified (true/false) và quote (trích dẫn nguyên văn bằng chứng)."*
   - Output định dạng JSON: `{"verdicts": [{"id": "1", "is_verified": true, "quote": "..."}, {"id": "2", "is_verified": false}]}`.
3. **Bộ lọc phía Code (Gatekeeper)**:
   - Chỉ giữ lại các nhận định có `is_verified == true` VÀ trích dẫn tồn tại thực sự trong văn bản gốc.
   - Loại bỏ 100% các nhận định bị Verifier từ chối.

## Verification
- Test chạy lặp 5 lần trên cùng bộ file mẫu -> Số lượng nhận định định tính giữ lại ổn định, không bịa quote.

## Completion Details
- **Status**: Completed
- **Completion Date**: 2026-09-17
- **Implementation**: Generator (Pass 1) + Binary Verifier (Pass 2) loop implemented with pure Dart gatekeeper filtering unverified claims and hallucinations.
- **Verification**: Multi-iteration unit & integration tests pass with stable assertions.
