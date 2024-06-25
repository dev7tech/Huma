import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u2/common/constants/colors.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Logout'.tr().toString()),
        content: Text('Do you want to logout your account?'.tr().toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'.tr().toString(),
                style: TextStyle(color: primaryColor)),
          ),
          TextButton(
            onPressed: () async {
              // TODO: handle sign out
              // await auth.signOut().whenComplete(() async {
              //   UserProvider userProvider =
              //       Provider.of<UserProvider>(context, listen: false);
              //   userProvider.listenAuthChanges();
              //   userProvider.cancelCurrentUserSubscription();

              //   debugPrint('---------------------delete--------------');
              //   try {
              //     firebaseMessaging.deleteToken().then((value) {
              //       debugPrint(
              //           '---------------------deleted FIREBASE TOKEN--------------');
              //     });
              //   } catch (e) {
              //     rethrow;
              //   }

              //   // Navigate to the login screen and set currentUser to null after navigation
              //   await Navigator.pushReplacementNamed(
              //       context, RouteName.loginScreen);

              //   // After navigation is complete, set currentUser to null
              //   userProvider.currentUser = null;
              // });
            },
            child: Text(
              'Yes'.tr().toString(),
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      );
    },
  );
}
