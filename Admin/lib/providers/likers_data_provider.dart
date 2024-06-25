import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u_admin/constants/constants.dart';

import '../model/likers_info_model.dart';
import '../model/user_model.dart';

class LikedDocProvider extends ChangeNotifier {
  LikedDocProvider() {
    fetchLikedDocsFromFirebase();
  }

  List<LikersInfoModel> likedDocs = [];
  final db = firebaseInstance.collection('Users');
  List<LikersInfoModel> get likedDocsList => likedDocs;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void fetchLikedDocsFromFirebase() async {
    try {
      final QuerySnapshot usersSnapshot = await db.get();

      List<LikersInfoModel> tempLikedDocs = [];

      await Future.forEach(usersSnapshot.docs, (doc) async {
        final QuerySnapshot likedBySnapshot =
            await db.doc(doc.id).collection("LikedBy").get();

        tempLikedDocs.add(LikersInfoModel(
          title: doc.get('UserName'),
          svgSrc: doc.get('Pictures')[0],
          userIndex: User.fromDocument(doc),
          count: likedBySnapshot.size,
          color: secondryColor,
        ));
      });
      tempLikedDocs.sort((a, b) => b.count!.compareTo(a.count!));

      likedDocs = tempLikedDocs;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Error fetching liked docs: $e');
    }
  }
}
