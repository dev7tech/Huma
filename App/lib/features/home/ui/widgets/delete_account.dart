import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../common/constants/colors.dart';
import '../../../../common/widets/text_button.dart';

class DeleteAccountWidget extends StatefulWidget {
  const DeleteAccountWidget({super.key});

  @override
  State<DeleteAccountWidget> createState() => _DeleteAccountWidgetState();
}

class _DeleteAccountWidgetState extends State<DeleteAccountWidget> {
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return TextButtonWidget(
      text: "Delete Account",
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Account'.tr().toString()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Do you want to delete your account?'.tr().toString()),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                      "We're sorry to see you go, but we understand your decision. Deleting your account will permanently remove all your personal information and data associated with it."
                          .tr()
                          .toString()),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'.tr().toString(),
                      style: TextStyle(color: primaryColor)),
                ),
                TextButton(
                  onPressed: () async {
                    // TODO: handle delete
                    final dynamic user;
                    // user.delete().then((_) {
                    //   debugPrint(" deleting user ${user.toString()}");
                    //   UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

                    //   Navigator.pushReplacementNamed(context, RouteName.loginScreen).then((_) {
                    //     userProvider.currentUser = null;
                    //   });

                    //   // Delete user data from Firestore collections
                    //   return PhoneAuthRepository().deleteUser(user);
                    // }).then((_) {
                    //   CustomSnackbar.showSnackBarSimple(
                    //       "Account deleted Successfully".tr().toString(), context);
                    // }).catchError((e) {
                    //   debugPrint("error in deleting user ${e.toString()}");

                    //   // for handling the recent login error
                    //   if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
                    //     showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return Dialog(
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(20.0),
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(20.0),
                    //             child: Column(
                    //               mainAxisSize: MainAxisSize.min,
                    //               crossAxisAlignment: CrossAxisAlignment.stretch,
                    //               children: [
                    //                 Text(
                    //                   'Recent Login Required'.tr().toString(),
                    //                   style: TextStyle(fontSize: 18, color: primaryColor),
                    //                 ),
                    //                 const SizedBox(height: 10),
                    //                 Text(
                    //                   'To ensure the security of your account, we require you to log in again for verification purposes. Please log in again and then delete account.'
                    //                       .tr()
                    //                       .toString(),
                    //                   style: const TextStyle(fontSize: 16),
                    //                 ),
                    //                 const SizedBox(height: 20),
                    //                 Row(
                    //                   mainAxisAlignment: MainAxisAlignment.end,
                    //                   children: [
                    //                     TextButton(
                    //                       onPressed: () {
                    //                         Navigator.of(context).pop();
                    //                       },
                    //                       child: Text(
                    //                         'Close'.tr().toString(),
                    //                         style: TextStyle(color: primaryColor),
                    //                       ),
                    //                     ),
                    //                     TextButton(
                    //                       onPressed: () async {
                    //                         await _auth.signOut().whenComplete(() {
                    //                           UserProvider userProvider =
                    //                               Provider.of<UserProvider>(context, listen: false);
                    //                           userProvider.cancelCurrentUserSubscription();

                    //                           debugPrint(
                    //                               '---------------------delete--------------');
                    //                           try {
                    //                             firebaseMessaging.deleteToken().then((value) {
                    //                               debugPrint(
                    //                                   '---------------------deleted FIREBASE TOKEN--------------');
                    //                             });
                    //                           } catch (e) {
                    //                             rethrow;
                    //                           }

                    //                           Navigator.pushReplacementNamed(
                    //                                   context, RouteName.loginScreen)
                    //                               .whenComplete(() {
                    //                             userProvider.currentUser = null;
                    //                           });
                    //                         });
                    //                       },
                    //                       child: Text(
                    //                         'Yes'.tr().toString(),
                    //                         style: TextStyle(color: primaryColor),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   }
                    // });
                  },
                  child: Text('Yes'.tr().toString(),
                      style: TextStyle(color: primaryColor)),
                ),
              ],
            );
          },
        );
      },
      icon: Icons.delete_forever_outlined,
    );
  }
}
