// ignore_for_file: deprecated_member_use, depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookup4u2/common/app/app.dart';
import 'package:hookup4u2/common/app/init.dart';
import 'package:hookup4u2/common/providers/user_provider.dart';
import 'package:hookup4u2/features/auth/auth.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  final sharedPref = await SharedPreferences.getInstance();
  final authRepo = AuthRepo(supabaseClient: Supabase.instance.client);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then(
    (_) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();

      runApp(
        EasyLocalization(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('es', 'ES'),
            Locale('fr', 'FR'),
            Locale('de', 'DE'),
            Locale('ru', 'RU'),
            Locale('hi', 'IN')
          ],
          saveLocale: true,
          path: 'asset/translation',
          child: ChangeNotifierProvider(
            create: (_) {
              return UserProvider();
            },
            child: App(
              authRepo: authRepo,
              sharedPreferences: sharedPref,
            ),
          ),
        ),
      );
    },
  );
}
