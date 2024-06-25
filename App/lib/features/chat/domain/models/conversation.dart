import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hookup4u2/features/ai/domain/models/ai_profile.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    @JsonKey(name: 'ai_profiles_id') required String aiProfileId,
    @JsonKey(name: 'profiles_id') String? profilesId,
    @JsonKey(name: 'anon_profiles_id') String? anonProfilesId,
    required String type,
    @JsonKey(name: 'last_message') String? lastMessage,
    @JsonKey(name: 'last_message_at') DateTime? lastMessageAt,
    @JsonKey(name: 'ai_profiles') required AiProfile aiProfile,
    String? waiting,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, Object?> json) => _$ConversationFromJson(json);
}

extension ConversationX on Conversation {
  String get formattedTime {
    if (lastMessageAt == null) {
      return '';
    }

    final diff = DateTime.now().difference(lastMessageAt!);

    if (diff.inDays == 0) {
      return DateFormat('hh:mm a').format(lastMessageAt!);
    }
    if (diff.inDays < 7) {
      return DateFormat('E').format(lastMessageAt!);
    }

    return DateFormat('MM/dd/yyyy').format(lastMessageAt!);
  }

  bool anonIsMe(String anonId) {
    return type == 'anon' && anonProfilesId == anonId;
  }
}
