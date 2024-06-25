import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    @JsonKey(name: 'sender_id') required String senderId,
    required String message,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'receiver_id') String? receiverId,
    @JsonKey(name: 'sleep_order') bool? sleepOrder,
    String? image,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, Object?> json) => _$ChatMessageFromJson(json);
}

extension ChatMessageX on ChatMessage {
  String get formattedTime {
    return DateFormat('hh:mm a').format(createdAt.toLocal());
  }

  bool isMe(String profileId, String anonId) => senderId == profileId || senderId == anonId;
}

class SendMessageDto {
  final String message;
  final String profileId;
  final String conversationId;
  final String receiverId;
  final bool sleepOrder;
  final String? image;
  final int? itemsId;

  SendMessageDto({
    required this.message,
    required this.profileId,
    required this.conversationId,
    required this.receiverId,
    this.sleepOrder = false,
    this.image,
    this.itemsId,
  });

  SendMessageDto copyWith({
    String? message,
    String? profileId,
    String? conversationId,
    String? receiverId,
    bool? sleepOrder,
    String? image,
    int? itemsId,
  }) {
    return SendMessageDto(
      message: message ?? this.message,
      profileId: profileId ?? this.profileId,
      conversationId: conversationId ?? this.conversationId,
      receiverId: receiverId ?? this.receiverId,
      sleepOrder: sleepOrder ?? this.sleepOrder,
      image: image ?? this.image,
      itemsId: itemsId ?? this.itemsId,
    );
  }

  Map<String, Object?> toJson() => {
        'message': message,
        'sender_id': profileId,
        'conversations_id': conversationId,
        'receiver_id': receiverId,
        'ai_generated': false,
        'received': false,
        'sleep_order': sleepOrder,
        'image': image,
        'items_id': itemsId,
      };

  @override
  String toString() {
    return 'SendMessageDto(message: $message, profileId: $profileId, conversationId: $conversationId)';
  }
}
