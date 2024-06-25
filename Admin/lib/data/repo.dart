import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constants.dart';

class Repo {
  //Create language for admin
  static Future setLanguage() async {
    await firebaseInstance
        .collection("Admin")
        .doc("id_password")
        .set({}, SetOptions(merge: true));
    await firebaseInstance
        .collection("Language")
        .doc("present_languages")
        .get()
        .then((value) async {
      if (value.data() == null) {
        await firebaseInstance
            .collection("Language")
            .doc("present_languages")
            .set({
          "english": true,
          'spanish': true,
          'hindi': false,
          'german': false,
          'french': false,
          'russian': false
        });
      }
    });
  }

  static bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static String classifyString(String input) {
    bool hasAlphabet = false;
    bool hasNumeric = false;

    for (var char in input.runes) {
      if (isAlphabetCharacter(char)) {
        hasAlphabet = true;
      } else if (isNumericCharacter(char)) {
        hasNumeric = true;
      }
    }

    if (hasAlphabet && hasNumeric) {
      return 'userId';
    } else if (hasNumeric) {
      return 'phone';
    } else {
      return 'name';
    }
  }

  static bool isAlphabetCharacter(int charCode) {
    return (charCode >= 65 && charCode <= 90) ||
        (charCode >= 97 && charCode <= 122);
  }

  static bool isNumericCharacter(int charCode) {
    return charCode >= 48 && charCode <= 57;
  }
}
