import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hookup4u2/common/utils/observer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

initApp() async {
  await dotenv.load(fileName: ".env");

  await EasyLocalization.ensureInitialized();
  if (!kIsWeb && Platform.isIOS) {
    //IOS check permission
    permission();
  }
  Bloc.observer = SimpleBlocObserver();

  debugPrint('Init_Supabase: ${dotenv.env['SUPABASE_URL']}');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
}

Future<void> permission() async {
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   debugPrint('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   debugPrint('User granted provisional permission');
  // } else {
  //   debugPrint('User declined or has not accepted permission');
  // }
}
