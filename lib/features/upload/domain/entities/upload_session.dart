import 'package:freezed_annotation/freezed_annotation.dart';
import 'file_metadata.dart';

part 'upload_session.freezed.dart';

@freezed
class UploadSession with _$UploadSession {
  factory UploadSession({
    required String groupCode,       // "SE1601_Group3"
    required String projectName,     // "Ứng dụng quản lý..."
    required String semester,        // "SP2026"
    required FileMetadata excelFile,
    required FileMetadata srsFile,
    required DateTime createdAt,
  }) = _UploadSession;
}
