// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      receiverId: json['receiver_id'] as String?,
      sleepOrder: json['sleep_order'] as bool?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      'message': instance.message,
      'created_at': instance.createdAt.toIso8601String(),
      'receiver_id': instance.receiverId,
      'sleep_order': instance.sleepOrder,
      'image': instance.image,
    };
