// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_profile_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AiProfileImage _$AiProfileImageFromJson(Map<String, dynamic> json) {
  return _AiProfileImage.fromJson(json);
}

/// @nodoc
mixin _$AiProfileImage {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_profiles_id')
  String get aiProfilesId => throw _privateConstructorUsedError;
  String get img => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AiProfileImageCopyWith<AiProfileImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiProfileImageCopyWith<$Res> {
  factory $AiProfileImageCopyWith(
          AiProfileImage value, $Res Function(AiProfileImage) then) =
      _$AiProfileImageCopyWithImpl<$Res, AiProfileImage>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'ai_profiles_id') String aiProfilesId,
      String img,
      @JsonKey(name: 'is_default') bool isDefault});
}

/// @nodoc
class _$AiProfileImageCopyWithImpl<$Res, $Val extends AiProfileImage>
    implements $AiProfileImageCopyWith<$Res> {
  _$AiProfileImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? aiProfilesId = null,
    Object? img = null,
    Object? isDefault = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      aiProfilesId: null == aiProfilesId
          ? _value.aiProfilesId
          : aiProfilesId // ignore: cast_nullable_to_non_nullable
              as String,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiProfileImageImplCopyWith<$Res>
    implements $AiProfileImageCopyWith<$Res> {
  factory _$$AiProfileImageImplCopyWith(_$AiProfileImageImpl value,
          $Res Function(_$AiProfileImageImpl) then) =
      __$$AiProfileImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'ai_profiles_id') String aiProfilesId,
      String img,
      @JsonKey(name: 'is_default') bool isDefault});
}

/// @nodoc
class __$$AiProfileImageImplCopyWithImpl<$Res>
    extends _$AiProfileImageCopyWithImpl<$Res, _$AiProfileImageImpl>
    implements _$$AiProfileImageImplCopyWith<$Res> {
  __$$AiProfileImageImplCopyWithImpl(
      _$AiProfileImageImpl _value, $Res Function(_$AiProfileImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? aiProfilesId = null,
    Object? img = null,
    Object? isDefault = null,
  }) {
    return _then(_$AiProfileImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      aiProfilesId: null == aiProfilesId
          ? _value.aiProfilesId
          : aiProfilesId // ignore: cast_nullable_to_non_nullable
              as String,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiProfileImageImpl
    with DiagnosticableTreeMixin
    implements _AiProfileImage {
  const _$AiProfileImageImpl(
      {required this.id,
      @JsonKey(name: 'ai_profiles_id') required this.aiProfilesId,
      required this.img,
      @JsonKey(name: 'is_default') required this.isDefault});

  factory _$AiProfileImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiProfileImageImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'ai_profiles_id')
  final String aiProfilesId;
  @override
  final String img;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AiProfileImage(id: $id, aiProfilesId: $aiProfilesId, img: $img, isDefault: $isDefault)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AiProfileImage'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('aiProfilesId', aiProfilesId))
      ..add(DiagnosticsProperty('img', img))
      ..add(DiagnosticsProperty('isDefault', isDefault));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiProfileImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.aiProfilesId, aiProfilesId) ||
                other.aiProfilesId == aiProfilesId) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, aiProfilesId, img, isDefault);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AiProfileImageImplCopyWith<_$AiProfileImageImpl> get copyWith =>
      __$$AiProfileImageImplCopyWithImpl<_$AiProfileImageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiProfileImageImplToJson(
      this,
    );
  }
}

abstract class _AiProfileImage implements AiProfileImage {
  const factory _AiProfileImage(
          {required final String id,
          @JsonKey(name: 'ai_profiles_id') required final String aiProfilesId,
          required final String img,
          @JsonKey(name: 'is_default') required final bool isDefault}) =
      _$AiProfileImageImpl;

  factory _AiProfileImage.fromJson(Map<String, dynamic> json) =
      _$AiProfileImageImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'ai_profiles_id')
  String get aiProfilesId;
  @override
  String get img;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @JsonKey(ignore: true)
  _$$AiProfileImageImplCopyWith<_$AiProfileImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
