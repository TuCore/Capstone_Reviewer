import '../extraction/test_case_schema.dart';
import '../extraction/workbook_snapshot.dart';
import 'cross_check_models.dart';
import 'hard_checks.dart';

export 'cross_check_models.dart';

class CrossCheckEngine {
  /// 1. Quét trùng lặp Test Case ID giữa các sheet & mâu thuẫn trạng thái
  static List<DuplicateIdFinding> scanDuplicateTestIds(List<TestCaseRecord> records) {
    final findings = <DuplicateIdFinding>[];
    final idMap = <String, List<TestCaseRecord>>{};

    for (final r in records) {
      final key = r.canonicalId.isNotEmpty ? r.canonicalId : normalizeCode(r.id);
      if (key.isEmpty) continue;
      idMap.putIfAbsent(key, () => []).add(r);
    }

    for (final entry in idMap.entries) {
      final distinctSheets = entry.value.map((r) => r.sheet).toSet().toList();
      if (distinctSheets.length > 1) {
        final statusBySheet = <String, String>{};
        for (final r in entry.value) {
          statusBySheet[r.sheet] = normalizeStatus(r.status);
        }

        final distinctStatuses = statusBySheet.values.toSet();
        final hasConflict = distinctStatuses.contains('PASSED') && distinctStatuses.contains('FAILED');

        final msg = hasConflict
            ? 'Ca kiểm thử ${entry.key} bị trùng lặp giữa các sheet ${distinctSheets.join(', ')} và CÓ MÂU THUẪN KẾT QUẢ (${statusBySheet.entries.map((e) => '${e.key}=${e.value}').join(', ')}).'
            : 'Ca kiểm thử ${entry.key} bị trùng lặp giữa các sheet ${distinctSheets.join(', ')} (đều có kết quả ${statusBySheet.values.toSet().join(', ')}).';

        findings.add(DuplicateIdFinding(
          testId: entry.key,
          sheets: distinctSheets,
          statusBySheet: statusBySheet,
          hasStatusConflict: hasConflict,
          message: msg,
          evidence: SourceEvidence(
            locator: distinctSheets.join(', '),
            header: 'Test Case ID',
            value: entry.key,
            rule: 'duplicate-id',
          ),
        ));
      }
    }

    return findings;
  }

