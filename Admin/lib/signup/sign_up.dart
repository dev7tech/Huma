// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u_admin/constants/validators.dart';
import 'package:hookup4u_admin/dashboard/dash_board_screen.dart';
import 'package:hookup4u_admin/login/login.dart';

import '../bloc/auth/auth_bloc.dart';
import '../constants/constants.dart';
import '../constants/snackbar.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adminNameController = TextEditingController();
  bool isLargeScreen = false;
  bool showPass = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const DashBoardScreen(),
              ),
            );
          }
          if (state is AuthError) {
            // Displaying the error message if the user is not authenticated
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            // Displaying the loading indicator while the user is signing up
            return Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          }
          if (state is UnAuthenticated) {
            // Displaying the sign up form if the user is not authenticated
            return OrientationBuilder(
              builder: (context, orientation) {
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/hookup4u-Logo-BP.png",
                              height: 130,
                              width: 150,
                            ),
                            Text("Sign Up",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.0)),
                            Center(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Card(
                                      margin: const EdgeInsets.only(
                                          left: 30, right: 30, top: 30),
                                      elevation: 11,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40))),
                                      child: TextFormField(
                                        cursorColor:
                                            Theme.of(context).primaryColor,
                                        controller: _adminNameController,
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.black26,
                                            ),
                                            suffixIcon: Icon(
                                              Icons.check_circle,
                                              color: Colors.black26,
                                            ),
                                            hintText: "Name",
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0)),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 16.0)),
                                      ),
                                    ),
                                    Card(
                                      margin: const EdgeInsets.only(
                                          left: 30, right: 30, top: 30),
                                      elevation: 11,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40))),
                                      child: TextFormField(
                                        cursorColor:
                                            Theme.of(context).primaryColor,
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
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0)),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 16.0)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      margin: const EdgeInsets.only(
                                          left: 30, right: 30, top: 20),
                                      elevation: 11,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40))),
                                      child: TextFormField(
                                        cursorColor:
                                            Theme.of(context).primaryColor,
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
                                              icon: const Icon(
                                                  Icons.remove_red_eye),
                                              color: showPass
                                                  ? Theme.of(context)
                                                      .primaryColor
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0)),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 16.0)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20.0),
                                      child: SizedBox(
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
                                          onPressed: () {
                                            if (_emailController
                                                    .text.isNotEmpty &&
                                                _adminNameController
                                                    .text.isNotEmpty &&
                                                Validators.isValidEmail(
                                                    _emailController.text) &&
                                                _passwordController
                                                    .text.isNotEmpty &&
                                                _passwordController
                                                        .text.length >
                                                    6) {
                                              _createAccountWithEmailAndPassword(
                                                  context);
                                            } else {
                                              snackbar("Enter valid details",
                                                  context);
                                            }
                                          },
                                          child: const Text(
                                            'Sign Up',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Text("Or login with"),
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
                                const Text("Already have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  void _createAccountWithEmailAndPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;

      // Check if the Admin collection has any email
      bool adminCollectionHasEmail = await doesAdminCollectionHaveEmail();

      if (!adminCollectionHasEmail) {
        // Allow signup as Admin collection doesn't have any email
        BlocProvider.of<AuthBloc>(context).add(
          SignUpRequested(
            email,
            _passwordController.text,
            _adminNameController.text,
          ),
        );
      } else {
        // Check if the entered email exists in the Admin collection email array
        bool emailExistsInAdminArray = await doesEmailExistInAdminArray(email);

        if (emailExistsInAdminArray) {
          // Allow signup since the entered email exists in the Admin collection email array
          BlocProvider.of<AuthBloc>(context).add(
            SignUpRequested(
                email, _passwordController.text, _adminNameController.text),
          );
        } else {
          // Show the access dialog since the entered email doesn't exist in the Admin collection email array

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Access Denied'),
                content: const Text('You don\'t have access to the panel.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  Future<bool> doesAdminCollectionHaveEmail() async {
    final DocumentSnapshot documentSnapshot =
        await firebaseInstance.collection('Admin').doc('id_password').get();
    Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>;
    if (data.containsKey('email')) {
      List<dynamic> emailArray = data['email'];
      return emailArray.isNotEmpty;
    }
    return false;
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

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }
}
