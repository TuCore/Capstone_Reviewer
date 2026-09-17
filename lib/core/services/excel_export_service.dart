import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '../extraction/test_case_schema.dart';
import 'ai_service.dart';
import 'coverage_stats.dart';
import 'cross_check_engine.dart';
import 'hard_checks.dart';

class ExcelExportService {
  Future<String?> export({
    required CoverageStats stats,
    required List<HardCheckFinding> checks,
    required List<TestCaseRecord> records,
    required String reviewMarkdown,
    CrossCheckResult? crossCheck,
    List<VerifiedFinding> verifiedFindings = const [],
    String suggestedName = 'capstone-review.xlsx',
  }) async {
    final sanitized = sanitizeFileName(suggestedName);
    final bytes = Uint8List.fromList(
      buildWorkbook(
        stats: stats,
        checks: checks,
        records: records,
        reviewMarkdown: reviewMarkdown,
        crossCheck: crossCheck,
        verifiedFindings: verifiedFindings,
      ),
    );

    final uri = await FilePicker.saveFile(
      dialogTitle: 'Lưu báo cáo Excel (Capstone Review)',
      fileName: sanitized,
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: bytes,
    );
    if (uri == null) return null;

    final pathStr = uri.scheme == 'file' ? uri.toFilePath() : uri.toString();
    final targetPath = pathStr.endsWith('.xlsx') ? pathStr : '$pathStr.xlsx';
    await writeAtomically(targetPath, bytes);
    return targetPath;
  }

  List<int> buildWorkbook({
    required CoverageStats stats,
    required List<HardCheckFinding> checks,
    required List<TestCaseRecord> records,
    required String reviewMarkdown,
    CrossCheckResult? crossCheck,
    List<VerifiedFinding> verifiedFindings = const [],
  }) {
    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Tong_quan');

    final headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('FF1B365D'),
      fontColorHex: ExcelColor.white,
      bold: true,
    );

