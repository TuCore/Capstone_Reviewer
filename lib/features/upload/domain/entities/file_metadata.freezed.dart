// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FileMetadata {
  String get fileName => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  FileType get fileType => throw _privateConstructorUsedError;
  bool get isValid => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FileMetadataCopyWith<FileMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileMetadataCopyWith<$Res> {
  factory $FileMetadataCopyWith(
          FileMetadata value, $Res Function(FileMetadata) then) =
      _$FileMetadataCopyWithImpl<$Res, FileMetadata>;
  @useResult
  $Res call(
      {String fileName,
      String filePath,
      int fileSize,
      FileType fileType,
      bool isValid,
      String? errorMessage});
}

/// @nodoc
class _$FileMetadataCopyWithImpl<$Res, $Val extends FileMetadata>
    implements $FileMetadataCopyWith<$Res> {
  _$FileMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? filePath = null,
    Object? fileSize = null,
    Object? fileType = null,
    Object? isValid = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as FileType,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileMetadataImplCopyWith<$Res>
    implements $FileMetadataCopyWith<$Res> {
  factory _$$FileMetadataImplCopyWith(
          _$FileMetadataImpl value, $Res Function(_$FileMetadataImpl) then) =
      __$$FileMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fileName,
      String filePath,
      int fileSize,
      FileType fileType,
      bool isValid,
      String? errorMessage});
}

/// @nodoc
class __$$FileMetadataImplCopyWithImpl<$Res>
    extends _$FileMetadataCopyWithImpl<$Res, _$FileMetadataImpl>
    implements _$$FileMetadataImplCopyWith<$Res> {
  __$$FileMetadataImplCopyWithImpl(
      _$FileMetadataImpl _value, $Res Function(_$FileMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? filePath = null,
    Object? fileSize = null,
    Object? fileType = null,
    Object? isValid = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$FileMetadataImpl(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as FileType,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FileMetadataImpl implements _FileMetadata {
  _$FileMetadataImpl(
      {required this.fileName,
      required this.filePath,
      required this.fileSize,
      required this.fileType,
      required this.isValid,
      this.errorMessage});

  @override
  final String fileName;
  @override
  final String filePath;
  @override
  final int fileSize;
  @override
  final FileType fileType;
  @override
  final bool isValid;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'FileMetadata(fileName: $fileName, filePath: $filePath, fileSize: $fileSize, fileType: $fileType, isValid: $isValid, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileMetadataImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileName, filePath, fileSize,
      fileType, isValid, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FileMetadataImplCopyWith<_$FileMetadataImpl> get copyWith =>
      __$$FileMetadataImplCopyWithImpl<_$FileMetadataImpl>(this, _$identity);
}

abstract class _FileMetadata implements FileMetadata {
  factory _FileMetadata(
      {required final String fileName,
      required final String filePath,
      required final int fileSize,
      required final FileType fileType,
      required final bool isValid,
      final String? errorMessage}) = _$FileMetadataImpl;

  @override
  String get fileName;
  @override
  String get filePath;
  @override
  int get fileSize;
  @override
  FileType get fileType;
  @override
  bool get isValid;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$FileMetadataImplCopyWith<_$FileMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
