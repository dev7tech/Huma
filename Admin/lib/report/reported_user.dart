import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../constants/constants.dart';

class ReportedUser {
  final CollectionReference reportsList =
      firebaseInstance.collection('Reports');
  Future getReportedUser() async {
    List itemList = [];
    try {
      await reportsList.get().then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          itemList.add(element.data());
        }
      });
      return itemList;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}
