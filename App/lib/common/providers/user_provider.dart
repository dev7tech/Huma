import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/user_model.dart';

// TODO: Remove

class UserProvider extends ChangeNotifier {
  UserProvider() {
    listenCurrentUserdetails();
    listenAuthChanges();
  }
  // final CollectionReference _userCollection = firebaseFireStoreInstance.collection("Users");

  UserModel? _currentUser;
  // StreamSubscription<QuerySnapshot>? _userSubscription;

  UserModel? get currentUser => _currentUser;
  set currentUser(UserModel? val) {
    _currentUser = val;
    notifyListeners();
  }

  // for listining all details of user

  Future<void> listenCurrentUserdetails() async {
    const user = null;
    if (user != null) {
      // _userSubscription =
      //     _userCollection.where("userId", isEqualTo: 'user.uid').snapshots().listen((event) {
      //   if (event.docs.isNotEmpty) {
      //     // debugPrint("listen user1 ${event.docs.first.data().toString()}");
      //     final userData = UserModel.fromDocument(event.docs.first);
      //     currentUser = userData;
      //     notifyListeners();
      //   }
      // });
    } else {
      throw Exception('No user found');
    }
  }

  // Listen for authentication state changes
  void listenAuthChanges() {
    // authStateSubscription = _auth.authStateChanges().listen((User? user) {
    //   if (user != null) {
    //     listenCurrentUserdetails();
    //   } else {
    //     // User is logged out
    //     // Handle this case as needed
    //   }
    // });
  }

// you can cancel listen to user if requieed
  void cancelCurrentUserSubscription() {
    // _userSubscription?.cancel();
    // authStateSubscription!.cancel();
  }
}
