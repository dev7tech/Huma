import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u_admin/providers/active_users_provider.dart';
import 'package:hookup4u_admin/providers/gender_data_provider.dart';
import 'package:hookup4u_admin/providers/likers_data_provider.dart';
import 'package:hookup4u_admin/providers/recent_activity_provider.dart';
import 'package:hookup4u_admin/providers/selected_item_provider.dart';
import 'package:hookup4u_admin/providers/users_provider.dart';
import 'package:provider/provider.dart';
import 'admin_app.dart';
import 'controllers/controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "0000000000000000000000",
      appId: "00000000000000000000000000",
      messagingSenderId: "00000000000000",
      projectId: '00000000000',
    ),
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => DrawersController()),
    ChangeNotifierProvider(create: (context) => GenderDataProvider()),
    ChangeNotifierProvider(create: (context) => LikedDocProvider()),
    ChangeNotifierProvider(create: (context) => UserDataProvider()),
    ChangeNotifierProvider(create: (context) => SelectedMenuItemProvider()),
    ChangeNotifierProvider(create: (context) => RecentActivityProvider()),
    ChangeNotifierProvider(create: (context) => ActiveUserProvider())
  ], child: const AdminApp()));
}
