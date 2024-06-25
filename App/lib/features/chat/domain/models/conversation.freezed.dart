// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_profiles_id')
  String get aiProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'profiles_id')
  String? get profilesId => throw _privateConstructorUsedError;
  @JsonKey(name: 'anon_profiles_id')
  String? get anonProfilesId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message')
  String? get lastMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message_at')
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_profiles')
  AiProfile get aiProfile => throw _privateConstructorUsedError;
  String? get waiting => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'ai_profiles_id') String aiProfileId,
      @JsonKey(name: 'profiles_id') String? profilesId,
      @JsonKey(name: 'anon_profiles_id') String? anonProfilesId,
      String type,
      @JsonKey(name: 'last_message') String? lastMessage,
      @JsonKey(name: 'last_message_at') DateTime? lastMessageAt,
      @JsonKey(name: 'ai_profiles') AiProfile aiProfile,
      String? waiting});

  $AiProfileCopyWith<$Res> get aiProfile;
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? aiProfileId = null,
    Object? profilesId = freezed,
    Object? anonProfilesId = freezed,
    Object? type = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? aiProfile = null,
    Object? waiting = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      aiProfileId: null == aiProfileId
          ? _value.aiProfileId
          : aiProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      profilesId: freezed == profilesId
          ? _value.profilesId
          : profilesId // ignore: cast_nullable_to_non_nullable
              as String?,
      anonProfilesId: freezed == anonProfilesId
          ? _value.anonProfilesId
          : anonProfilesId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      aiProfile: null == aiProfile
          ? _value.aiProfile
          : aiProfile // ignore: cast_nullable_to_non_nullable
              as AiProfile,
      waiting: freezed == waiting
          ? _value.waiting
          : waiting // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AiProfileCopyWith<$Res> get aiProfile {
    return $AiProfileCopyWith<$Res>(_value.aiProfile, (value) {
      return _then(_value.copyWith(aiProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
          _$ConversationImpl value, $Res Function(_$ConversationImpl) then) =
      __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'ai_profiles_id') String aiProfileId,
      @JsonKey(name: 'profiles_id') String? profilesId,
      @JsonKey(name: 'anon_profiles_id') String? anonProfilesId,
      String type,
      @JsonKey(name: 'last_message') String? lastMessage,
      @JsonKey(name: 'last_message_at') DateTime? lastMessageAt,
      @JsonKey(name: 'ai_profiles') AiProfile aiProfile,
      String? waiting});

  @override
  $AiProfileCopyWith<$Res> get aiProfile;
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
      _$ConversationImpl _value, $Res Function(_$ConversationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? aiProfileId = null,
    Object? profilesId = freezed,
    Object? anonProfilesId = freezed,
    Object? type = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? aiProfile = null,
    Object? waiting = freezed,
  }) {
    return _then(_$ConversationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      aiProfileId: null == aiProfileId
          ? _value.aiProfileId
          : aiProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      profilesId: freezed == profilesId
          ? _value.profilesId
          : profilesId // ignore: cast_nullable_to_non_nullable
              as String?,
      anonProfilesId: freezed == anonProfilesId
          ? _value.anonProfilesId
          : anonProfilesId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      aiProfile: null == aiProfile
          ? _value.aiProfile
          : aiProfile // ignore: cast_nullable_to_non_nullable
              as AiProfile,
      waiting: freezed == waiting
          ? _value.waiting
          : waiting // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl with DiagnosticableTreeMixin implements _Conversation {
  const _$ConversationImpl(
      {required this.id,
      @JsonKey(name: 'ai_profiles_id') required this.aiProfileId,
      @JsonKey(name: 'profiles_id') this.profilesId,
      @JsonKey(name: 'anon_profiles_id') this.anonProfilesId,
      required this.type,
      @JsonKey(name: 'last_message') this.lastMessage,
      @JsonKey(name: 'last_message_at') this.lastMessageAt,
      @JsonKey(name: 'ai_profiles') required this.aiProfile,
      this.waiting});

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'ai_profiles_id')
  final String aiProfileId;
  @override
  @JsonKey(name: 'profiles_id')
  final String? profilesId;
  @override
  @JsonKey(name: 'anon_profiles_id')
  final String? anonProfilesId;
  @override
  final String type;
  @override
  @JsonKey(name: 'last_message')
  final String? lastMessage;
  @override
  @JsonKey(name: 'last_message_at')
  final DateTime? lastMessageAt;
  @override
  @JsonKey(name: 'ai_profiles')
  final AiProfile aiProfile;
  @override
  final String? waiting;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Conversation(id: $id, aiProfileId: $aiProfileId, profilesId: $profilesId, anonProfilesId: $anonProfilesId, type: $type, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, aiProfile: $aiProfile, waiting: $waiting)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Conversation'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('aiProfileId', aiProfileId))
      ..add(DiagnosticsProperty('profilesId', profilesId))
      ..add(DiagnosticsProperty('anonProfilesId', anonProfilesId))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('lastMessage', lastMessage))
      ..add(DiagnosticsProperty('lastMessageAt', lastMessageAt))
      ..add(DiagnosticsProperty('aiProfile', aiProfile))
      ..add(DiagnosticsProperty('waiting', waiting));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.aiProfileId, aiProfileId) ||
                other.aiProfileId == aiProfileId) &&
            (identical(other.profilesId, profilesId) ||
                other.profilesId == profilesId) &&
            (identical(other.anonProfilesId, anonProfilesId) ||
                other.anonProfilesId == anonProfilesId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.aiProfile, aiProfile) ||
                other.aiProfile == aiProfile) &&
            (identical(other.waiting, waiting) || other.waiting == waiting));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, aiProfileId, profilesId,
      anonProfilesId, type, lastMessage, lastMessageAt, aiProfile, waiting);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(
      this,
    );
  }
}

abstract class _Conversation implements Conversation {
  const factory _Conversation(
      {required final String id,
      @JsonKey(name: 'ai_profiles_id') required final String aiProfileId,
      @JsonKey(name: 'profiles_id') final String? profilesId,
      @JsonKey(name: 'anon_profiles_id') final String? anonProfilesId,
      required final String type,
      @JsonKey(name: 'last_message') final String? lastMessage,
      @JsonKey(name: 'last_message_at') final DateTime? lastMessageAt,
      @JsonKey(name: 'ai_profiles') required final AiProfile aiProfile,
      final String? waiting}) = _$ConversationImpl;

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'ai_profiles_id')
  String get aiProfileId;
  @override
  @JsonKey(name: 'profiles_id')
  String? get profilesId;
  @override
  @JsonKey(name: 'anon_profiles_id')
  String? get anonProfilesId;
  @override
  String get type;
  @override
  @JsonKey(name: 'last_message')
  String? get lastMessage;
  @override
  @JsonKey(name: 'last_message_at')
  DateTime? get lastMessageAt;
  @override
  @JsonKey(name: 'ai_profiles')
  AiProfile get aiProfile;
  @override
  String? get waiting;
  @override
  @JsonKey(ignore: true)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
