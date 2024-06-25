import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../constants/constants.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Add user data to Firestore collection
        addDataToAdminCollection([email], name, userCredential.user!.uid, "");

        try {
          return await userCredential.user!.getIdToken();
        } catch (e) {
          throw Exception('Error fetching token: $e');
        }
      } else {
        throw Exception('User is null after sign-up');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else {
        throw Exception('An unknown error occurred: ${e.code}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> addDataToAdminCollection(
      List<String> emails, String name, String userId, String? imageUrl) async {
    CollectionReference adminCollection = firebaseInstance.collection('Admin');

    // Get the document reference for the current user using the userId
    DocumentReference docRef = adminCollection.doc('id_password');

    // Check if the Admin collection already has data
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data != null && data.containsKey('email')) {
      debugPrint(
          'Admin collection already has data. No new data will be added.');
      return;
    }

    // Create a data map with the required fields
    Map<String, dynamic> newData = {
      'createdAt': FieldValue.serverTimestamp(),
      'role': 'admin',
      'email': emails,
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl
    };

    // Set the data in the document
    await docRef.set(newData);
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        try {
          return await userCredential.user!.getIdToken();
        } catch (e) {
          throw Exception('Error fetching token: $e');
        }
      } else {
        throw Exception('User is null after sign-in');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception('An unknown error occurred: ${e.code}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Check if the entered email exists in the Admin collection email array
      bool emailExistsInAdminArray =
          await doesEmailExistInAdminArray(googleUser!.email);
      if (emailExistsInAdminArray) {
        await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        throw Exception("you don't have access,please contact admin");
      }

      // Add user data to Firestore collection
      addDataToAdminCollection([googleUser.email], googleUser.displayName!,
          googleUser.id, googleUser.photoUrl!);
    } catch (e) {
      debugPrint("ERROR ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<bool> doesEmailExistInAdminArray(String email) async {
    final DocumentSnapshot documentSnapshot =
        await firebaseInstance.collection('Admin').doc('id_password').get();
    Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>;
    if (data.containsKey('email')) {
      List<dynamic> emailArray = data['email'];
      return emailArray.contains(email);
    }
    return false;
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
