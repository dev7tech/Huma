import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../constants/constants.dart';
import '../constants/snackbar.dart';
import '../model/recent_activity_model.dart';
import '../model/user_model.dart';

class RecentActivityProvider with ChangeNotifier {
  final List<RecentActivityModel> _reportedUsers = [];
  List<RecentActivityModel> _blockedUsers = [];
  final Map<String, List<RecentActivityModel>> _reportedByMap = {};

  Map<String, List<RecentActivityModel>> get reportedByMap => _reportedByMap;
  List<RecentActivityModel> get reportedUsers => _reportedUsers;
  List<RecentActivityModel> get blockedUsers => _blockedUsers;

  Future<void> fetchReportedUsers() async {
    QuerySnapshot querySnapshot = await firebaseInstance
        .collection('Reports')
        .orderBy('timestamp', descending: true)
        .get();

    // Clear the existing list before adding new items
    _reportedUsers.clear();

    // Retrieve the users' information using victim_id from the documents
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      String victimId = data['victim_id'];
      Timestamp timestamp = data['timestamp'];

      DocumentSnapshot userSnapshot =
          await firebaseInstance.collection('Users').doc(victimId).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        _reportedUsers.add(
          RecentActivityModel(
            activity: "report",
            userId: victimId,
            userIndex: User.fromDocument(userSnapshot),
            userName: userData['UserName'],
            imageUrl: userData['Pictures'][0],
            timestamp:
                DateFormat('dd-MM-yyyy-hh:mm a').format(timestamp.toDate()),
          ),
        );
      } else {
        debugPrint("not exist");
      }
    }

    notifyListeners();
  }

  Future<void> fetchReportedByUsers() async {
    QuerySnapshot querySnapshot = await firebaseInstance
        .collection('Reports')
        .orderBy('timestamp', descending: true)
        .get();

    _reportedByMap.clear();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String victimId = data['victim_id'];
      Timestamp timestamp = data['timestamp'];
      String reportedId = data['reported_by'];

      DocumentSnapshot userSnapshot =
          await firebaseInstance.collection('Users').doc(reportedId).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        RecentActivityModel reporter = RecentActivityModel(
          activity: "report",
          userId: reportedId,
          userIndex: User.fromDocument(userSnapshot),
          userName: userData['UserName'],
          imageUrl: userData['Pictures'][0],
          timestamp:
              DateFormat('dd-MM-yyyy-hh:mm a').format(timestamp.toDate()),
        );

        if (_reportedByMap.containsKey(victimId)) {
          _reportedByMap[victimId]!.add(reporter);
        } else {
          _reportedByMap[victimId] = [reporter];
        }
      } else {
        debugPrint("Reporter with ID $reportedId does not exist");
      }
    }

    notifyListeners();
  }

  Future<void> fetchBlockedUsers() async {
    QuerySnapshot querySnapshot = await firebaseInstance
        .collection('Users')
        .where('isBlocked', isEqualTo: true)
        .orderBy('BlockedAt', descending: true)
        .get();

    _blockedUsers = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // debugPrint("blocked data is $data");
      return RecentActivityModel(
          userId: data['userId'],
          userIndex: User.fromDocument(doc),
          imageUrl: data['Pictures'][0],
          userName: data['UserName'],
          timestamp: DateFormat('dd-MM-yyyy-hh:mm a')
              .format(data['BlockedAt'].toDate()),
          activity: "block");
    }).toList();

    notifyListeners();
  }

  // Function to unblock a user by their userId
  Future<void> unblockUser(String userId, BuildContext context) async {
    try {
      await firebaseInstance.collection("Users").doc(userId).update({
        "isBlocked": false,
      }).whenComplete(() => snackbar("Unblocked", context));

      // Remove the unblocked user from the blockedUsers list
      _blockedUsers.removeWhere((user) => user.userId == userId);

      // Fetch the updated list of blocked users again
      await fetchBlockedUsers();

      // Notify listeners that the data has changed
      notifyListeners();
    } catch (error) {
      // Handle any errors that occur during the unblocking process
      debugPrint("Error unblocking user: $error");
    }
  }
}
