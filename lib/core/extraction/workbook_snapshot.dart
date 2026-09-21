import 'package:excel/excel.dart' as ex;

enum CellValueKind {
  text,
  intVal,
  doubleVal,
  boolVal,
  dateVal,
  dateTimeVal,
  timeVal,
  formulaVal,
  blank,
}

class WorkbookCell {
  const WorkbookCell({
    required this.rowIndex,
    required this.columnIndex,
    required this.address,
    required this.kind,
    required this.text,
    this.dateValue,
    this.formula,
    this.rawValue,
  });

  /// 0-indexed row in the sheet
  final int rowIndex;

  /// 0-indexed column in the sheet
  final int columnIndex;

  /// Excel address (e.g. "A1", "C5")
  final String address;

  final CellValueKind kind;
  final String text;
  final DateTime? dateValue;
  final String? formula;
  final dynamic rawValue;

  bool get isEmpty => text.trim().isEmpty;

  static WorkbookCell fromExcelData(ex.Data? data, {required int rowIndex, required int columnIndex}) {
    final addr = data?.cellIndex.cellId ?? _formatAddress(rowIndex, columnIndex);
    if (data == null || data.value == null) {
      return WorkbookCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        address: addr,
        kind: CellValueKind.blank,
        text: '',
      );
    }

    final val = data.value;
    if (val is ex.TextCellValue) {
      return WorkbookCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        address: addr,
        kind: CellValueKind.text,
        text: val.value.text ?? '',
        rawValue: val.value.text,
      );
    } else if (val is ex.IntCellValue) {
      return WorkbookCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        address: addr,
        kind: CellValueKind.intVal,
        text: val.value.toString(),
        rawValue: val.value,
      );
    } else if (val is ex.DoubleCellValue) {
      return WorkbookCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        address: addr,
        kind: CellValueKind.doubleVal,
        text: val.value.toString(),
        rawValue: val.value,
      );
    } else if (val is ex.BoolCellValue) {
      return WorkbookCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        address: addr,
        kind: CellValueKind.boolVal,
        text: val.value.toString(),
        rawValue: val.value,
      );
    } else if (val is ex.DateCellValue) {
      final dt = DateTime.utc(val.year, val.month, val.day);
      return WorkbookCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        address: addr,
        kind: CellValueKind.dateVal,
        text: '${val.year}-${val.month.toString().padLeft(2, '0')}-${val.day.toString().padLeft(2, '0')}',
        dateValue: dt,
        rawValue: dt,
      );
    } else if (val is ex.DateTimeCellValue) {
      final dt = DateTime.utc(val.year, val.month, val.day, val.hour, val.minute, val.second);
      return WorkbookCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        address: addr,
        kind: CellValueKind.dateTimeVal,
        text: dt.toIso8601String(),
        dateValue: dt,
        rawValue: dt,
      );
    } else if (val is ex.TimeCellValue) {
      return WorkbookCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        address: addr,
        kind: CellValueKind.timeVal,
        text: '${val.hour.toString().padLeft(2, '0')}:${val.minute.toString().padLeft(2, '0')}:${val.second.toString().padLeft(2, '0')}',
        rawValue: val,
      );
    } else if (val is ex.FormulaCellValue) {
      return WorkbookCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        address: addr,
        kind: CellValueKind.formulaVal,
        text: val.formula,
        formula: val.formula,
        rawValue: val.formula,
      );
    }

    final rawStr = val.toString().trim();
    return WorkbookCell(
      rowIndex: rowIndex,
      columnIndex: columnIndex,
      address: addr,
      kind: CellValueKind.text,
      text: rawStr,
      rawValue: val,
    );
  }

  static String _formatAddress(int row, int col) {
    var colStr = '';
    var c = col;
    while (c >= 0) {
      colStr = String.fromCharCode(65 + (c % 26)) + colStr;
      c = (c ~/ 26) - 1;
    }
    return '$colStr${row + 1}';
  }
}

class WorkbookRow {
  const WorkbookRow({
    required this.rowIndex,
    required this.cells,
  });

  /// 0-indexed row number
  final int rowIndex;
  final List<WorkbookCell> cells;

  String cellText(int colIndex) {
    if (colIndex < 0 || colIndex >= cells.length) return '';
    return cells[colIndex].text;
  }

  WorkbookCell? cell(int colIndex) {
    if (colIndex < 0 || colIndex >= cells.length) return null;
    return cells[colIndex];
  }

  List<String> toTextList() => cells.map((c) => c.text).toList();

  bool get hasContent => cells.any((c) => !c.isEmpty);
}

class WorkbookSheet {
  WorkbookSheet({
    required this.name,
    required this.rows,
  }) {
    _rowMap = {for (final r in rows) r.rowIndex: r};
  }

  final String name;
  final List<WorkbookRow> rows;
  late final Map<int, WorkbookRow> _rowMap;

  WorkbookRow? rowAt(int rowIndex) => _rowMap[rowIndex];

  WorkbookCell? cellAt(int rowIndex, int colIndex) {
    return _rowMap[rowIndex]?.cell(colIndex);
  }

  List<List<String>> toTextRows() => rows.map((r) => r.toTextList()).toList();
}

class WorkbookSnapshot {
  WorkbookSnapshot({
    required this.sheets,
    this.isComplete = true,
    this.skippedCandidateSheets = const [],
    this.warnings = const [],
  }) {
    _sheetMap = {
      for (final s in sheets) s.name.toLowerCase().trim(): s,
    };
  }

  factory WorkbookSnapshot.empty({
    bool isComplete = false,
    List<String> skippedCandidateSheets = const [],
    List<String> warnings = const [],
  }) {
    return WorkbookSnapshot(
      sheets: const [],
      isComplete: isComplete,
      skippedCandidateSheets: skippedCandidateSheets,
      warnings: warnings,
    );
  }

  final List<WorkbookSheet> sheets;
  final bool isComplete;
  final List<String> skippedCandidateSheets;
  final List<String> warnings;
  late final Map<String, WorkbookSheet> _sheetMap;

  WorkbookSheet? sheetNamed(String name) {
    return _sheetMap[name.toLowerCase().trim()];
  }

  bool containsSheet(String name) {
    return _sheetMap.containsKey(name.toLowerCase().trim());
  }

  Set<String> get sheetNames => sheets.map((s) => s.name).toSet();

  WorkbookCell? cellAt(String sheetName, int row, int col) {
    return sheetNamed(sheetName)?.cellAt(row, col);
  }

  Map<String, List<List<String>>> toTextSheets() {
    return {
      for (final s in sheets) s.name: s.toTextRows(),
    };
  }
}