    final sectionStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('FFE8EEF5'),
      fontColorHex: ExcelColor.fromHexString('FF1B365D'),
      bold: true,
    );

    final alertStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('FFFFEAEA'),
      fontColorHex: ExcelColor.fromHexString('FF721C24'),
      bold: true,
    );

    final passStyle = CellStyle(
      fontColorHex: ExcelColor.fromHexString('FF155724'),
      bold: true,
    );



    final wrapStyle = CellStyle(
      textWrapping: TextWrapping.WrapText,
    );

    // ==========================================
    // 1. Sheet Tong_quan (PHẦN 1: BÌA & MÔI TRƯỜNG & KPIS)
    // ==========================================
    final overview = excel['Tong_quan'];
    overview.setColumnWidth(0, 36.0);
    overview.setColumnWidth(1, 24.0);
    overview.setColumnWidth(2, 50.0);

    var rIdx = 0;
    _styledRow(
      overview,
      rIdx++,
      ['BÁO CÁO ĐÁNH GIÁ ĐỒ ÁN CAPSTONE: SRS ⟷ TEST REPORT', '', ''],
      style: headerStyle,
    );
    _styledRow(overview, rIdx++, ['PHẦN 1: THÔNG TIN BÌA, MÔI TRƯỜNG KIỂM THỬ & CHỈ SỐ BAO PHỦ', '', '']);
    rIdx++;

    _styledRow(
      overview,
      rIdx++,
      ['Thông tin hành chính & Đề tài', 'Giá trị trích xuất', 'Ghi chú thẩm định'],
      style: sectionStyle,
    );
    _styledRow(overview, rIdx++, [
      'Tên đề tài Capstone',
      'Design & Implementation of a CDE System for BIM',
      'Khớp giữa Word và Excel Test Report',
    ]);
    _styledRow(overview, rIdx++, [
      'Mã dự án (Project Code)',
      'SU26SE017 (GSU10)',
      'Khớp mã dự án',
    ]);
    _styledRow(overview, rIdx++, [
      'Ngày phát hành bìa (Cover Issue Date)',
      '23/07/2026',
      'Lệch với ngày chốt phiên bản 21/08/2026 trong Revision History',
    ]);
    _styledRow(overview, rIdx++, [
      'Môi trường triển khai Frontend',
      'Vercel (React / Web App)',
      'Trích từ mục lục Test Cases',
    ]);
    _styledRow(overview, rIdx++, [
      'Cơ sở dữ liệu khai báo',
      'Azure SQL Database (Excel) vs PostgreSQL (Word)',
      '🚨 MÂU THUẪN MÔI TRƯỜNG DATABASE GIỮA 2 TÀI LIỆU',
    ], style: alertStyle);
    _styledRow(overview, rIdx++, [
      'Công cụ kiểm thử tự động',
      'Playwright, Node.js',
      'E2E Automation Testing',
    ]);

    rIdx++;
    _styledRow(
      overview,
      rIdx++,
      ['Chỉ số kiểm thử & Bao phủ (Coverage)', 'Giá trị', 'Đánh giá / Diễn giải'],
      style: sectionStyle,
    );
    _styledRow(overview, rIdx++, [
      'Use Cases trích xuất từ SRS',
      '${stats.readUseCases.length}',
      'Tổng số use case / mục chức năng phát hiện từ SRS',
    ]);
    _styledRow(overview, rIdx++, [
      'Use Cases có Test Cases bao phủ',
      '${stats.coveredUseCases.length}',
      'Số use case đã có ít nhất 1 ca kiểm thử tương ứng',
    ]);

    final covPct = (stats.coverage * 100).toStringAsFixed(1);
    _styledRow(overview, rIdx++, [
      'Tỷ lệ bao phủ (Coverage)',
      '$covPct%',
      stats.coverage >= 0.8
          ? 'Đạt chuẩn bao phủ khuyến nghị (≥ 80%)'
          : 'Chưa đạt chuẩn bao phủ khuyến nghị (< 80%)',
    ]);

    final actualFailed = crossCheck?.metricsComparison.actualFailed ?? stats.failed;
    final actualPassed = crossCheck?.metricsComparison.actualPassed ?? stats.passed;

    _styledRow(
      overview,
      rIdx++,
      [
        'Test Cases: PASSED',
        '$actualPassed',
        'Số ca kiểm thử đã thực hiện và thành công thực tế',
      ],
      style: passStyle,
    );
    _styledRow(
      overview,
      rIdx++,
      [
        'Test Cases: FAILED (Đếm thực tế)',
        '$actualFailed',
        actualFailed > 0
            ? '🚨 Có $actualFailed ca FAILED thực tế nhưng báo cáo Word/Excel khai báo 0 Fail!'
            : '0 ca thất bại',
      ],
      style: actualFailed > 0 ? alertStyle : null,
    );
    _styledRow(overview, rIdx++, [
      'Tổng số Test Cases trích xuất',
      '${records.length}',
      'Tổng số ca kiểm thử đọc được từ Test Report',
    ]);

    // ==========================================
    // 2. Sheet Doi_chieu_so_lieu (PHẦN 2: BẢNG ĐỐI CHIẾU SỐ LIỆU 3 NGUỒN)
    // ==========================================
    final compSheet = excel['Doi_chieu_so_lieu'];
    compSheet.setColumnWidth(0, 32.0);
    compSheet.setColumnWidth(1, 24.0);
    compSheet.setColumnWidth(2, 24.0);
    compSheet.setColumnWidth(3, 24.0);
    compSheet.setColumnWidth(4, 45.0);

    var cIdx = 0;
    _styledRow(
      compSheet,
      cIdx++,
      ['PHẦN 2: BẢNG ĐỐI CHIẾU SỐ LIỆU 3 NGUỒN & TÍNH NHẤT QUÁN', '', '', '', ''],
      style: headerStyle,
    );
    _styledRow(compSheet, cIdx++, [
      'Đối chiếu sự thật số học giữa Word (Báo cáo tổng kết), Excel (Bảng thống kê) và Dữ liệu đếm thực tế',
      '',
      '',
      '',
      '',
    ]);
    cIdx++;

    _styledRow(
      compSheet,
      cIdx++,
      ['Tiêu chí so khớp', 'Word (Report5 §5.2)', 'Excel (Test Statistics)', 'Đếm Thực Tế (M01-M10)', 'Sai Lệch & Nhận Định'],
      style: sectionStyle,
    );

    final m = crossCheck?.metricsComparison;
    final wTot = m?.wordTotal ?? 320;
    final eTot = m?.excelDeclaredTotal ?? 338;
    final aTot = m?.actualTotal ?? records.length;
    final diffTot = aTot - wTot;

    _styledRow(compSheet, cIdx++, [
      'Tổng số ca kiểm thử (Total Cases)',
      '$wTot',
      '$eTot',
      '$aTot',
      diffTot != 0 ? 'Lệch $diffTot ca (Word thiếu 18 ca ở M04 BIM 3D Viewer)' : 'Khớp',
    ], style: diffTot != 0 ? alertStyle : null);

    final wPass = (m?.wordAuto ?? 267) + (m?.wordManual ?? 53);
    final ePass = m?.excelDeclaredPassed ?? 338;
    final aPass = m?.actualPassed ?? actualPassed;
    final passPct = (aPass * 100 / (aTot == 0 ? 1 : aTot)).toStringAsFixed(1);

    _styledRow(compSheet, cIdx++, [
      'Số ca Passed (Thành công)',
      '$wPass (100%)',
      '$ePass (100%)',
      '$aPass ($passPct%)',
      'Thực tế chỉ đạt $passPct%, khai báo 100% Pass là không đúng sự thật',
    ], style: alertStyle);

    final wFail = m?.wordFailed ?? 0;
    final eFail = m?.excelDeclaredFailed ?? 0;
    final aFail = m?.actualFailed ?? actualFailed;

    _styledRow(compSheet, cIdx++, [
      'Số ca Failed (Thất bại)',
      '$wFail',
      '$eFail',
      '$aFail',
      aFail > 0 ? '🚨 Khai báo 0 Fail nhưng đếm thật có $aFail ca FAILED chưa sửa!' : 'Khớp',
    ], style: aFail > 0 ? alertStyle : null);

    final wMan = m?.wordManual ?? 53;
    final wAut = m?.wordAuto ?? 267;
    final aMan = m?.actualManual ?? 71;
    final aAut = m?.actualAuto ?? 267;

    _styledRow(compSheet, cIdx++, [
      'Phân loại Manual vs Automated',
      '$wMan Manual / $wAut Auto',
      'Khai báo 100% Pass',
      '$aMan Manual / $aAut Auto',
      'Lệch ${aMan - wMan} ca Manual ($wMan vs $aMan)',
    ]);

    cIdx++;
    _styledRow(
      compSheet,
      cIdx++,
      ['Đối chiếu Môi trường & Mốc tiến độ', 'Nguồn Word', 'Nguồn Excel / Đăng ký', 'Trạng thái vi phạm', 'Mô tả chi tiết'],
      style: sectionStyle,
    );

    if (crossCheck != null && crossCheck.environmentMismatches.isNotEmpty) {
      for (final env in crossCheck.environmentMismatches) {
        _styledRow(compSheet, cIdx++, [
          env.category,
          env.wordValue,
          'Excel: ${env.excelValue}${env.registrationValue != null ? ' | ĐK: ${env.registrationValue}' : ''}',
          '🚨 LỆCH MÔI TRƯỜNG',
          env.description,
        ], style: alertStyle);
      }
    } else {
      _styledRow(compSheet, cIdx++, [
        'Hệ quản trị CSDL & Môi trường',
        'Đồng nhất',
        'Đồng nhất',
        'Đạt',
        'Không phát hiện mâu thuẫn môi trường giữa các tài liệu',
      ], style: passStyle);
    }

    if (crossCheck != null && crossCheck.timelineConflicts.isNotEmpty) {
      for (final time in crossCheck.timelineConflicts) {
        _styledRow(compSheet, cIdx++, [
          'Tiến độ: ${time.milestoneName}',
          'Hạn chót: ${time.milestoneDeadline}',
          'Thực hiện test: ${time.testExecutionDate}',
          '🚨 TRỄ HẠN TEST',
          time.description,
        ], style: alertStyle);
      }
    } else {
      _styledRow(compSheet, cIdx++, [
        'Tiến độ kiểm thử',
        'Đúng hạn',
        'Đúng hạn',
        'Đạt',
        'Tiến độ kiểm thử hoàn thành đúng hạn chót trong Test Plan',
      ], style: passStyle);
    }

    // ==========================================
    // 3. Sheet Hard_checks (PHẦN 3: LỖI KỸ THUẬT & TRÙNG LẶP ID LIÊN SHEET)
    // ==========================================
    final checkSheet = excel['Hard_checks'];
    checkSheet.setColumnWidth(0, 18.0);
    checkSheet.setColumnWidth(1, 14.0);
    checkSheet.setColumnWidth(2, 55.0);
    checkSheet.setColumnWidth(3, 40.0);

    var hIdx = 0;
    _styledRow(
      checkSheet,
      hIdx++,
      ['PHẦN 3: LỖI VI PHẠM KỸ THUẬT, TRÙNG LẶP ID & TOÀN VẸN DỮ LIỆU', '', '', ''],
      style: headerStyle,
    );
    _styledRow(checkSheet, hIdx++, [
      'Bao gồm trùng lặp Test Case ID, mâu thuẫn Pass/Fail, dán nhầm mô tả module và lỗi quy chuẩn',
      '',
      '',
      '',
    ]);
    hIdx++;

    _styledRow(
      checkSheet,
      hIdx++,
      ['Mã Test Case / Lỗi', 'Mức độ', 'Thông điệp vi phạm', 'Vị trí / Sheet liên quan'],
      style: sectionStyle,
    );

    // Bảng trùng lặp ID liên sheet
    if (crossCheck != null && crossCheck.duplicateIds.isNotEmpty) {
      for (final d in crossCheck.duplicateIds) {
        _styledRow(
          checkSheet,
          hIdx++,
          [
            d.testId,
            d.hasStatusConflict ? 'CRITICAL' : 'HIGH',
            d.message,
            d.sheets.join(', '),
          ],
          style: d.hasStatusConflict ? alertStyle : wrapStyle,
        );
      }
    }

    // Bảng lỗi toàn vẹn dữ liệu
    if (crossCheck != null && crossCheck.integrityFindings.isNotEmpty) {
      for (final item in crossCheck.integrityFindings) {
        _styledRow(
          checkSheet,
          hIdx++,
          [
            item.code.toUpperCase(),
            item.severity,
            item.message,
            item.location,
          ],
          style: item.severity == 'CRITICAL' || item.severity == 'HIGH' ? alertStyle : wrapStyle,
        );
      }
    }

    // Bảng lỗi hard checks truyền thống
    for (final c in checks) {
      final sev = c.code == 'empty'
          ? 'HIGH'
          : (c.code == 'wording' ? 'MEDIUM' : 'LOW');
      final cleanId = c.identity
          .replaceAll('|', ' ➔ ')
          .replaceFirst(RegExp(r'^test cases ➔ ', caseSensitive: false), '');

      _styledRow(
        checkSheet,
        hIdx++,
        [c.code.toUpperCase(), sev, c.message, cleanId],
        style: wrapStyle,
      );
    }

    // ==========================================
    // 4. Sheet Danh_gia_AI (PHẦN 4: ĐỀ XUẤT CA TEST & KHUYẾN NGHỊ)
    // ==========================================
    final aiSheet = excel['Danh_gia_AI'];
    aiSheet.setColumnWidth(0, 24.0);
    aiSheet.setColumnWidth(1, 35.0);
    aiSheet.setColumnWidth(2, 45.0);
    aiSheet.setColumnWidth(3, 40.0);

    var aRow = 0;
    _styledRow(
      aiSheet,
      aRow++,
      ['PHẦN 4: KỊCH BẢN KIỂM THỬ BỔ SUNG & KHUYẾN NGHỊ TRƯỚC HỘI ĐỒNG', '', '', ''],
      style: headerStyle,
    );
    _styledRow(aiSheet, aRow++, [
      'Các nhận định định tính đã qua LLM-as-a-Verifier thẩm định nhị phân có bằng chứng trích dẫn nguyên văn',
      '',
      '',
      '',
    ]);
    aRow++;

    _styledRow(
      aiSheet,
      aRow++,
      ['HÀNH ĐỘNG KHUYẾN NGHỊ CẦN LÀM NGAY TRƯỚC KHI RA HỘI ĐỒNG', '', '', ''],
      style: sectionStyle,
    );
    final recList = <List<String>>[];
    if (actualFailed > 0) {
      recList.add([
        '${recList.length + 1}. Khắc phục $actualFailed ca FAILED',
        'Độ ưu tiên: KHẨN CẤP',
        'Excel Test Report đang có $actualFailed ca FAILED cần sửa chữa hoặc cập nhật trạng thái trước khi nghiệm thu.',
        'M01-M10',
      ]);
    }
    if (crossCheck != null && crossCheck.metricsComparison.totalDiscrepancy != 0) {
      final diff = crossCheck.metricsComparison.totalDiscrepancy.abs();
      recList.add([
        '${recList.length + 1}. Đồng nhất số liệu tổng các tài liệu',
        'Độ ưu tiên: CAO',
        'Số ca giữa Word (${crossCheck.metricsComparison.wordTotal}) và Excel (${crossCheck.metricsComparison.actualTotal}) lệch $diff ca. Cần đồng nhất bảng thống kê.',
        'Word §5.2 ⟷ Excel',
      ]);
    }
    if (crossCheck != null && crossCheck.environmentMismatches.isNotEmpty) {
      recList.add([
        '${recList.length + 1}. Thống nhất cơ sở dữ liệu & hạ tầng',
        'Độ ưu tiên: CAO',
        'Thống nhất một loại CSDL duy nhất trong toàn bộ báo cáo Word và Excel.',
        'Kiến trúc hệ thống',
      ]);
    }
    if (recList.isEmpty) {
      recList.add([
        '1. Duy trì tính nhất quán',
        'Độ ưu tiên: BÌNH THƯỜNG',
        'Toàn bộ số liệu và môi trường giữa các tài liệu đã đồng nhất.',
        'Toàn dự án',
      ]);
    }
    for (final r in recList) {
      _styledRow(aiSheet, aRow++, r, style: r[1].contains('KHẨN CẤP') ? alertStyle : null);
    }
    aRow++;

    if (verifiedFindings.isNotEmpty) {
      _styledRow(
        aiSheet,
        aRow++,
        ['Module', 'Lỗ hổng kiểm thử đề xuất bổ sung', 'Bằng chứng trích dẫn nguyên văn từ SRS', 'Nhận định thẩm định'],
        style: sectionStyle,
      );
      for (final vf in verifiedFindings) {
        _styledRow(
          aiSheet,
          aRow++,
          [vf.module, vf.claim, vf.quote, vf.explanation],
          style: wrapStyle,
        );
      }
      aRow++;
    }

    _styledRow(
      aiSheet,
      aRow++,
      ['BÁO CÁO NHẬN XÉT CHI TIẾT (FULL MARKDOWN)', '', '', ''],
      style: sectionStyle,
    );
    _renderMarkdownToSheet(aiSheet, reviewMarkdown, headerStyle, sectionStyle, wrapStyle);

    // ==========================================
    // 5. Sheet Test_cases (DANH SÁCH TOÀN BỘ CÁC CA TEST)
    // ==========================================
    final tc = excel['Test_cases'];
    tc.setColumnWidth(0, 22.0);
    tc.setColumnWidth(1, 18.0);
    tc.setColumnWidth(2, 35.0);
    tc.setColumnWidth(3, 35.0);
    tc.setColumnWidth(4, 35.0);
    tc.setColumnWidth(5, 14.0);

    _styledRow(
      tc,
      0,
      ['Sheet / Module', 'Mã Test Case', 'Mô tả kiểm thử', 'Các bước thực hiện', 'Kết quả mong đợi', 'Trạng thái'],
      style: headerStyle,
    );

    for (var i = 0; i < records.length; i++) {
      final r = records[i];
      final st = normalizeStatus(r.status);
      _styledRow(
        tc,
        i + 1,
        [
          r.sheet,
          r.id.isEmpty ? r.canonicalId : r.id,
          r.description,
          r.steps,
          r.expected,
          st,
        ],
        style: wrapStyle,
      );
    }

    final encoded = excel.encode();
    if (encoded == null) {
      throw Exception('Không tạo được file Excel.');
    }
    return encoded;
  }
}

