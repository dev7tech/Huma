// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hookup4u_admin/constants/snackbar.dart';
import '../dashboard/components/widgets/appbar_second.dart';
import '../constants/constants.dart';
import 'change_password_dialog.dart';
import '../constants/custom_dailog.dart';

class ChangeIdPassword extends StatefulWidget {
  const ChangeIdPassword({super.key});

  @override
  ChangeIdPasswordState createState() => ChangeIdPasswordState();
}

class ChangeIdPasswordState extends State<ChangeIdPassword> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPasswd = TextEditingController();
  bool isLoading = false;
  bool showPass = false;
  bool showPass1 = false;
  bool isLargeScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        if (MediaQuery.of(context).size.width > 600) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(appPadding),
          child: Column(
            children: [
              CustomAppbarSecond(
                text: "Change your password",
                searchcontroller: TextEditingController(text: ""),
                submittap: (p0) {},
                prefixtap: () {},
                sufixtap: () {},
                isIconShow: false,
              ),
              const SizedBox(
                height: appPadding,
              ),
              Center(
                child: SizedBox(
                  width: isLargeScreen
                      ? MediaQuery.of(context).size.width * .5
                      : MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/hookup4u-Logo-BP.png",
                        height: 150,
                        width: 150,
                      ),
                      Card(
                        margin:
                            const EdgeInsets.only(left: 30, right: 30, top: 30),
                        elevation: 11,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: TextField(
                          cursorColor: Theme.of(context).primaryColor,
                          controller: oldPassword,
                          obscureText: !showPass1,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock_open,
                              color: Colors.black26,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              color: showPass1
                                  ? Theme.of(context).primaryColor
                                  : Colors.black26,
                              onPressed: () {
                                setState(() {
                                  showPass1 = !showPass1;
                                });
                              },
                            ),
                            hintText: "Enter old password",
                            hintStyle: const TextStyle(color: Colors.black26),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin:
                            const EdgeInsets.only(left: 30, right: 30, top: 20),
                        elevation: 11,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: TextField(
                          cursorColor: Theme.of(context).primaryColor,
                          controller: newPasswd,
                          obscureText: !showPass,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black26,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              color: showPass
                                  ? Theme.of(context).primaryColor
                                  : Colors.black26,
                              onPressed: () {
                                setState(() {
                                  showPass = !showPass;
                                });
                              },
                            ),
                            hintText: "Enter new password",
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30.0),
                        child: SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                backgroundColor:
                                    MaterialStatePropertyAll(primaryColor)),
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (newPasswd.text.length >= 6) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlertDialog(
                                      text:
                                          "Do you want to change the password?",
                                      onYesTap: () async {
                                        Navigator.pop(
                                            context); // Close the dialog
                                        await _changePassword();
                                      },
                                      onNoTap: () => Navigator.pop(context),
                                    );
                                  },
                                );
                              } else if (oldPassword.text.isEmpty) {
                                snackbar(
                                    "Old password can not be empty", context);
                              } else {
                                snackbar(
                                    "Enter valid password like old password",
                                    context);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _changePassword() async {
    try {
      bool success = await changePassword(
        oldPassword.text.trim().toString(),
        newPasswd.text.trim().toString(),
      );
      debugPrint("value is $success");
      debugPrint("new password is ${newPasswd.text}");
      debugPrint("old password is ${oldPassword.text}");
      if (success == true) {
        showDialog(
            context: context,
            builder: (context) => const ChangePasswordSuccessDialog());
      } else {
        snackbar("Failed to change password. Please try again.", context);
      }
    } catch (error) {
      snackbar(error.toString(), context);
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    bool success = false;

    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if the user has a password provider (email and password)
        bool hasPasswordProvider =
            user.providerData.any((info) => info.providerId == 'password');

        if (!hasPasswordProvider) {
          // Display an error message if the user does not have a password provider
          snackbar(
              "Cannot change password for google login accounts.", context);
          return false;
        }

        AuthCredential cred = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassword);
        setState(() {
          success = true;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'wrong-password') {
        throw Exception('you provided wrong password.');
      }
    } catch (error) {
      debugPrint("Error updating password: $error");
    }

    return success;
  }
}
