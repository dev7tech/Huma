import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u_admin/constants/constants.dart';
import 'package:hookup4u_admin/constants/responsive.dart';
import 'package:hookup4u_admin/login/login.dart';

import '../bloc/auth/auth_bloc.dart';

class ChangePasswordSuccessDialog extends StatelessWidget {
  const ChangePasswordSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(20.0),
            width: !Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width * 0.3
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: primaryColor,
                  size: 48.0,
                ),
                const Text(
                  'Password Updated!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Your password has been changed successfully.\n Use your new password to log in.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child:
                      const Text('Okay', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
