import '../../features/review/review_bundle.dart';

class ReviewReportComposer {
  const ReviewReportComposer._();

  static String compose(ReviewBundle bundle, {String? excelPreamble, String? docPreamble}) {
    final buf = StringBuffer();
    buf.writeln('# BÁO CÁO ĐÁNH GIÁ ĐỒ ÁN CAPSTONE: SRS - TEST REPORT\n');

    // PHẦN 1: THÔNG TIN BÌA & THIẾT LẬP MÔI TRƯỜNG
    buf.writeln('## PHẦN 1: THÔNG TIN BÌA & THIẾT LẬP MÔI TRƯỜNG');
    final info = bundle.projectInfo;
    final reg = bundle.registrationContext;
    final topic = (info != null && info.topic.isNotEmpty)
        ? info.topic
        : ((reg != null && reg.topic.isNotEmpty) ? reg.topic : 'Chưa xác định');
    buf.writeln('- **Tên đề tài:** $topic');

    final desc = (info != null && info.description.isNotEmpty)
        ? info.description
        : reg?.description;
    if (desc != null && desc.isNotEmpty) {
      buf.writeln('- **Mô tả đề tài:** $desc');
    }

    if (info != null && info.techStack.isNotEmpty) {
      buf.writeln('- **Công nghệ nhận diện (AI Tech Stack):** ${info.techStack.join(", ")}');
    }

    final techFindings = bundle.verifiedFindings.where((f) =>
        f.axis.toLowerCase().contains('tech') ||
        f.targetRule.toLowerCase().contains('tech'));
    if (techFindings.isNotEmpty) {
      buf.writeln('- **Môi trường & CSDL (Phát hiện từ AI Trục 1 - Tech Mismatch):**');
      for (final f in techFindings) {
        buf.writeln('  - **[${f.module}]** ${f.claim}');
        buf.writeln('    - *Bằng chứng trích dẫn:* "${f.quote}"');
      }
    } else {
      buf.writeln('- **Môi trường & CSDL:** Nhất quán hoặc chưa có khai báo đối chiếu.');
    }
    if (excelPreamble != null && excelPreamble.isNotEmpty) {
      buf.writeln(excelPreamble);
    }
    if (docPreamble != null && docPreamble.isNotEmpty) {
      buf.writeln(docPreamble);
    }

    // PHẦN 2: ĐỐI CHIẾU DỮ LIỆU ĐỘC LẬP
    final crossCheck = bundle.crossCheck;
    if (crossCheck != null) {
      buf.writeln('\n${crossCheck.toMarkdown()}');
    }

    // PHẦN 3: ĐỘ PHỦ USE CASE
    buf.writeln('\n${bundle.stats.toMarkdown()}');

    // PHẦN 4: CHI TIẾT LỖI VI PHẠM QUY CHUẨN
    if (bundle.checks.isNotEmpty) {
      buf.writeln('\n## PHẦN 4: CHI TIẾT LỖI VI PHẠM QUY CHUẨN (HARD CHECKS)');
      for (final c in bundle.checks) {
        buf.writeln('- **[${c.code}]** ${c.message}');
      }
    }

    // PHẦN 5: KHUYẾN NGHỊ & KỊCH BẢN BỔ SUNG
    buf.writeln('\n## PHẦN 5: KỊCH BẢN KIỂM THỬ BỔ SUNG & KHUYẾN NGHỊ HỘI ĐỒNG');
    final recommendations = generateRecommendations(bundle);
    if (recommendations.isNotEmpty) {
      buf.writeln('### Các khuyến nghị quan trọng trước khi ra hội đồng:');
      for (var i = 0; i < recommendations.length; i++) {
        buf.writeln('${i + 1}. ${recommendations[i]}');
      }
      buf.writeln();
    }

    if (bundle.verifiedFindings.isNotEmpty) {
      buf.writeln('### Phát hiện ngữ nghĩa 6 trục đã qua LLM Verifier & Code Gatekeeper:');
      for (final vf in bundle.verifiedFindings) {
        buf.writeln(vf.toMarkdown());
      }
      buf.writeln();
    }

    return buf.toString();
  }

  static List<String> generateRecommendations(ReviewBundle bundle) {
    final recs = <String>[];
    final crossCheck = bundle.crossCheck;
    if (crossCheck != null) {
      final metrics = crossCheck.metricsComparison;
      if (metrics.concealedFails.isAvailable && metrics.concealedFails.value! > 0) {
        recs.add('**Khắc phục ca FAILED:** Có ${metrics.actualFailed.value ?? 0} ca kiểm thử thực tế bị FAILED. Cần rà soát và khắc phục lỗi trước khi ra hội đồng.');
      }
      if (metrics.totalDiscrepancy.isAvailable && metrics.totalDiscrepancy.value != 0) {
        recs.add('**Đồng nhất số liệu tổng:** Lệch ${metrics.totalDiscrepancy.value} ca giữa SRS (${metrics.wordTotal.value ?? 0} ca) và Excel (${metrics.actualTotal.value ?? 0} ca). Cần cập nhật số liệu thống nhất giữa các tài liệu.');
      }
      final hasTechFindings = bundle.verifiedFindings.any((f) =>
          f.axis.toLowerCase().contains('tech') ||
          f.targetRule.toLowerCase().contains('tech'));
      if (crossCheck.environmentMismatches.isNotEmpty || hasTechFindings) {
        recs.add('**Thống nhất môi trường & CSDL:** Phát hiện mâu thuẫn thông tin môi trường / công nghệ giữa các tài liệu. Cần chuẩn hóa cấu hình triển khai.');
      }
      if (crossCheck.duplicateIds.isNotEmpty) {
        recs.add('**Xử lý trùng lặp Test Case ID:** Có ${crossCheck.duplicateIds.length} ca trùng ID giữa các sheet. Cần gán mã định danh duy nhất cho mỗi ca kiểm thử.');
      }
    }

    if (recs.isEmpty) {
      recs.add('**Rà soát độ phủ kiểm thử:** Tiếp tục bổ sung các ca kiểm thử cho các kịch bản biên (Edge Cases) và ngoại lệ (Unhappy Paths).');
    }

    return recs;
  }
}