  /// 2. So khớp số liệu 3 nguồn (Word vs Excel Statistics vs Dữ liệu đếm thật)
  static ThreeWayMetricsComparison compareMetrics({
    required List<TestCaseRecord> records,
    String? wordText,
    String? excelText,
    WorkbookSnapshot? workbook,
    ExtractionAvailability availability = const ExtractionAvailability.complete(),
  }) {
    MetricValue<int> wordTotal = const MetricValue.unavailable(reason: 'Không tìm thấy thông tin tổng ca kiểm thử trong SRS/Word');
    MetricValue<int> wordAuto = const MetricValue.unavailable(reason: 'Không tìm thấy số ca tự động trong SRS/Word');
    MetricValue<int> wordManual = const MetricValue.unavailable(reason: 'Không tìm thấy số ca thủ công trong SRS/Word');
    MetricValue<int> wordFailed = const MetricValue.unavailable(reason: 'Không tìm thấy số ca thất bại trong SRS/Word');

    if (wordText != null && wordText.isNotEmpty) {
      final totalMatch = RegExp(r'(?:total|tổng\s+số)(?:\s+e2e)?\s+test\s+cases?\s*:\s*(\d+)', caseSensitive: false).firstMatch(wordText);
      if (totalMatch != null) {
        final val = int.tryParse(totalMatch.group(1)!);
        if (val != null) wordTotal = MetricValue.available(val, evidence: SourceEvidence(locator: 'Word', value: '$val'));
      }

      final autoMatch = RegExp(r'(?:automated|tự\s+động)\s*(?:passed|đạt)?\s*:\s*(\d+)', caseSensitive: false).firstMatch(wordText);
      if (autoMatch != null) {
        final val = int.tryParse(autoMatch.group(1)!);
        if (val != null) wordAuto = MetricValue.available(val, evidence: SourceEvidence(locator: 'Word', value: '$val'));
      }

      final manualMatch = RegExp(r'(?:manual|thủ\s+công)\s*(?:executed)?\s*:\s*(\d+)', caseSensitive: false).firstMatch(wordText);
      if (manualMatch != null) {
        final val = int.tryParse(manualMatch.group(1)!);
        if (val != null) wordManual = MetricValue.available(val, evidence: SourceEvidence(locator: 'Word', value: '$val'));
      }

      final failMatch = RegExp(r'(?:failed|thất\s+bại|lỗi)(?:[/\s]+(?:blocked|error))?\s*:\s*(\d+)', caseSensitive: false).firstMatch(wordText);
      if (failMatch != null) {
        final val = int.tryParse(failMatch.group(1)!);
        if (val != null) wordFailed = MetricValue.available(val, evidence: SourceEvidence(locator: 'Word', value: '$val'));
      }
    }

    // Trích xuất từ Excel (sheet thống kê)
    MetricValue<int> excelDeclaredTotal = const MetricValue.unavailable(reason: 'Không tìm thấy bảng thống kê khai báo trong Excel');
    MetricValue<int> excelDeclaredPassed = const MetricValue.unavailable(reason: 'Không tìm thấy số ca Pass khai báo trong Excel');
    MetricValue<int> excelDeclaredFailed = const MetricValue.unavailable(reason: 'Không tìm thấy số ca Fail khai báo trong Excel');

    if (workbook != null) {
      final statsSheet = workbook.sheetNamed('Test Statistics') ?? workbook.sheetNamed('Statistics') ?? workbook.sheetNamed('Thống kê');
      if (statsSheet != null) {
        for (final row in statsSheet.rows) {
          final textList = row.toTextList();
          final joined = textList.join(' ').toLowerCase();
          if (joined.contains('sub total') || joined.contains('total') || joined.contains('tổng')) {
            for (final cell in row.cells) {
              final val = int.tryParse(cell.text.trim());
              if (val != null && val > 0 && !excelDeclaredTotal.isAvailable) {
                excelDeclaredTotal = MetricValue.available(
                  val,
                  evidence: SourceEvidence(locator: '${statsSheet.name}!${cell.address}', value: '$val'),
                );
              }
            }
          }
        }
      }
    }

    // Đếm thực tế từ danh sách records
    final actualTotal = availability.isComplete
        ? MetricValue.available(records.length)
        : MetricValue.partial(records.length, reason: 'Dữ liệu bán phần do tài liệu bị cắt bớt');

    final passCount = records.where((r) => normalizeStatus(r.status) == 'PASSED').length;
    final failCount = records.where((r) => normalizeStatus(r.status) == 'FAILED').length;

    final actualPassed = availability.isComplete
        ? MetricValue.available(passCount)
        : MetricValue.partial(passCount, reason: 'Dữ liệu bán phần');

    final actualFailed = availability.isComplete
        ? MetricValue.available(failCount)
        : MetricValue.partial(failCount, reason: 'Dữ liệu bán phần');

    // Không tự suy đoán actual manual/auto từ Word nếu không có dữ liệu kiểm thử
    const actualManual = MetricValue<int>.unavailable(reason: 'Excel không có cột phân loại Manual/Auto riêng biệt');
    const actualAuto = MetricValue<int>.unavailable(reason: 'Excel không có cột phân loại Manual/Auto riêng biệt');

    final totalDiscrepancy = MetricValue.diff(actualTotal, wordTotal);
    final concealedFails = (actualFailed.isAvailable && wordFailed.isAvailable)
        ? MetricValue.available((actualFailed.value! - (wordFailed.value ?? 0)))
        : const MetricValue<int>.unavailable();
    final manualDiscrepancy = MetricValue.diff(actualManual, wordManual);

    final findings = <String>[];
    if (totalDiscrepancy.isAvailable && totalDiscrepancy.value != 0) {
      findings.add('Lệch ${totalDiscrepancy.value} ca kiểm thử giữa SRS (${wordTotal.value} ca) và đếm thực tế (${actualTotal.value} ca).');
    }
    if (concealedFails.isAvailable && concealedFails.value! > 0 && actualFailed.value! > (wordFailed.value ?? 0)) {
      findings.add('Báo cáo khai báo ${wordFailed.value ?? 0} ca Fail nhưng thực tế có ${actualFailed.value} ca FAILED.');
    }

    return ThreeWayMetricsComparison(
      wordTotal: wordTotal,
      wordAuto: wordAuto,
      wordManual: wordManual,
      wordFailed: wordFailed,
      excelDeclaredTotal: excelDeclaredTotal,
      excelDeclaredPassed: excelDeclaredPassed,
      excelDeclaredFailed: excelDeclaredFailed,
      actualTotal: actualTotal,
      actualPassed: actualPassed,
      actualFailed: actualFailed,
      actualManual: actualManual,
      actualAuto: actualAuto,
      totalDiscrepancy: totalDiscrepancy,
      concealedFails: concealedFails,
      manualDiscrepancy: manualDiscrepancy,
      findings: findings,
    );
  }

