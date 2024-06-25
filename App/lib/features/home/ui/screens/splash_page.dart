import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants/colors.dart';
import '../../../../common/providers/theme_provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const SplashPage(),
      );

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: SizedBox(
            height: 120,
            width: 200,
            child: Image.asset(
              "asset/hookup4u-Logo-BP.png",
              fit: BoxFit.contain,
              color: themeProvider.isDarkMode ? Colors.white : primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
