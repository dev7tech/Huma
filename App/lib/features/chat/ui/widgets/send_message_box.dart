import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/features/auth/auth_status/bloc/registration/bloc/registration_bloc.dart';
import 'package:hookup4u2/features/chat/bloc/purchase_item_bloc.dart';
import 'package:hookup4u2/features/chat/chat.dart';
import 'package:hookup4u2/features/chat/ui/widgets/chat_bubble.dart';
import 'package:hookup4u2/features/chat/ui/widgets/items_box.dart';
import 'package:hookup4u2/features/chat/ui/widgets/send_message_btn.dart';
import 'package:hookup4u2/features/home/domain/repo/anon_convo_repo.dart';

class MessageBox extends StatefulWidget {
  final Conversation conversation;
  final List<ChatMessage> messages;
  final bool isMoreLoading;
  final bool hasMoreMessages;

  const MessageBox(
      {super.key,
      required this.conversation,
      required this.messages,
      required this.hasMoreMessages,
      this.isMoreLoading = false});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  bool isBlocked = false;
  bool isItemsBoxExpanded = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent * 0.9 &&
        !_scrollController.position.outOfRange) {
      if (widget.hasMoreMessages && widget.messages.isNotEmpty) {
        context.read<ChatBloc>().add(LoadMoreChat(widget.conversation.id, widget.messages.last));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.messages;
    final profile = context.select((RegistrationBloc bloc) => bloc.state.profile);

    return BlocListener<PurchaseItemBloc, PurchaseItemState>(
      listener: (context, state) {
        if (state is PurchaseItemSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gift sent!'),
            ),
          );
          setState(() {
            isItemsBoxExpanded = false;
          });
        } else if (state is PurchaseItemFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send gift: ${state.error}'),
            ),
          );
        }
      },
      child: FutureBuilder(
          future: context.read<AnonConvoRepo>().getUuid(),
          builder: (context, snap) {
            final String anonId = snap.data ?? '';

            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    // topLeft: Radius.circular(50.0),
                    // topRight: Radius.circular(50.0),
                    ),
                child: Container(
                  // decoration: BoxDecoration(
                  //   borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                  //   color: Theme.of(context).primaryColor,
                  //   // color: Colors.grey.shade700,
                  //   // borderRadius: BorderRadius.circular(15),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.blue.withOpacity(0.5), // Shadow color
                  //       spreadRadius: 3, // Spread radius
                  //       blurRadius: 50, // Blur radius
                  //       offset: Offset(5, 0), // Shadow offset
                  //     ),
                  //     BoxShadow(
                  //       color: Colors.blue.withOpacity(0.5), // Shadow color
                  //       spreadRadius: 3, // Spread radius
                  //       blurRadius: 20, // Blur radius
                  //       offset: Offset(-5, 0), // Shadow offset
                  //     ),
                  //   ],
                  // ),
                  // decoration: BoxDecoration(
                  //     borderRadius: const BorderRadius.only(
                  //         topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                  //     color: Theme.of(context).primaryColor),
                  padding: const EdgeInsets.all(5),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              reverse: true,
                              controller: _scrollController,
                              itemCount: messages.length,
                              padding: const EdgeInsets.only(bottom: 10),
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final largeMargin = isNextDifferent(messages, index,
                                    message.isMe(profile.id, anonId), profile.id, anonId);

                                return ChatBubble(
                                  message: message,
                                  isMe: message.isMe(profile.id, anonId),
                                  bottomMargin: index == 0 ? 20 : 0,
                                  topMargin: largeMargin ? 20 : 4,
                                  aiProfile: message.isMe(profile.id, anonId)
                                      ? null
                                      : widget.conversation.aiProfile,
                                );
                              },
                            ),
                          ),
                          Column(
                            children: [
                              SendMessageBtn(
                                conversation: widget.conversation,
                                onSend: (message, image) async {
                                  final anonConvoRepo = context.read<AnonConvoRepo>();
                                  final profileId =
                                      profile.isEmpty ? await anonConvoRepo.getUuid() : profile.id;

                                  context.read<SendMessageBloc>().add(
                                        SendMessage(
                                          SendMessageDto(
                                            receiverId: widget.conversation.aiProfileId,
                                            conversationId: widget.conversation.id,
                                            message: message,
                                            profileId: profileId,
                                            image: image,
                                          ),
                                          messages.isEmpty ? null : messages.first,
                                        ),
                                      );
                                },
                                onTapGift: () => setState(() {
                                  isItemsBoxExpanded = !isItemsBoxExpanded;
                                }),
                                isGiftOpen: isItemsBoxExpanded,
                              ),
                              ItemsBox(
                                  isExpanded: isItemsBoxExpanded,
                                  conversation: widget.conversation),
                            ],
                          ),
                          // Container(
                          //   alignment: Alignment.bottomCenter,
                          //   decoration: const BoxDecoration(color: Colors.transparent),
                          //   child: isBlocked
                          //       ? blockedBy == widget.sender.id
                          //           ? Text("you blocked this user!".tr().toString())
                          //           : Text("${widget.second.name} blocked you!".tr().toString())
                          //       : _buildTextComposer(),
                          // ),
                        ],
                      ),
                      if (widget.isMoreLoading)
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 22,
                            width: 22,
                            child: const CircularProgressIndicator(),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  isNextDifferent(
      List<ChatMessage> messages, int index, bool currentIsMe, String profileId, String anonId) {
    if (index < messages.length - 1) {
      final nextIsMe = messages[index + 1].isMe(profileId, anonId);
      return nextIsMe != currentIsMe;
    }

    return false;
  }
}
