// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['id'] as String,
      aiProfileId: json['ai_profiles_id'] as String,
      profilesId: json['profiles_id'] as String?,
      anonProfilesId: json['anon_profiles_id'] as String?,
      type: json['type'] as String,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] == null
          ? null
          : DateTime.parse(json['last_message_at'] as String),
      aiProfile:
          AiProfile.fromJson(json['ai_profiles'] as Map<String, dynamic>),
      waiting: json['waiting'] as String?,
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ai_profiles_id': instance.aiProfileId,
      'profiles_id': instance.profilesId,
      'anon_profiles_id': instance.anonProfilesId,
      'type': instance.type,
      'last_message': instance.lastMessage,
      'last_message_at': instance.lastMessageAt?.toIso8601String(),
      'ai_profiles': instance.aiProfile,
      'waiting': instance.waiting,
    };
