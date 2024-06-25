import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../model/gender_data_model.dart';

class GenderDataProvider with ChangeNotifier {
  GenderDataModel analyticData = GenderDataModel(
    menCount: 0,
    womenCount: 0,
    otherCount: 0,
  );

  GenderDataProvider() {
    // Call the updateDataFromFirebase() function when the UserDataProvider is created
    updateDataFromFirebase();
  }

  GenderDataModel get genderData => analyticData;

  Future<void> updateDataFromFirebase() async {
    try {
      FirebaseFirestore firestore = firebaseInstance;
      QuerySnapshot snapshot = await firestore.collection('Users').get();

      int menCount = snapshot.docs
          .where((doc) => doc['editInfo']['userGender'] == 'men')
          .length;
      int womenCount = snapshot.docs
          .where((doc) => doc['editInfo']['userGender'] == 'women')
          .length;
      int otherCount = snapshot.docs
          .where((doc) => doc['editInfo']['userGender'] == 'other')
          .length;

      // Update gender data model
      analyticData = GenderDataModel(
        menCount: menCount,
        womenCount: womenCount,
        otherCount: otherCount,
      );

      // Notify listeners that the data has changed
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating analytic data: $e');
    }
  }

  // Function to calculate gender percentages (can be used with the model)
  double get menPercentage {
    int totalUsersCount = analyticData.menCount +
        analyticData.womenCount +
        analyticData.otherCount;
    return totalUsersCount == 0 ? 0.0 : analyticData.menCount / totalUsersCount;
  }

  double get womenPercentage {
    int totalUsersCount = analyticData.menCount +
        analyticData.womenCount +
        analyticData.otherCount;
    return totalUsersCount == 0
        ? 0.0
        : analyticData.womenCount / totalUsersCount;
  }

  double get otherPercentage {
    int totalUsersCount = analyticData.menCount +
        analyticData.womenCount +
        analyticData.otherCount;
    return totalUsersCount == 0
        ? 0.0
        : analyticData.otherCount / totalUsersCount;
  }
}
