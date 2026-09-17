import 'dart:io';
import 'dart:typed_data';

enum FileSizeBand { direct, chunked, rejected }

enum DetectedKind { pdf, docx, xlsx, xlsOle, oleDoc, zipOther, unknown }

class FileRejectedException implements Exception {
  FileRejectedException(this.message);
  final String message;

  @override
  String toString() => message;
}

class FileInspection {
  const FileInspection({
    required this.path,
    required this.sizeBytes,
    required this.band,
    required this.kind,
    this.rejectReason,
  });

  final String path;
  final int sizeBytes;
  final FileSizeBand band;
  final DetectedKind kind;
  final String? rejectReason;

  bool get rejected => band == FileSizeBand.rejected || rejectReason != null;

  double get sizeMb => sizeBytes / (1024 * 1024);

  String? get statusMessage {
    if (rejectReason != null) return rejectReason;
    if (band == FileSizeBand.chunked) {
      return 'File ${sizeMb.toStringAsFixed(1)}MB — đọc theo đoạn có tiến trình.';
    }
    return null;
  }
}

class FileGate {
  static const int directBytes = 10 * 1024 * 1024;
  static const int hardLimitBytes = 60 * 1024 * 1024;
  static const int maxIsolateStringBytes = 10 * 1024 * 1024;
  static const int promptBudgetChars = 400000;

  static const _ole = [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1];

  static FileSizeBand bandFor(int bytes) {
    if (bytes > hardLimitBytes) return FileSizeBand.rejected;
    if (bytes >= directBytes) return FileSizeBand.chunked;
    return FileSizeBand.direct;
  }

  static FileInspection inspect(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      return FileInspection(
        path: path,
        sizeBytes: 0,
        band: FileSizeBand.rejected,
        kind: DetectedKind.unknown,
        rejectReason: 'Không tìm thấy file.',
      );
    }

    final size = file.lengthSync();
    final band = bandFor(size);
    final ext = _ext(path);
    final header = _header(file);
    final kind = detectKind(ext, header);

    if (band == FileSizeBand.rejected) {
      return FileInspection(
        path: path,
        sizeBytes: size,
        band: band,
        kind: kind,
        rejectReason:
            'File ${ (size / (1024 * 1024)).toStringAsFixed(1)}MB vượt giới hạn 60MB.',
      );
    }

    final reject = rejectReasonFor(ext, kind);
    if (reject != null) {
      return FileInspection(
        path: path,
        sizeBytes: size,
        band: FileSizeBand.rejected,
        kind: kind,
        rejectReason: reject,
      );
    }

    return FileInspection(
      path: path,
      sizeBytes: size,
      band: band,
      kind: kind,
    );
  }

  static DetectedKind detectKind(String ext, Uint8List header) {
    if (_isPdf(header)) return DetectedKind.pdf;
    if (_isZip(header)) {
      if (ext == '.docx') return DetectedKind.docx;
      if (ext == '.xlsx') return DetectedKind.xlsx;
      return DetectedKind.zipOther;
    }
    if (_isOle(header)) {
      if (ext == '.doc') return DetectedKind.oleDoc;
      if (ext == '.xls') return DetectedKind.xlsOle;
      return DetectedKind.oleDoc;
    }
    return DetectedKind.unknown;
  }

  static String? rejectReasonFor(String ext, DetectedKind kind) {
    if (ext == '.doc') {
      return 'File .doc cũ không hỗ trợ. Lưu lại thành .docx rồi chọn lại.';
    }
    if (ext == '.docx' && kind != DetectedKind.docx) {
      return 'File đội lốt .docx (ruột không phải Word OOXML).';
    }
    if (ext == '.xlsx' && kind != DetectedKind.xlsx) {
      if (kind == DetectedKind.xlsOle) {
        return 'File đội lốt .xlsx (định dạng Excel cũ). Lưu lại thành .xlsx.';
      }
      return 'File đội lốt .xlsx (ruột không phải Excel OOXML).';
    }
    if (ext == '.pdf' && kind != DetectedKind.pdf) {
      return 'File đội lốt .pdf.';
    }
    if (kind == DetectedKind.oleDoc) {
      return 'File .doc cũ không hỗ trợ. Lưu lại thành .docx rồi chọn lại.';
    }
    return null;
  }

  static String _ext(String path) {
    final slash = path.replaceAll('\\', '/');
    final name = slash.split('/').last.toLowerCase();
    final dot = name.lastIndexOf('.');
    if (dot < 0) return '';
    return name.substring(dot);
  }

  static Uint8List _header(File file) {
    final raf = file.openSync();
    try {
      final buf = Uint8List(8);
      final n = raf.readIntoSync(buf);
      return Uint8List.sublistView(buf, 0, n);
    } finally {
      raf.closeSync();
    }
  }

  static bool _isZip(Uint8List h) {
    return h.length >= 4 && h[0] == 0x50 && h[1] == 0x4B &&
        (h[2] == 0x03 || h[2] == 0x05 || h[2] == 0x07);
  }

  static bool _isPdf(Uint8List h) {
    return h.length >= 4 &&
        h[0] == 0x25 &&
        h[1] == 0x50 &&
        h[2] == 0x44 &&
        h[3] == 0x46;
  }

  static bool _isOle(Uint8List h) {
    if (h.length < _ole.length) return false;
    for (var i = 0; i < _ole.length; i++) {
      if (h[i] != _ole[i]) return false;
    }
    return true;
  }
}
