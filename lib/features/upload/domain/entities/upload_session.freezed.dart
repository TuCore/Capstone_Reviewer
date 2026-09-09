// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UploadSession {
  String get groupCode => throw _privateConstructorUsedError; // "SE1601_Group3"
  String get projectName =>
      throw _privateConstructorUsedError; // "Ứng dụng quản lý..."
  String get semester => throw _privateConstructorUsedError; // "SP2026"
  FileMetadata get excelFile => throw _privateConstructorUsedError;
  FileMetadata get srsFile => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UploadSessionCopyWith<UploadSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadSessionCopyWith<$Res> {
  factory $UploadSessionCopyWith(
          UploadSession value, $Res Function(UploadSession) then) =
      _$UploadSessionCopyWithImpl<$Res, UploadSession>;
  @useResult
  $Res call(
      {String groupCode,
      String projectName,
      String semester,
      FileMetadata excelFile,
      FileMetadata srsFile,
      DateTime createdAt});

  $FileMetadataCopyWith<$Res> get excelFile;
  $FileMetadataCopyWith<$Res> get srsFile;
}

/// @nodoc
class _$UploadSessionCopyWithImpl<$Res, $Val extends UploadSession>
    implements $UploadSessionCopyWith<$Res> {
  _$UploadSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupCode = null,
    Object? projectName = null,
    Object? semester = null,
    Object? excelFile = null,
    Object? srsFile = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      groupCode: null == groupCode
          ? _value.groupCode
          : groupCode // ignore: cast_nullable_to_non_nullable
              as String,
      projectName: null == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      semester: null == semester
          ? _value.semester
          : semester // ignore: cast_nullable_to_non_nullable
              as String,
      excelFile: null == excelFile
          ? _value.excelFile
          : excelFile // ignore: cast_nullable_to_non_nullable
              as FileMetadata,
      srsFile: null == srsFile
          ? _value.srsFile
          : srsFile // ignore: cast_nullable_to_non_nullable
              as FileMetadata,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FileMetadataCopyWith<$Res> get excelFile {
    return $FileMetadataCopyWith<$Res>(_value.excelFile, (value) {
      return _then(_value.copyWith(excelFile: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FileMetadataCopyWith<$Res> get srsFile {
    return $FileMetadataCopyWith<$Res>(_value.srsFile, (value) {
      return _then(_value.copyWith(srsFile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UploadSessionImplCopyWith<$Res>
    implements $UploadSessionCopyWith<$Res> {
  factory _$$UploadSessionImplCopyWith(
          _$UploadSessionImpl value, $Res Function(_$UploadSessionImpl) then) =
      __$$UploadSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String groupCode,
      String projectName,
      String semester,
      FileMetadata excelFile,
      FileMetadata srsFile,
      DateTime createdAt});

  @override
  $FileMetadataCopyWith<$Res> get excelFile;
  @override
  $FileMetadataCopyWith<$Res> get srsFile;
}

/// @nodoc
class __$$UploadSessionImplCopyWithImpl<$Res>
    extends _$UploadSessionCopyWithImpl<$Res, _$UploadSessionImpl>
    implements _$$UploadSessionImplCopyWith<$Res> {
  __$$UploadSessionImplCopyWithImpl(
      _$UploadSessionImpl _value, $Res Function(_$UploadSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupCode = null,
    Object? projectName = null,
    Object? semester = null,
    Object? excelFile = null,
    Object? srsFile = null,
    Object? createdAt = null,
  }) {
    return _then(_$UploadSessionImpl(
      groupCode: null == groupCode
          ? _value.groupCode
          : groupCode // ignore: cast_nullable_to_non_nullable
              as String,
      projectName: null == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      semester: null == semester
          ? _value.semester
          : semester // ignore: cast_nullable_to_non_nullable
              as String,
      excelFile: null == excelFile
          ? _value.excelFile
          : excelFile // ignore: cast_nullable_to_non_nullable
              as FileMetadata,
      srsFile: null == srsFile
          ? _value.srsFile
          : srsFile // ignore: cast_nullable_to_non_nullable
              as FileMetadata,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$UploadSessionImpl implements _UploadSession {
  _$UploadSessionImpl(
      {required this.groupCode,
      required this.projectName,
      required this.semester,
      required this.excelFile,
      required this.srsFile,
      required this.createdAt});

  @override
  final String groupCode;
// "SE1601_Group3"
  @override
  final String projectName;
// "Ứng dụng quản lý..."
  @override
  final String semester;
// "SP2026"
  @override
  final FileMetadata excelFile;
  @override
  final FileMetadata srsFile;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'UploadSession(groupCode: $groupCode, projectName: $projectName, semester: $semester, excelFile: $excelFile, srsFile: $srsFile, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadSessionImpl &&
            (identical(other.groupCode, groupCode) ||
                other.groupCode == groupCode) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.semester, semester) ||
                other.semester == semester) &&
            (identical(other.excelFile, excelFile) ||
                other.excelFile == excelFile) &&
            (identical(other.srsFile, srsFile) || other.srsFile == srsFile) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, groupCode, projectName, semester,
      excelFile, srsFile, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadSessionImplCopyWith<_$UploadSessionImpl> get copyWith =>
      __$$UploadSessionImplCopyWithImpl<_$UploadSessionImpl>(this, _$identity);
}

abstract class _UploadSession implements UploadSession {
  factory _UploadSession(
      {required final String groupCode,
      required final String projectName,
      required final String semester,
      required final FileMetadata excelFile,
      required final FileMetadata srsFile,
      required final DateTime createdAt}) = _$UploadSessionImpl;

  @override
  String get groupCode;
  @override // "SE1601_Group3"
  String get projectName;
  @override // "Ứng dụng quản lý..."
  String get semester;
  @override // "SP2026"
  FileMetadata get excelFile;
  @override
  FileMetadata get srsFile;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$UploadSessionImplCopyWith<_$UploadSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
