import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u2/common/constants/colors.dart';
import 'package:hookup4u2/features/ai/domain/models/ai_profile.dart';
import 'package:hookup4u2/features/chat/domain/models/chat_message.dart';

const double radius = 7.5;

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isMe,
      this.aiProfile,
      this.bottomMargin = 0,
      this.topMargin = 2});

  final ChatMessage message;
  final AiProfile? aiProfile;
  final bool isMe;
  final double bottomMargin;
  final double topMargin;

  @override
  Widget build(BuildContext context) {
    final senderBg = secondaryColor.withOpacity(.5);
    final receiverBg = secondaryColor.withOpacity(.3);

    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10, bottom: bottomMargin, top: topMargin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe && aiProfile != null)
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade600,
                image: aiProfile!.profileImg == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(aiProfile!.profileImg!),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (message.image != null)
                  Container(
                    // color: Colors.red,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: kIsWeb
                              ? Image.network(
                                  message.image!,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: message.image!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(),
                                ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: isMe ? senderBg : receiverBg,
                    borderRadius: isMe
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomLeft: Radius.circular(radius),
                            topRight: Radius.circular(radius),
                          )
                        : const BorderRadius.only(
                            bottomLeft: Radius.circular(radius),
                            bottomRight: Radius.circular(radius),
                            topRight: Radius.circular(radius),
                          ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            children: [
                              Text(
                                message.message,
                                style: const TextStyle(
                                  color: Colors.white,
                                  // color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        message.formattedTime,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
