// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hookup4u_admin/constants/constants.dart';
import 'package:hookup4u_admin/constants/validators.dart';
import 'package:hookup4u_admin/dashboard/dash_board_screen.dart';
import 'package:hookup4u_admin/login/reset_password.dart';
import 'package:provider/provider.dart';
import '../bloc/auth/auth_bloc.dart';
import '../constants/snackbar.dart';
import '../providers/selected_item_provider.dart';
import '../signup/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool showPass = false;
  bool isLargeScreen = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Navigating to the dashboard screen if the user is authenticated
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const DashBoardScreen()));
        }

        if (state is AuthError) {
          // Showing the error message if the user has entered invalid credentials
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Loading) {
            // Showing the loading indicator while the user is signing in
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          if (state is UnAuthenticated) {
            return OrientationBuilder(builder: (context, orientation) {
              if (MediaQuery.of(context).size.width > 600) {
                isLargeScreen = true;
              } else {
                isLargeScreen = false;
              }
              return Center(
                child: SizedBox(
                  width: isLargeScreen
                      ? MediaQuery.of(context).size.width * .5
                      : MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/hookup4u-Logo-BP.png",
                          height: 150,
                          width: 150,
                        ),
                        Text("Welcome Back!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0)),
                        Card(
                          margin: const EdgeInsets.only(
                              left: 30, right: 30, top: 30),
                          elevation: 11,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.only(
                              left: 30, right: 30, top: 20),
                          elevation: 11,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: _passwordController,
                            obscureText: !showPass,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.black26,
                                ),
                                hintText: "Password",
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                filled: true,
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
                                fillColor: Colors.white,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
                          child: isLoading
                              ? CupertinoActivityIndicator(
                                  radius: 16,
                                  color: primaryColor,
                                )
                              : SizedBox(
                                  height: 35,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        )),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                primaryColor)),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      _authenticateWithEmailAndPassword(
                                          context);
                                      Provider.of<SelectedMenuItemProvider>(
                                              context,
                                              listen: false)
                                          .setSelectedMenuItem('Dash');
                                    },
                                  ),
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(""),
                            TextButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => PasswordResetDialog(),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            _authenticateWithGoogle(context);
                          },
                          icon: Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                            height: 40,
                            width: 40,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUp()),
                                );
                              },
                              child: Text(
                                "Create Account",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          }
          return Container();
        },
      )),
    );
  }

  void _authenticateWithEmailAndPassword(context) async {
    if (_emailController.text.isNotEmpty &&
        Validators.isValidEmail(_emailController.text) &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text.length > 6) {
      // Check if the entered email exists in the Admin collection email array
      bool emailExistsInAdminArray =
          await doesEmailExistInAdminArray(_emailController.text);
      if (emailExistsInAdminArray) {
        BlocProvider.of<AuthBloc>(context).add(
          SignInRequested(_emailController.text, _passwordController.text),
        );
      } else {
        snackbar("User doesn't exist in Admin Database!", context);
      }
    } else {
      snackbar(
          "Invalid email or password (password length should be greater than 6 characters)",
          context);
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
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
}
