import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookup4u2/features/chat/domain/models/chat_message.dart';
import 'package:hookup4u2/models/user_model.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants/colors.dart';
import '../../../../common/providers/theme_provider.dart';
import '../../../../common/utils/custom_toast.dart';

// class ChatMessageRead {
//   static messagesIsRead(documentSnapshot, UserModel second, sender, BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//   }
// }

class ReceiverMessage extends StatelessWidget {
  const ReceiverMessage({
    super.key,
    required this.message,
    required this.user,
  });

  final ChatMessage message;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                  backgroundColor: secondaryColor,
                  radius: 25.0,
                  backgroundImage: NetworkImage(user.imageUrl![0] ?? ''),
                ),
              ),
              onTap: () => showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return Container();
                    // return Info(
                    //   second,
                    //   sender,
                    //   false,
                    //   fromChatPage: true,
                    // );
                  }),
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: message.message));
                    CustomToast.showToast('Message Copied'.tr().toString());
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      width: MediaQuery.of(context).size.width * 0.65,
                      // margin: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10),
                      decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(.3),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            message.message,
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                message.formattedTime,
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// InkWell(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             Container(
//                               margin: const EdgeInsets.only(top: 2.0, bottom: 2.0, right: 15),
//                               height: 150,
//                               width: 150.0,
//                               color: const Color.fromRGBO(0, 0, 0, 0.2),
//                               padding: const EdgeInsets.all(5),
//                               child: CustomCNImage(
//                                 height: MediaQuery.of(context).size.height * .65,
//                                 width: MediaQuery.of(context).size.width * .9,
//                                 imageUrl: documentSnapshot.data()!['image_url'] ?? '',
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(right: 10),
//                               child: Text(
//                                   documentSnapshot.data()!["time"] != null
//                                       ? DateFormat.yMMMd('en_US')
//                                           .add_jm()
//                                           .format(documentSnapshot.data()!["time"].toDate())
//                                           .toString()
//                                       : "",
//                                   style: TextStyle(
//                                     color: secondaryColor,
//                                     fontSize: 13.0,
//                                     fontWeight: FontWeight.w600,
//                                   )),
//                             )
//                           ],
//                         ),
//                         onTap: () {
//                           Navigator.pushNamed(context, RouteName.largeImageScreen,
//                               arguments: documentSnapshot.get('image_url'));
//                         },
//                       )
