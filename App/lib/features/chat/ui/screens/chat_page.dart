import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/chat/chat.dart';
import 'package:hookup4u2/features/chat/ui/widgets/send_message_box.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/constants/colors.dart';
import '../../../../common/providers/theme_provider.dart';

class ChatPage extends StatefulWidget {
  final Conversation conversation;

  const ChatPage({super.key, required this.conversation});

  static route(Conversation conversation) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ChatBloc(),
        child: ChatPage(conversation: conversation),
      ),
    );
  }

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RealtimeChannel? chatSub;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChat(widget.conversation.id));

    chatSub = supabaseClient
        .channel('public:chat_messages')
        .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'chat_messages',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'conversations_id',
              value: widget.conversation.id,
            ),
            callback: (payload) {
              final msg = ChatMessage.fromJson(payload.newRecord);

              if (msg.sleepOrder == false && msg.message.isNotEmpty) {
                context.read<ChatBloc>().add(
                      ChatMessageReceived(
                        msg,
                      ),
                    );
              }
            })
        .subscribe();
  }

  @override
  void dispose() {
    chatSub?.unsubscribe();

    super.dispose();
  }

  String? blockedBy;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        elevation: 0,
        title: Text(widget.conversation.aiProfile.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (ct) {
            return [
              PopupMenuItem(
                value: 'value1',
                child: InkWell(
                  onTap: () => showDialog(
                      barrierDismissible: true, context: context, builder: (_) => Container()),
                  // builder: (context) => ReportUser(
                  //       reported: widget.second,
                  //       reportedBy: widget.sender,
                  //     )).then((value) => Navigator.pop(ct)),
                  child: SizedBox(
                      width: 100,
                      height: 30,
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag_outlined,
                            color: themeProvider.isDarkMode ? Colors.white : primaryColor,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Report".tr().toString(),
                          ),
                        ],
                      )),
                ),
              ),
              PopupMenuItem(
                value: 'value3',
                child: InkWell(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: AlertDialog(
                          title: Text(
                            'Unmatch'.tr().toString(),
                            style: TextStyle(fontSize: 18, color: primaryColor),
                          ),
                          content: Text(
                              "Do you want to unmatch with".tr(
                                  args: [widget.conversation.aiProfile.name.toString()]).toString(),
                              style: const TextStyle(fontSize: 16)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(
                                'No'.tr().toString(),
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(ctx);
                                // await UserRepo.unmatchUser(widget.sender, widget.conversation.aiProfile.id!);
                                // TODO: update to profile
                                // context
                                //     .read<SearchUserBloc>()
                                //     .add(LoadUserEvent(currentUser: widget.sender));
                                // context
                                //     .read<MatchUserBloc>()
                                //     .add(LoadMatchUserEvent(currentUser: widget.sender));
                                // CustomSnackbar.showSnackBarSimple(
                                //     "unmatched"
                                //         .tr(args: ["${widget.conversation.aiProfile.name}".toString()]).toString(),
                                //     context);
                                Navigator.pop(context);
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => const Tabbar(null, false)));
                              },
                              child: Text(
                                'Yes'.tr().toString(),
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).then((value) => Navigator.pop(ct)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: themeProvider.isDarkMode ? Colors.white : primaryColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Unmatch".tr().toString(),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          })
        ],
      ),
      // body: Container(),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      // borderRadius: const BorderRadius.only(
                      //     topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                      color: Theme.of(context).primaryColor,
                      // borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 50, // Blur radius
                          offset: Offset(5, 0), // Shadow offset
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 20, // Blur radius
                          offset: Offset(-5, 0), // Shadow offset
                        ),
                      ],
                    ),
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is ChatLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is ChatError) {
                          return Center(
                            child: Text(state.message),
                          );
                        }

                        return MessageBox(
                          messages: state.chats,
                          conversation: widget.conversation,
                          isMoreLoading: state is ChatMoreLoading,
                          hasMoreMessages: !state.hasReachedEnd,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
