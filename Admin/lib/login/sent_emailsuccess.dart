import 'package:flutter/material.dart';
import 'package:hookup4u_admin/constants/constants.dart';

class ResetPasswordSuccessDialog extends StatelessWidget {
  final String email;
  const ResetPasswordSuccessDialog({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: primaryColor,
                size: 48.0,
              ),
              const SizedBox(height: 10.0),
              Text(
                'Email sent successfully for password reset \n on $email',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
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
    );
  }
}
