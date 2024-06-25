import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/forgot_password/forgotpassword_bloc.dart';
import 'constants/constants.dart';
import 'dashboard/dash_board_screen.dart';
import 'data/repo.dart';
import 'data/repo/auth_repositories.dart';
import 'login/login.dart';

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  // This widget is the root of your application.
  @override
  AdminAppState createState() => AdminAppState();
}

class AdminAppState extends State<AdminApp> {
  bool isAuthenticated = false;
  @override
  void initState() {
    Repo.setLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ForgotpasswordBloc(
              RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: primaryColor,
            appBarTheme: AppBarTheme(backgroundColor: primaryColor),
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                if (snapshot.hasData) {
                  // ignore: prefer_const_constructors
                  return DashBoardScreen();
                }
                // Otherwise, they're not signed in. Show the sign in page.
                return const LoginPage();
              }),
        ),
      ),
    );
  }
}
