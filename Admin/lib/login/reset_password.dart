import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u_admin/constants/constants.dart';
import 'package:hookup4u_admin/login/sent_emailsuccess.dart';
import '../bloc/forgot_password/forgotpassword_bloc.dart';
import '../constants/snackbar.dart';
import '../constants/validators.dart';

class PasswordResetDialog extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  PasswordResetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotpasswordBloc passwordResetBloc =
        BlocProvider.of<ForgotpasswordBloc>(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Customize border radius
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth * 0.3, // Set width based on screen size
            // Set height based on screen size
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Reset Password", // Title here
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 11,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: _emailController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.black26,
                        ),
                        suffixIcon: Icon(
                          Icons.check_circle,
                          color: Colors.black26,
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.black26),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 16.0)),
                  ),
                ),
                const SizedBox(height: 16.0),
                BlocListener<ForgotpasswordBloc, ForgotpasswordState>(
                  listener: (context, state) async {
                    if (state is ForgotPasswordSuccess) {
                      await showDialog(
                        context: context,
                        builder: (context) => ResetPasswordSuccessDialog(
                          email: _emailController.text.trim(),
                        ),
                      );
                    } else if (state is ForgotPasswordError) {
                      snackbar(state.error, context);
                    }
                  },
                  child: BlocBuilder<ForgotpasswordBloc, ForgotpasswordState>(
                    builder: (context, state) {
                      if (state is ForgotPasswordLoding) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: primaryColor,
                        ));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                backgroundColor:
                                    MaterialStatePropertyAll(primaryColor)),
                            onPressed: () {
                              if (_emailController.text.isNotEmpty &&
                                  Validators.isValidEmail(
                                      _emailController.text)) {
                                passwordResetBloc.add(ResetPasswordRequested(
                                    _emailController.text.trim()));
                              } else {
                                snackbar("Enter valid email", context);
                              }
                            },
                            child: const Text("Send Reset Email"),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
