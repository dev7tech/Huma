import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class CallingRepo {
  // static CollectionReference callRef = db.collection("calls");

  static addCallingData(channelName, callType) async {
    // await callRef.doc(channelName).delete().then((_) async {
    //   await callRef.doc(channelName).set({
    //     'callType': callType,
    //     'calling': true,
    //     'response': "Awaiting",
    //     'channel_id': channelName,
    //     'last_call': FieldValue.serverTimestamp()
    //   });
    // });
  }

  static Future<void> onJoin(callType, bool isBlocked, String chatId, senderId,
      BuildContext context, UserModel second) async {
    // if (!isBlocked) {
    //   await db.collection("chats").doc(chatId).collection('messages').add({
    //     'type': 'Call',
    //     'text': callType,
    //     'sender_id': senderId,
    //     'receiver_id': second.id,
    //     'isRead': false,
    //     'image_url': "",
    //     'time': FieldValue.serverTimestamp(),
    //     'users': [second.id, senderId],
    //     'unmatched': false
    //   }).then((value) {
    //     db.collection('chats').doc(chatId).set({
    //       'text': callType,
    //       'isRead': false,
    //       'sender_id': senderId,
    //       'receiver_id': second.id,
    //       'type': 'Call',
    //       'users': [second.id, senderId],
    //       'unmatched': false,
    //       'time': FieldValue.serverTimestamp()
    //     }, SetOptions(merge: true));
    //   });

    //   db
    //       .collection("chats")
    //       .doc(chatId)
    //       .collection('messages')
    //       .doc("blocked")
    //       .get()
    //       .then((blockedDocSnapshot) {
    //     if (!blockedDocSnapshot.exists) {
    //       // Add the "blocked" document to chatReference collection
    //       db
    //           .collection("chats")
    //           .doc(chatId)
    //           .collection('messages')
    //           .doc("blocked")
    //           .set({
    //         'isBlocked': false,
    //         'blockedBy': '',
    //       });
    //     }
    //   }).catchError((error) {
    //     debugPrint("Error checking if blocked document exists: $error");
    //   });

    //   // ignore: use_build_context_synchronously
    //   await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => DialCall(
    //           channelName: chatId, receiver: second, callType: callType),
    //     ),
    //   );
    // } else {
    //   CustomSnackbar.showSnackBarSimple("Blocked!".tr().toString(), context);
    // }
  }
}
