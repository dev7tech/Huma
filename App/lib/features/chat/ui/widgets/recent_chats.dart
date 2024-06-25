// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/models/user_model.dart';
import 'package:provider/provider.dart';
import '../../../../common/constants/colors.dart';
import '../../../../common/providers/theme_provider.dart';
import '../../../../common/widets/hookup_circularbar.dart';
import '../../../../config/app_config.dart';
import '../../../../models/chat_model.dart';
import '../../../match/bloc/match_bloc.dart';

class RecentChats extends StatefulWidget {
  final UserModel currentUser;
  final ScrollController scrollController;

  const RecentChats({
    super.key,
    required this.currentUser,
    required this.scrollController,
  });

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  String sortBy = 'time';
  bool _isLoadingMore = false;
  final bool _hasMoreMessages = true;
  int perPage = perPageData;
  late dynamic lastVisibleDocument;
  late List<dynamic> chats = [];

  @override
  void initState() {
    _loadInitialChats();
    widget.scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (widget.scrollController.offset >=
            widget.scrollController.position.maxScrollExtent * 0.90 &&
        !widget.scrollController.position.outOfRange) {
      if (_hasMoreMessages && !_isLoadingMore) {
        debugPrint("load more called");
        _loadMoreChats();
      }
    }
  }

  void _loadInitialChats() {
    // UserMessagingRepo.query(widget.currentUser, perPage).listen((snapshot) {
    //   if (mounted) {
    //     setState(() {
    //       chats = snapshot.docs;
    //       _hasMoreMessages = snapshot.docs.length == perPage;
    //       _isLoadingMore = false;
    //       lastVisibleDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    //     });
    //   }
    // });
  }

  void _loadMoreChats() async {
    setState(() {
      _isLoadingMore = true;
    });
    // final snapshot =
    //     await PaginationRepo.getMoreChats(perPage, lastVisibleDocument, widget.currentUser);
    // setState(() {
    //   chats.addAll(snapshot.docs);
    //   _hasMoreMessages = snapshot.docs.length == perPage;
    //   _isLoadingMore = false;
    //   lastVisibleDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return BlocBuilder<MatchUserBloc, MatchUserState>(
      builder: (context, state) {
        if (state is MatchUserLoadingState) {
          debugPrint("i am in matchuserloading");
          return Hookup4uBar();
        }
        if (state is MatchUserFailedState) {
          debugPrint("I AM IN LOADUSERSFailed");
          return Center(
              child: Text(
            "Error to load data.".tr().toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black54,
                fontStyle: FontStyle.normal,
                letterSpacing: 1,
                decoration: TextDecoration.none,
                fontSize: 18),
          ));
        }
        if (state is MatchUserLoadedState) {
          debugPrint("FROM RECENT CHATS SUCCESS");

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: chats.isEmpty
                ? Center(
                    child: Text(
                      "No Recent chat found".tr().toString(),
                      style: TextStyle(color: secondaryColor, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    controller: widget.scrollController,
                    padding: EdgeInsets.all(0),
                    itemCount: chats.length + 1,
                    itemBuilder: (context, index) {
                      if (index == chats.length) {
                        // Last item in the ListView
                        return Column(
                          children: [
                            if (_isLoadingMore)
                              SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: const Hookup4uBar()),
                            SizedBox(
                              height: 20,
                            ),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(right: 15.0, left: 15),
                            //   child: Divider(
                            //     color: themeProvider.isDarkMode
                            //         ? Colors.grey.shade700
                            //         : secondryColor.withOpacity(0.30),
                            //   ),
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Icon(
                            //       Icons.check_box,
                            //       size: 16,
                            //       color: themeProvider.isDarkMode
                            //           ? Colors.grey.shade700
                            //           : Colors.grey.shade400,
                            //     ),
                            //     SizedBox(
                            //       width: 5,
                            //     ),
                            //     Text(
                            //       "Your recent chats are end here"
                            //           .tr()
                            //           .toString(),
                            //       style: TextStyle(
                            //         color: themeProvider.isDarkMode
                            //             ? Colors.grey.shade700
                            //             : Colors.grey.shade400,
                            //         fontSize: 14.0,
                            //         fontWeight: FontWeight.w400,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        );
                      } else {
                        final data = chats[index].data();
                        debugPrint(" lastmessage data is ${data.toString()}");
                        ChatModel chat = ChatModel?.from(data);

                        // return FutureBuilder(
                        //   future: UserMessagingRepo.getChatUserDetails(
                        //     userId: chat.receiverId != widget.currentUser.id
                        //         ? chat.receiverId
                        //         : chat.senderId,
                        //   ),
                        //   builder: (context, AsyncSnapshot<UserModel> snapshot2) {
                        //     if (!snapshot2.hasData) {
                        //       return SizedBox.shrink();
                        //     } else if (snapshot2.data != null) {
                        //       debugPrint(" userdetails ${snapshot2.data!.toString()}");
                        //       if (_isLoadingMore) const Hookup4uBar();
                        //       return SingleChatTile(
                        //         tempUser: snapshot2.data!,
                        //         chat: chat,
                        //         chatId: chatId(widget.currentUser, snapshot2.data),
                        //         currentUser: widget.currentUser,
                        //       );
                        //     }
                        //     return Padding(
                        //       padding: const EdgeInsets.only(top: 80.0),
                        //       child: Center(
                        //         child: Text(
                        //           "No Recent chat found".tr().toString(),
                        //           style: TextStyle(
                        //             color: secondaryColor,
                        //             fontSize: 16,
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                      }
                      return null;
                    },
                  ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Center(
              child: Text(
            "No recent chat found".tr().toString(),
            style: TextStyle(color: secondaryColor, fontSize: 16),
          )),
        );
      },
    );
  }
}