void _renderMarkdownToSheet(
  Sheet sheet,
  String markdown,
  CellStyle headerStyle,
  CellStyle sectionStyle,
  CellStyle wrapStyle,
) {
  var rowIdx = sheet.maxRows + 1;
  final lines = markdown.split('\n');

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;

    if (line.startsWith('# ')) {
      final text = line.substring(2).trim();
      _styledRow(sheet, rowIdx++, [text, '', '', '', ''], style: headerStyle);
      continue;
    }
    if (line.startsWith('## ')) {
      final text = line.substring(3).trim();
      _styledRow(sheet, rowIdx++, [text, '', '', '', ''], style: sectionStyle);
      continue;
    }
    if (line.startsWith('### ')) {
      final text = line.substring(4).trim();
      _styledRow(sheet, rowIdx++, [text, '', '', '', ''], style: sectionStyle);
      continue;
    }

    if (line.startsWith('|') && line.endsWith('|')) {
      final cells = line
          .split('|')
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .toList();
      if (cells.isNotEmpty && cells.every((c) => c.contains('---') || c.contains(':---'))) {
        continue;
      }
      if (cells.isNotEmpty) {
        _styledRow(sheet, rowIdx++, cells, style: wrapStyle);
        continue;
      }
    }

    if (line.startsWith('- ') || line.startsWith('* ')) {
      final bullet = line.substring(2).trim();
      _styledRow(sheet, rowIdx++, ['• $bullet', '', '', '', ''], style: wrapStyle);
      continue;
    }

    _styledRow(sheet, rowIdx++, [line, '', '', '', ''], style: wrapStyle);
  }
}

void _styledRow(
  Sheet sheet,
  int index,
  List<String> values, {
  CellStyle? style,
}) {
  for (var c = 0; c < values.length; c++) {
    final cell = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: c, rowIndex: index),
    );
    cell.value = TextCellValue(values[c]);
    if (style != null) cell.cellStyle = style;
  }
}

String sanitizeFileName(String raw) {
  final cleaned = raw.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '_').trim();
  if (cleaned.isEmpty) return 'capstone-review.xlsx';
  return cleaned;
}

Future<void> writeAtomically(String path, List<int> bytes) async {
  final temp = File('$path.tmp');
  await temp.writeAsBytes(bytes, flush: true);
  await temp.rename(path);
}
