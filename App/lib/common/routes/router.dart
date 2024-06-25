import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/providers/user_provider.dart';
import 'package:hookup4u2/common/routes/route_name.dart';
import 'package:hookup4u2/common/utils/large_image.dart';
import 'package:hookup4u2/features/auth/phone/ui/screens/phone_number.dart';
import 'package:hookup4u2/features/auth/phone/ui/screens/update_phonenumber.dart';
import 'package:hookup4u2/features/chat/chat.dart';

import 'package:hookup4u2/features/chat/ui/screens/chat_page.dart';
import 'package:hookup4u2/features/home/ui/screens/web_home_page.dart';

import 'package:hookup4u2/features/home/ui/tab/tabbar_screen.dart';
import 'package:hookup4u2/features/match/ui/screen/match_page.dart';
import 'package:hookup4u2/features/user/ui/screens/edit_user_profile.dart';
import 'package:hookup4u2/features/user/ui/screens/show_gender.dart';
import 'package:hookup4u2/features/user/ui/screens/user_profile.dart';
import 'package:hookup4u2/features/user/ui/screens/user_profile_pic_set.dart';
import 'package:hookup4u2/models/user_model.dart';
import 'package:provider/provider.dart';
import '../../features/home/ui/screens/user_filter/settings.dart';
import '../../features/home/ui/screens/welcome.dart';
import 'package:hookup4u2/features/user/ui/screens/user_dob.dart';
import 'package:hookup4u2/features/user/ui/screens/user_name.dart';
import '../../features/auth/phone/ui/screens/otp_page.dart';
import '../../features/home/ui/screens/splash_page.dart';

abstract class AppRouter {
  // register here for routes
  static Map<String, WidgetBuilder> allRoutes = {
    RouteName.splashScreen: (context) => const SplashPage(),
    RouteName.otpScreen: (context) => const OtpPage(),

    // Sign up screens
    RouteName.welcomeScreen: (context) => const Welcome(),
    RouteName.userNameScreen: (context) => const UserName(),
    RouteName.userDobScreen: (context) => const UserDOB(),
    RouteName.showGenderScreen: (context) => const ShowGender(),
    RouteName.profilePicSetScreen: (context) => const UserProfilePic(),

    RouteName.tabScreen: (context) => const TabBarScreen(),
    // RouteName.tabScreen: (context) => const Tabbar("active", false),

    RouteName.profileScreen: (context) => ProfilePage(
          isPurchased:
              (ModalRoute.of(context)!.settings.arguments as Map)['isPuchased'],
          items: (ModalRoute.of(context)!.settings.arguments as Map)['items'],
          purchases:
              (ModalRoute.of(context)!.settings.arguments as Map)['purchases'],
        ),
    RouteName.phoneNumberScreen: (context) => PhoneNumber(
          updatePhoneNumber: false,
        ),
    RouteName.editProfileScreen: (context) =>
        EditProfile(Provider.of<UserProvider>(context).currentUser!),
    RouteName.largeImageScreen: (context) => LargeImage(
        largeImage: ModalRoute.of(context)!.settings.arguments as String),
    RouteName.updatePhoneScreen: (context) =>
        UpdateNumber(ModalRoute.of(context)!.settings.arguments as UserModel),
    RouteName.settingPage: (context) => SettingPage(
          currentUser: (ModalRoute.of(context)!.settings.arguments
              as Map)['currentUser'] as UserModel,
          isPurchased: (ModalRoute.of(context)!.settings.arguments
              as Map)['isPurchased'],
          items: (ModalRoute.of(context)!.settings.arguments as Map)['items'],
        ),

    RouteName.matchPage: (context) => const MatchScreen(),

    RouteName.webHomeScreen: (_) => const WebHomePage(),
    RouteName.chatDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      return BlocProvider(
        create: (context) => ChatBloc(),
        child: ChatPage(conversation: args['conversation']),
      );
    }
  };
}
