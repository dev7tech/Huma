// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/analytic_info_model.dart';
import '../constants/constants.dart';

class UserDataProvider extends ChangeNotifier {
  UserDataProvider() {
    // Call thisfunction when the UserDataProvider is created
    listenToRealTimeUpdates();
  }

  List<AnalyticInfo> analyticData = [
    AnalyticInfo(
      title: "Total Users",
      count: 0, // Initialize to 0, as we'll update this later from Firebase.
      svgSrc: "assets/icons/Subscribers.svg",
      color: Colors.green,
    ),
    AnalyticInfo(
      title: "Premium Users",
      count: 0,
      svgSrc: "assets/icons/pre-user.svg",
      color: Colors.blue, // Replace with your primaryColor
    ),
    AnalyticInfo(
      title: "Blocked Users",
      count: 0,
      svgSrc: "assets/icons/block.svg",
      color: Colors.red,
    ),
    AnalyticInfo(
      title: "Reported Users",
      count: 0,
      svgSrc: "assets/icons/warning.svg",
      color: Colors.orange,
    ),
  ];

  void listenToRealTimeUpdates() async {
    try {
      FirebaseFirestore firestore = firebaseInstance;

      firestore.collection('Users').snapshots().listen((snapshot) async {
        int premiumcount = 0;
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data();

          if (data.containsKey('isPremium') && data['isPremium'] == true) {
            premiumcount++;
          }
        }

        QuerySnapshot reportSnapshot =
            await firestore.collection('Reports').get();

        analyticData[0].count = snapshot.size; // Total Users count
        analyticData[1].count = premiumcount; // Premium Users count
        analyticData[2].count = snapshot.docs
            .where((doc) => doc['isBlocked'] == true)
            .length; // Blocked Users count
        analyticData[3].count = reportSnapshot.size; // Reported Users count

        notifyListeners(); // Notify listeners that the data has changed
      });
    } catch (e) {
      debugPrint('Error listening to real-time updates: $e');
    }
  }
}
