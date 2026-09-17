# 2026-09-13 Phase 2 extraction

Spike: Report3.docx 25.1MB có Heading1–4 thật (H1=5, H2=6, H3=42, H4=121). Parse `document.xml` + `styles.xml` bằng `archive` + `xml`. Không thêm `syncfusion_flutter_docx`. Numbering fallback khi không có style.

Ship: size gate <10 / 10–60 / >60MB; reject .doc và zip đội lốt; classifier sheet theo cột; synonym VI-EN + normalize mã; cắt cấu trúc + UNKNOWN; isolate nhận path, output cap 400k chars.

Test 21/21. Review 7.8/10, 0 critical. User approve, warning giữ: “chia đoạn” chỉ là status; .xls reject lúc extract; peek = full parse; cắt Excel O(n²); chưa cap uncompressed zip.

Phase 1 và 3 vẫn pending.
