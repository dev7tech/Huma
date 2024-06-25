import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../constants/enums.dart';

class ActiveUserProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _userDataList = [];
  final Map<String, int> _dateCountMap = {};

  List<Map<String, dynamic>> get userDataList => _userDataList;
  Map<String, int> get dateCountMap => _dateCountMap;

// for  fetching data to show user who fall in our date condition
  Future<List<Map<String, dynamic>>> fetchUserDataFromFirebase() async {
    List<Map<String, dynamic>> userDataList = [];

    try {
      // Reference to the "users" collection in Firestore
      CollectionReference usersRef = firebaseInstance.collection('Users');

      // Get all documents from the "users" collection
      QuerySnapshot querySnapshot = await usersRef.get();

      // Process each document and add user data to the list if it contains 'lastVisitedDate' key
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> userData =
            doc.data() as Map<String, dynamic>; // Cast here

        // Check if the 'lastVisitedDate' key exists in the document before adding it to the list
        if (userData.containsKey('lastvisited')) {
          userDataList.add(userData);
        }
        _userDataList = userDataList;
        notifyListeners();
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      debugPrint('Error fetching user data: $e');
    }

    return userDataList;
  }

  // convert timestamp to date year fromat

  String formatDateFromTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // for counting by date users

  Map<String, int> countUsersByDate(
    List<Map<String, dynamic>> userData,
    DateTime? startDate,
    DateTime? endDate,
    FilterType filterType,
  ) {
    Map<String, int> dateCountMap = {};
    DateTime today = DateTime.now();

    for (var data in userData) {
      Timestamp lastVisitedTimestamp = data['lastvisited'];

      // ignore: unnecessary_null_comparison
      if (lastVisitedTimestamp != null) {
        DateTime lastVisitedDate = lastVisitedTimestamp.toDate();

        if (filterType == FilterType.weekly) {
          Duration difference = today.difference(lastVisitedDate);
          if (difference.inDays <= 7) {
            String formattedDate =
                formatDateFromTimestamp(lastVisitedTimestamp);
            dateCountMap[formattedDate] =
                (dateCountMap[formattedDate] ?? 0) + 1;
          }
        } else if (filterType == FilterType.monthly) {
          String formattedDate = DateFormat('yyyy-MM').format(lastVisitedDate);
          dateCountMap[formattedDate] = (dateCountMap[formattedDate] ?? 0) + 1;
        } else if (filterType == FilterType.range) {
          // Check if the lastVisitedDate falls within the specified date range
          if (startDate != null &&
              endDate != null &&
              lastVisitedDate.isAfter(startDate) &&
              (lastVisitedDate.isBefore(endDate))) {
            // Format the date as a string
            String formattedDate =
                formatDateFromTimestamp(lastVisitedTimestamp);

            // Increment the user count for the specific date
            dateCountMap.update(formattedDate, (count) => count + 1,
                ifAbsent: () => 1);
          }
        } else if (filterType == FilterType.yearly) {
          if (today.year - lastVisitedDate.year <= 3) {
            String formattedDate = DateFormat('yyyy').format(lastVisitedDate);
            dateCountMap[formattedDate] =
                (dateCountMap[formattedDate] ?? 0) + 1;
          }
        }
      } else {
        debugPrint(
            'Skipping document with null lastVisitedDate: ${data.toString()}');
      }
    }

    // debugPrint('map: $dateCountMap');

    return dateCountMap;
  }
}
