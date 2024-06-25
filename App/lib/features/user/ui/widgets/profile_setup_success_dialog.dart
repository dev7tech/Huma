import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u2/common/constants/colors.dart';
import 'package:hookup4u2/common/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileSetupSuccessDialog extends StatelessWidget {
  const ProfileSetupSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Center(
      // Aligns the container to center
      child: Container(
        // A simplified version of dialog.
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 120.0,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "asset/auth/verified.jpg",
              height: 60,
              color: primaryColor,
              colorBlendMode: BlendMode.color,
            ),
            Text(
              "Account Setup".tr().toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: themeProvider.isDarkMode ? Colors.black : Colors.black,
                  fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
