import '../models/user_model.dart';

class FireStoreClass {
  static Future<dynamic> uploadFile(
      {required String checktype,
      required UserModel currentUser,
      required file}) async {
    // try {
    //   final int timestamp = DateTime.now().millisecondsSinceEpoch;
    //   Reference storageReference =
    //       FirebaseStorage.instance.ref().child('users/${currentUser.id}/$timestamp.jpg');
    //   UploadTask uploadTask = storageReference.putFile(file);
    //   await uploadTask.whenComplete(() {
    //     storageReference.getDownloadURL().then((fileURL) async {
    // Map<String, dynamic> updateObject = {
    //   "Pictures": FieldValue.arrayUnion([
    //     fileURL,
    //   ])
    // };
    // try {
    //   if (checktype == 'profile') {
    //     //currentUser.imageUrl.removeAt(0);
    //     currentUser.imageUrl!.insert(0, fileURL);
    //     debugPrint("object");
    //     await firebaseFireStoreInstance
    //         .collection("Users")
    //         .doc(currentUser.id)
    //         .set({"Pictures": currentUser.imageUrl},
    //             SetOptions(merge: true));
    //   } else {
    //     await firebaseFireStoreInstance
    //         .collection("Users")
    //         .doc(currentUser.id)
    //         .set(updateObject, SetOptions(merge: true));
    //     currentUser.imageUrl!.add(fileURL);
    //   }
    // } catch (err) {
    //   rethrow;
    // }
    //     });
    //   });
    //   return uploadTask;
    // } on FirebaseException {
    //   return null;
    // }
  }

  static Future<dynamic> uploadprofile(
      {required String currentUserId, required file}) async {
    //   try {
    //     final int timestamp = DateTime.now().millisecondsSinceEpoch;
    //     Reference storageReference =
    //         FirebaseStorage.instance.ref().child('users/$currentUserId/$timestamp.jpg');
    //     UploadTask uploadTask = storageReference.putFile(file);
    //     await uploadTask.whenComplete(() {
    //       storageReference.getDownloadURL().then((fileURL) async {
    //         // Map<String, dynamic> updateObject = {
    //         //   "Pictures": FieldValue.arrayUnion([
    //         //     fileURL,
    //         //   ])
    //         // };
    //         // try {
    //         //   debugPrint("object");
    //         //   await firebaseFireStoreInstance
    //         //       .collection("Users")
    //         //       .doc(currentUserId)
    //         //       .set(
    //         //         updateObject,
    //         //         SetOptions(merge: true),
    //         //       );
    //         // } catch (err) {
    //         //   rethrow;
    //         // }
    //       });
    //     });
    //     return uploadTask;
    //   } on FirebaseException {
    //     return null;
    //   }
  }
}
