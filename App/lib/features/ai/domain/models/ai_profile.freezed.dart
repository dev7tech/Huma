// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AiProfile _$AiProfileFromJson(Map<String, dynamic> json) {
  return _AiProfile.fromJson(json);
}

/// @nodoc
mixin _$AiProfile {
  String get id => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get ambitions => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_profile_images')
  List<AiProfileImage>? get images => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AiProfileCopyWith<AiProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiProfileCopyWith<$Res> {
  factory $AiProfileCopyWith(AiProfile value, $Res Function(AiProfile) then) =
      _$AiProfileCopyWithImpl<$Res, AiProfile>;
  @useResult
  $Res call(
      {String id,
      int age,
      String name,
      String location,
      String ambitions,
      @JsonKey(name: 'ai_profile_images') List<AiProfileImage>? images});
}

/// @nodoc
class _$AiProfileCopyWithImpl<$Res, $Val extends AiProfile>
    implements $AiProfileCopyWith<$Res> {
  _$AiProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? age = null,
    Object? name = null,
    Object? location = null,
    Object? ambitions = null,
    Object? images = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      ambitions: null == ambitions
          ? _value.ambitions
          : ambitions // ignore: cast_nullable_to_non_nullable
              as String,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<AiProfileImage>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiProfileImplCopyWith<$Res>
    implements $AiProfileCopyWith<$Res> {
  factory _$$AiProfileImplCopyWith(
          _$AiProfileImpl value, $Res Function(_$AiProfileImpl) then) =
      __$$AiProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int age,
      String name,
      String location,
      String ambitions,
      @JsonKey(name: 'ai_profile_images') List<AiProfileImage>? images});
}

/// @nodoc
class __$$AiProfileImplCopyWithImpl<$Res>
    extends _$AiProfileCopyWithImpl<$Res, _$AiProfileImpl>
    implements _$$AiProfileImplCopyWith<$Res> {
  __$$AiProfileImplCopyWithImpl(
      _$AiProfileImpl _value, $Res Function(_$AiProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? age = null,
    Object? name = null,
    Object? location = null,
    Object? ambitions = null,
    Object? images = freezed,
  }) {
    return _then(_$AiProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      ambitions: null == ambitions
          ? _value.ambitions
          : ambitions // ignore: cast_nullable_to_non_nullable
              as String,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<AiProfileImage>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiProfileImpl with DiagnosticableTreeMixin implements _AiProfile {
  const _$AiProfileImpl(
      {required this.id,
      required this.age,
      required this.name,
      required this.location,
      required this.ambitions,
      @JsonKey(name: 'ai_profile_images') final List<AiProfileImage>? images})
      : _images = images;

  factory _$AiProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiProfileImplFromJson(json);

  @override
  final String id;
  @override
  final int age;
  @override
  final String name;
  @override
  final String location;
  @override
  final String ambitions;
  final List<AiProfileImage>? _images;
  @override
  @JsonKey(name: 'ai_profile_images')
  List<AiProfileImage>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AiProfile(id: $id, age: $age, name: $name, location: $location, ambitions: $ambitions, images: $images)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AiProfile'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('age', age))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('ambitions', ambitions))
      ..add(DiagnosticsProperty('images', images));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.ambitions, ambitions) ||
                other.ambitions == ambitions) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, age, name, location,
      ambitions, const DeepCollectionEquality().hash(_images));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AiProfileImplCopyWith<_$AiProfileImpl> get copyWith =>
      __$$AiProfileImplCopyWithImpl<_$AiProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiProfileImplToJson(
      this,
    );
  }
}

abstract class _AiProfile implements AiProfile {
  const factory _AiProfile(
      {required final String id,
      required final int age,
      required final String name,
      required final String location,
      required final String ambitions,
      @JsonKey(name: 'ai_profile_images')
      final List<AiProfileImage>? images}) = _$AiProfileImpl;

  factory _AiProfile.fromJson(Map<String, dynamic> json) =
      _$AiProfileImpl.fromJson;

  @override
  String get id;
  @override
  int get age;
  @override
  String get name;
  @override
  String get location;
  @override
  String get ambitions;
  @override
  @JsonKey(name: 'ai_profile_images')
  List<AiProfileImage>? get images;
  @override
  @JsonKey(ignore: true)
  _$$AiProfileImplCopyWith<_$AiProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
