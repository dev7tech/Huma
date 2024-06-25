import 'package:hookup4u2/features/chat/domain/models/chat_message.dart';

const kClearChatAfterMinutes = 60;

class ChatMessageRepo {
  bool shouldClear(ChatMessage lastMessage) {
    final diffMins = DateTime.now().difference(lastMessage.createdAt).inMinutes;

    return diffMins > kClearChatAfterMinutes;
  }
}
