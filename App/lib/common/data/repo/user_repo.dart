import 'package:flutter/cupertino.dart';
import '../../../models/user_model.dart';

// TODO: remove
class UserRepo {
  static const userId = '20';

  static Future<void> updateData(Map editInfo) async {
    // debugPrint('editinfo-----------$editInfo');
    // try {
    //   await firebaseFireStoreInstance
    //       .collection("Users")
    //       .doc(userId)
    //       .set({'editInfo': editInfo}, SetOptions(merge: true));
    //   debugPrint('User data updated successfully');
    // } catch (e) {
    //   debugPrint('Failed to update user data: $e');
    //   rethrow;
    // }
  }

  static Future updatefilter(Map<String, dynamic> changeValues) async {
    debugPrint('filterinfo-----------$changeValues');
    // try {
    //   await firebaseFireStoreInstance
    //       .collection("Users")
    //       .doc(userId)
    //       .set(changeValues, SetOptions(merge: true));
    //   debugPrint('User filter updated successfully');
    // } catch (e) {
    //   debugPrint('Failed to update user filter: $e');
    //   rethrow;
    // }
  }

// For unmatch user after match
  static Future unmatchUser(UserModel currentUser, String userId) async {
    // var collectionRefrence = firebaseFireStoreInstance.collection("Users");
    // var chatCollection = firebaseFireStoreInstance.collection("chats");
    // await collectionRefrence.doc(currentUser.id).collection('CheckedUser').doc(userId).delete();
    // await collectionRefrence.doc(userId).collection('CheckedUser').doc(currentUser.id).delete();
    // await collectionRefrence.doc(currentUser.id).collection('LikedBy').doc(userId).delete();
    // await collectionRefrence.doc(userId).collection('LikedBy').doc(currentUser.id).delete();
    // await collectionRefrence.doc(currentUser.id).collection('Matches').doc(userId).delete();
    // await collectionRefrence.doc(userId).collection('Matches').doc(currentUser.id).delete();
    // await chatCollection.doc(chatId1(currentUser, userId)).delete();
  }

  static String chatId1(UserModel currentUser, String userId) {
    if (currentUser.id.hashCode <= userId.hashCode) {
      return '${currentUser.id}-$userId';
    } else {
      return '$userId-${currentUser.id}';
    }
  }

  // for storing street view data

  static Future streetviewfilter(String option, List<String> userIds) async {
    debugPrint('filterinfo-----------$userIds');
    // try {
    //   // Create a reference to the user's document in Firestore.
    //   DocumentReference userDocRef = firebaseFireStoreInstance.collection('Users').doc(userId);
    //   await userDocRef.update({
    //     'streetView': {
    //       'option': option,
    //       'userIds': userIds,
    //     },
    //   });
    //   debugPrint('street  filter updated successfully');
    // } catch (e) {
    //   debugPrint('Failed to update user filter: $e');
    //   rethrow;
    // }
  }

  static Future<Map<String, dynamic>> getStreetViewData(String userId) async {
    // try {
    //   dynamic? user = null;
    //   if (user != null) {
    //     DocumentSnapshot userSnapshot =
    //         await firebaseFireStoreInstance.collection('Users').doc(userId).get();
    //     Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

    //     if (userData != null && userData.containsKey('streetView')) {
    //       Map<String, dynamic> streetViewMap = userData['streetView'];

    //       return {
    //         'option': streetViewMap['option'] ?? 'None',
    //         'userIds': streetViewMap['userIds'] ?? [],
    //       };
    //     } else {
    //       return {
    //         'option': 'None',
    //         'userIds': [],
    //       };
    //     }
    //   }
    // } catch (error) {
    //   debugPrint('Error fetching data: $error');
    // }

    return {
      'option': 'None',
      'userIds': [],
    };
  }
}