  /// 3. Soi lệch môi trường kiểm thử (Database, Hosting)
  ///
  /// Toàn bộ việc đọc hiểu ngữ nghĩa công nghệ & CSDL đã được chuyển sang
  /// AI Pass 1 (Trục 1: Tech Mismatch) & Pass 2 (Verifier).
  /// Dart thuần túy không dùng regex đoán từ khóa để tránh cảnh báo giả.
  static List<EnvironmentMismatchFinding> checkEnvironmentMismatch({
    String? wordText,
    String? excelText,
    String? registrationText,
    WorkbookSnapshot? workbook,
  }) {
    return const [];
  }

  /// 4. Soi lệch tiến độ (Milestone Deadline vs Test Execution Date)
  static List<TimelineConflictFinding> checkMilestoneDelay({
    String? wordText,
    String? excelText,
    WorkbookSnapshot? workbook,
  }) {
    final findings = <TimelineConflictFinding>[];

    // Tìm deadline trong Word từ nhãn cụ thể
    String? approvalDeadline;
    if (wordText != null) {
      final m = RegExp(r'(?:final\s+test\s+report\s+approval|phê\s+duyệt\s+báo\s+cáo|hạn\s+chót\s+kiểm\s+thử)\s*[:|]\s*([0-9/\-]+)', caseSensitive: false).firstMatch(wordText);
      if (m != null) approvalDeadline = m.group(1)!.trim();
    }

    // Tìm ngày thực hiện kiểm thử trong Excel từ nhãn cụ thể
    String? testDate;
    if (workbook != null) {
      final cover = workbook.sheetNamed('Cover') ?? workbook.sheetNamed('Revision History');
      if (cover != null) {
        for (final row in cover.rows) {
          for (var c = 0; c < row.cells.length - 1; c++) {
            final cellText = row.cells[c].text.toLowerCase().trim();
            if (cellText.contains('test date') || cellText.contains('execution date') || cellText.contains('ngày kiểm thử')) {
              final nextVal = row.cells[c + 1].text.trim();
              if (nextVal.isNotEmpty) {
                testDate = nextVal;
                break;
              }
            }
          }
          if (testDate != null) break;
        }
      }
    }

    if (approvalDeadline != null && testDate != null) {
      final dDeadline = _parseDateStrict(approvalDeadline);
      final dTest = _parseDateStrict(testDate);
      if (dDeadline != null && dTest != null && dTest.isAfter(dDeadline)) {
        findings.add(TimelineConflictFinding(
          milestoneName: 'Phê duyệt Báo cáo kiểm thử',
          milestoneDeadline: approvalDeadline,
          testExecutionDate: testDate,
          isViolated: true,
          description: 'Ca kiểm thử được thực hiện đến ngày $testDate, trễ hơn hạn chót phê duyệt $approvalDeadline trong kế hoạch kiểm thử.',
          evidence: SourceEvidence(
            locator: 'SRS vs Cover',
            header: 'Timeline',
            value: '$testDate > $approvalDeadline',
            rule: 'timeline-conflict',
          ),
        ));
      }
    }

    return findings;
  }

