import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_metadata.freezed.dart';

enum FileType { excel, pdf, word }

@freezed
class FileMetadata with _$FileMetadata {
  factory FileMetadata({
    required String fileName,
    required String filePath,
    required int fileSize,
    required FileType fileType,
    required bool isValid,
    String? errorMessage,
  }) = _FileMetadata;
}
