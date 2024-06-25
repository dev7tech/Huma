import 'package:flutter/material.dart';
import 'package:hookup4u2/features/ai/domain/models/ai_profile.dart';
import 'package:hookup4u2/features/chat/domain/models/conversation.dart';
import 'package:hookup4u2/features/chat/ui/screens/chat_page.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: conversation.aiProfile.profileImg == null
          ? const CircleAvatar(
              radius: 20,
              child: Icon(Icons.person),
            )
          : Container(
              margin: const EdgeInsets.only(right: 10),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade600,
                image: conversation.aiProfile.profileImg == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(conversation.aiProfile.profileImg!),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
      title: Text(conversation.aiProfile.name),
      subtitle: Text(conversation.lastMessage ?? ''),
      trailing: Text(conversation.formattedTime),
      onTap: () {
        Navigator.of(context).push(ChatPage.route(conversation));
      },
    );
  }
}

class ChatListItemSkeleton extends StatelessWidget {
  const ChatListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 12,
                  width: double.infinity,
                  color: Colors.grey[700],
                  margin: const EdgeInsets.only(bottom: 4),
                ),
                Container(
                  height: 8,
                  width: 120,
                  color: Colors.grey[700],
                  margin: const EdgeInsets.only(bottom: 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
