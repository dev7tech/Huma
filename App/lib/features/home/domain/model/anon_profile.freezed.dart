// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anon_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnonProfile _$AnonProfileFromJson(Map<String, dynamic> json) {
  return _AnonProfile.fromJson(json);
}

/// @nodoc
mixin _$AnonProfile {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnonProfileCopyWith<AnonProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonProfileCopyWith<$Res> {
  factory $AnonProfileCopyWith(
          AnonProfile value, $Res Function(AnonProfile) then) =
      _$AnonProfileCopyWithImpl<$Res, AnonProfile>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$AnonProfileCopyWithImpl<$Res, $Val extends AnonProfile>
    implements $AnonProfileCopyWith<$Res> {
  _$AnonProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnonProfileImplCopyWith<$Res>
    implements $AnonProfileCopyWith<$Res> {
  factory _$$AnonProfileImplCopyWith(
          _$AnonProfileImpl value, $Res Function(_$AnonProfileImpl) then) =
      __$$AnonProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$AnonProfileImplCopyWithImpl<$Res>
    extends _$AnonProfileCopyWithImpl<$Res, _$AnonProfileImpl>
    implements _$$AnonProfileImplCopyWith<$Res> {
  __$$AnonProfileImplCopyWithImpl(
      _$AnonProfileImpl _value, $Res Function(_$AnonProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$AnonProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonProfileImpl with DiagnosticableTreeMixin implements _AnonProfile {
  const _$AnonProfileImpl({required this.id, required this.name});

  factory _$AnonProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnonProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AnonProfile(id: $id, name: $name)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AnonProfile'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonProfileImplCopyWith<_$AnonProfileImpl> get copyWith =>
      __$$AnonProfileImplCopyWithImpl<_$AnonProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonProfileImplToJson(
      this,
    );
  }
}

abstract class _AnonProfile implements AnonProfile {
  const factory _AnonProfile(
      {required final String id,
      required final String name}) = _$AnonProfileImpl;

  factory _AnonProfile.fromJson(Map<String, dynamic> json) =
      _$AnonProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$AnonProfileImplCopyWith<_$AnonProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