  /// 5. Kiểm tra lỗi toàn vẹn dữ liệu nội bộ Excel & hành chính
  static List<IntegrityFinding> checkAdministrativeAndIntegrity({
    required List<TestCaseRecord> records,
    String? wordText,
    String? excelText,
    WorkbookSnapshot? workbook,
  }) {
    final findings = <IntegrityFinding>[];

    // 1. Quét sót placeholder mẫu
    final placeholders = [
      '[Project Name]',
      '[Author Name]',
      'Author Name',
      'Your Company',
      '[Company]',
      'Your University',
      '[Your University]',
      '[Tên đề tài]',
    ];
    final combinedText = '${wordText ?? ''} ${excelText ?? ''}';
    for (final p in placeholders) {
      if (combinedText.contains(p)) {
        findings.add(IntegrityFinding(
          code: 'placeholder-leftover',
          severity: 'HIGH',
          location: 'Tài liệu / Bìa',
          message: 'Sót placeholder mẫu chưa điền thông tin thật: "$p".',
          evidence: SourceEvidence(
            locator: 'Văn bản',
            value: p,
            rule: 'placeholder-leftover',
          ),
        ));
      }
    }

    // 2. Bắt gãy liên kết sheet trong mục lục Test Cases (dựa trên cột Tên Sheet chuẩn hóa)
    if (workbook != null) {
      final tcSheet = workbook.sheetNamed('Test Cases') ?? workbook.sheetNamed('TOC') ?? workbook.sheetNamed('Mục lục');
      if (tcSheet != null) {
        int? sheetColIdx;
        String? sheetColHeader;
        int headerRowIdx = -1;

        // Tìm dòng tiêu đề có cột tên sheet
        for (final row in tcSheet.rows) {
          for (var c = 0; c < row.cells.length; c++) {
            final text = foldHeader(row.cells[c].text);
            if (text == 'sheet name' || text == 'ten sheet' || text == 'worksheet' || text == 'tab') {
              sheetColIdx = c;
              sheetColHeader = row.cells[c].text;
              headerRowIdx = row.rowIndex;
              break;
            }
          }
          if (sheetColIdx != null) break;
        }

        // Chỉ kiểm tra khi có cột Tên Sheet rõ ràng; TUYỆT ĐỐI không lấy cứng cột 3
        if (sheetColIdx != null) {
          for (final row in tcSheet.rows) {
            if (row.rowIndex <= headerRowIdx) continue;
            final cell = row.cell(sheetColIdx);
            if (cell == null || cell.isEmpty) continue;

            final targetSheet = cell.text.trim();
            if (targetSheet.isEmpty) continue;

            if (!workbook.containsSheet(targetSheet)) {
              findings.add(IntegrityFinding(
                code: 'broken-sheet-link',
                severity: 'HIGH',
                location: 'Mục lục (${tcSheet.name}!${cell.address})',
                message: 'Gãy liên kết sheet: Dòng mục lục trỏ đến sheet "$targetSheet" nhưng sheet này không tồn tại trong file Excel.',
                evidence: SourceEvidence(
                  locator: '${tcSheet.name}!${cell.address}',
                  header: sheetColHeader,
                  value: targetSheet,
                  rule: 'broken-sheet-link',
                ),
              ));
            }
          }
        }
      }
    }

    // 3. Kiểm tra quy tắc nghiệp vụ WIP Isolation & Published Integrity khi có bằng chứng trong dữ liệu
    for (final r in records) {
      final desc = r.description.toLowerCase();
      final steps = r.steps.toLowerCase();
      final expected = r.expected.toLowerCase();
      final combined = '$desc $steps $expected';

      if (combined.contains('wip') && (combined.contains('delete') || combined.contains('xóa'))) {
        if (!combined.contains('creator only') && !combined.contains('reject') && !combined.contains('error') && !combined.contains('bị từ chối')) {
          findings.add(IntegrityFinding(
            code: 'wip-isolation-violation',
            severity: 'HIGH',
            location: '${r.sheet} (${r.id})',
            message: 'Vi phạm nguyên tắc WIP Isolation: Cho phép chỉnh sửa/xóa tài liệu WIP mà không kiểm tra quyền tác giả duy nhất.',
            evidence: SourceEvidence(
              locator: '${r.sheet}!${r.id}',
              value: r.description,
              rule: 'wip-isolation-violation',
            ),
          ));
        }
      }

      if (combined.contains('published') && (combined.contains('modify') || combined.contains('rename') || combined.contains('delete') || combined.contains('sửa'))) {
        findings.add(IntegrityFinding(
          code: 'published-integrity-violation',
          severity: 'CRITICAL',
          location: '${r.sheet} (${r.id})',
          message: 'Vi phạm tính toàn vẹn Published: Tài liệu đã ban hành (Published) không được phép sửa đổi/xóa trực tiếp.',
          evidence: SourceEvidence(
            locator: '${r.sheet}!${r.id}',
            value: r.description,
            rule: 'published-integrity-violation',
          ),
        ));
      }
    }

    return findings;
  }

