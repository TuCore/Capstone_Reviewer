import 'dart:io';
import 'dart:typed_data';

import 'package:capstone_reviewer/core/extraction/file_gate.dart';
import 'package:capstone_reviewer/core/services/document_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/docx_fixture.dart';

void main() {
  test('size bands: under 10MB direct, 10-60 chunked, over 60 reject', () {
    expect(FileGate.bandFor(9 * 1024 * 1024), FileSizeBand.direct);
    expect(FileGate.bandFor(10 * 1024 * 1024), FileSizeBand.chunked);
    expect(FileGate.bandFor(60 * 1024 * 1024), FileSizeBand.chunked);
    expect(FileGate.bandFor(60 * 1024 * 1024 + 1), FileSizeBand.rejected);
  });

  test('OLE .doc rejected at inspect', () {
    final dir = Directory.systemTemp.createTempSync('gate-doc');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/spec.doc');
    file.writeAsBytesSync(
      Uint8List.fromList(
        [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1, 0, 0],
      ),
    );
    final inspection = FileGate.inspect(file.path);
    expect(inspection.rejected, isTrue);
    expect(inspection.rejectReason, contains('.doc cũ'));
  });

  test('OLE bytes with .docx extension rejected as disguised', () {
    final dir = Directory.systemTemp.createTempSync('gate-fake-docx');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/spec.docx');
    file.writeAsBytesSync(
      Uint8List.fromList(
        [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1, 1, 2],
      ),
    );
    final inspection = FileGate.inspect(file.path);
    expect(inspection.rejected, isTrue);
    expect(inspection.rejectReason, contains('đội lốt .docx'));
  });

  test('zip without document.xml rejected at extract', () {
    final dir = Directory.systemTemp.createTempSync('gate-zip');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/spec.docx');
    file.writeAsBytesSync(buildZipWithoutDocument());
    final inspection = FileGate.inspect(file.path);
    expect(inspection.rejected, isFalse);
    expect(inspection.kind, DetectedKind.docx);
    expect(
      () => extractDocumentSync(file.path),
      throwsA(
        isA<FileRejectedException>().having(
          (e) => e.message,
          'message',
          contains('không có word/document.xml'),
        ),
      ),
    );
  });

  test('heading docx zip starts with PK and is detected as docx', () {
    final bytes = buildDocxBytes(headings: [(1, 'Login')]);
    expect(bytes[0], 0x50);
    expect(bytes[1], 0x4B);
    expect(
      FileGate.detectKind('.docx', Uint8List.fromList(bytes.take(8).toList())),
      DetectedKind.docx,
    );
  });
}
