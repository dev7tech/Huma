import '../../../models/user_model.dart';

class PaginationRepo {
  static updateNotification(UserModel currentUser, dynamic doc) {
    // db
    //     .collection("/Users/${currentUser.id}/Matches")
    //     .doc('${doc.get("Matches")}')
    //     .update({'isRead': true});
  }

  // static Stream<dynamic> listenForNotifications(int perPage, dynamic notificationReference) {
  // return notificationReference
  //     .orderBy('timestamp', descending: true)
  //     .limit(perPage)
  // .snapshots();
  // }

  // static Stream<QuerySnapshot> listenForMessages(int perPage, dynamic chatReference) {
  //   return chatReference.orderBy('time', descending: true).limit(perPage).snapshots();
  // }

  // static Future<QuerySnapshot> getMoreNotifications(
  //     int perPage, DocumentSnapshot? lastVisibleDocument, dynamic notificationReference) async {
  //   QuerySnapshot snapshot = await notificationReference
  //       .orderBy('timestamp', descending: true)
  //       .startAfterDocument(lastVisibleDocument!)
  //       .limit(perPage)
  //       .get();

  //   return snapshot;
  // }

  // static Future<QuerySnapshot> getMoreMessages(
  //     int perPage, DocumentSnapshot? lastVisibleDocument, dynamic chatReference) async {
  //   QuerySnapshot snapshot = await chatReference
  //       .orderBy('time', descending: true)
  //       .startAfterDocument(lastVisibleDocument!)
  //       .limit(perPage)
  //       .get();

  //   return snapshot;
  // }

  // static Future<QuerySnapshot> getMoreChats(
  //     int perPage, DocumentSnapshot? lastVisibleDocument, UserModel currentUser) async {
  //   QuerySnapshot snapshot = await db
  //       .collection('chats')
  //       .where('users', arrayContains: currentUser.id)
  //       .where(
  //         'unmatched',
  //         isEqualTo: false,
  //       )
  //       .orderBy('time', descending: true)
  //       .startAfterDocument(lastVisibleDocument!)
  //       .limit(perPage)
  //       .get();

  //   return snapshot;
  // }
}