  /// Chạy toàn bộ chu trình Deterministic Code Engine
  static CrossCheckResult run({
    required List<TestCaseRecord> records,
    String? wordText,
    String? excelText,
    String? registrationText,
    WorkbookSnapshot? workbook,
    ExtractionAvailability excelAvailability = const ExtractionAvailability.complete(),
    ExtractionAvailability wordAvailability = const ExtractionAvailability.complete(),
    Map<String, List<List<String>>>? rawSheets,
  }) {
    final effectiveWorkbook = workbook ?? (rawSheets != null ? _snapshotFromRaw(rawSheets) : WorkbookSnapshot.empty());

    final duplicateIds = scanDuplicateTestIds(records);
    final metricsComparison = compareMetrics(
      records: records,
      wordText: wordText,
      excelText: excelText,
      workbook: effectiveWorkbook,
      availability: excelAvailability,
    );
    final environmentMismatches = checkEnvironmentMismatch(
      wordText: wordText,
      excelText: excelText,
      registrationText: registrationText,
      workbook: effectiveWorkbook,
    );
    final timelineConflicts = checkMilestoneDelay(
      wordText: wordText,
      excelText: excelText,
      workbook: effectiveWorkbook,
    );
    final integrityFindings = checkAdministrativeAndIntegrity(
      records: records,
      wordText: wordText,
      excelText: excelText,
      workbook: effectiveWorkbook,
    );

    final ruleOutcomes = <String, RuleOutcome>{
      'duplicate-ids': RuleOutcome(
        ruleId: 'duplicate-ids',
        kind: duplicateIds.isEmpty ? RuleOutcomeKind.checkedClean : RuleOutcomeKind.checkedWithFindings,
        findings: duplicateIds,
        message: duplicateIds.isEmpty ? 'Không có ID trùng lặp liên sheet.' : 'Phát hiện ${duplicateIds.length} ca trùng ID.',
      ),
      'metrics-comparison': RuleOutcome(
        ruleId: 'metrics-comparison',
        kind: metricsComparison.findings.isEmpty ? RuleOutcomeKind.checkedClean : RuleOutcomeKind.checkedWithFindings,
        findings: metricsComparison.findings,
        message: metricsComparison.findings.isEmpty ? 'Số liệu khớp giữa các nguồn.' : 'Phát hiện lệch số liệu.',
      ),
      'environment-mismatch': const RuleOutcome(
        ruleId: 'environment-mismatch',
        kind: RuleOutcomeKind.notApplicable,
        message: 'Đã ủy quyền kiểm tra ngữ nghĩa công nghệ & CSDL cho AI (Trục 1).',
      ),
      'timeline-check': RuleOutcome(
        ruleId: 'timeline-check',
        kind: timelineConflicts.isEmpty ? RuleOutcomeKind.checkedClean : RuleOutcomeKind.checkedWithFindings,
        findings: timelineConflicts,
        message: timelineConflicts.isEmpty ? 'Tiến độ phù hợp hoặc không có mốc thời gian.' : 'Phát hiện chậm tiến độ.',
      ),
      'integrity-check': RuleOutcome(
        ruleId: 'integrity-check',
        kind: integrityFindings.isEmpty ? RuleOutcomeKind.checkedClean : RuleOutcomeKind.checkedWithFindings,
        findings: integrityFindings,
        message: integrityFindings.isEmpty ? 'Toàn vẹn dữ liệu bảo đảm.' : 'Phát hiện ${integrityFindings.length} vi phạm toàn vẹn dữ liệu.',
      ),
    };

    return CrossCheckResult(
      duplicateIds: duplicateIds,
      metricsComparison: metricsComparison,
      environmentMismatches: environmentMismatches,
      timelineConflicts: timelineConflicts,
      integrityFindings: integrityFindings,
      ruleOutcomes: ruleOutcomes,
    );
  }

  static WorkbookSnapshot _snapshotFromRaw(Map<String, List<List<String>>> raw) {
    final wbSheets = <WorkbookSheet>[];
    for (final entry in raw.entries) {
      final rows = <WorkbookRow>[];
      for (var r = 0; r < entry.value.length; r++) {
        final cells = <WorkbookCell>[];
        for (var c = 0; c < entry.value[r].length; c++) {
          cells.add(WorkbookCell(
            rowIndex: r,
            columnIndex: c,
            address: '${String.fromCharCode(65 + (c % 26))}${r + 1}',
            kind: CellValueKind.text,
            text: entry.value[r][c],
          ));
        }
        rows.add(WorkbookRow(rowIndex: r, cells: cells));
      }
      wbSheets.add(WorkbookSheet(name: entry.key, rows: rows));
    }
    return WorkbookSnapshot(sheets: wbSheets);
  }
}

DateTime? _parseDateStrict(String raw) {
  final s = raw.trim();
  final slash = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(s);
  if (slash != null) {
    final d = int.parse(slash.group(1)!);
    final m = int.parse(slash.group(2)!);
    final y = int.parse(slash.group(3)!);
    if (m < 1 || m > 12 || d < 1 || d > 31) return null;
    final dt = DateTime(y, m, d);
    if (dt.year != y || dt.month != m || dt.day != d) return null; // Reject 31/02
    return dt;
  }
  final dash = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(s);
  if (dash != null) {
    final y = int.parse(dash.group(1)!);
    final m = int.parse(dash.group(2)!);
    final d = int.parse(dash.group(3)!);
    if (m < 1 || m > 12 || d < 1 || d > 31) return null;
    final dt = DateTime(y, m, d);
    if (dt.year != y || dt.month != m || dt.day != d) return null;
    return dt;
  }
  return null;
}
