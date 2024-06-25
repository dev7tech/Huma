import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/data/repo/user_search_repo.dart';
import 'package:hookup4u2/common/routes/route_name.dart';
import 'package:hookup4u2/common/routes/router.dart';
import 'package:hookup4u2/features/auth/auth.dart';
import 'package:hookup4u2/features/auth/bloc/auth_bloc.dart';
import 'package:hookup4u2/features/auth/phone/bloc/phone_auth_bloc.dart';
import 'package:hookup4u2/features/chat/bloc/items_bloc.dart';
import 'package:hookup4u2/features/chat/bloc/purchase_item_bloc.dart';
import 'package:hookup4u2/features/chat/chat.dart';
import 'package:hookup4u2/features/chat/data/chat_message_repo.dart';
import 'package:hookup4u2/features/explore/bloc/explore_map_bloc.dart';
import 'package:hookup4u2/features/home/bloc/ai_anon_convo_bloc.dart';
import 'package:hookup4u2/features/home/bloc/ai_profiles_bloc.dart';
import 'package:hookup4u2/features/home/bloc/anon_profile_bloc.dart';
import 'package:hookup4u2/features/home/domain/repo/anon_convo_repo.dart';
import 'package:hookup4u2/features/home/ui/screens/splash_page.dart';
import 'package:hookup4u2/features/payment/ui/in-app%20purcahse/get%20Products/getproducts_bloc.dart';
import 'package:hookup4u2/features/street_view/bloc/streetviewdata_bloc.dart';
import 'package:hookup4u2/features/user/profile/bloc/profile_bloc.dart';
import 'package:hookup4u2/features/user/profile/cubit/profile_cubit.dart';
import 'package:hookup4u2/features/user/profile/cubit/profile_visit_cubit.dart';
import 'package:hookup4u2/services/location/bloc/userlocation_bloc.dart';
import 'package:hookup4u2/common/constants/theme.dart';
import 'package:hookup4u2/common/data/repo/user_location_repo.dart';

import 'package:hookup4u2/common/providers/theme_provider.dart';
import 'package:hookup4u2/features/auth/auth_status/bloc/registration/bloc/registration_bloc.dart';

import 'package:hookup4u2/features/blockUser/bloc/bloc_user_list_bloc.dart';
import 'package:hookup4u2/features/home/bloc/search_user_bloc.dart';
import 'package:hookup4u2/features/home/bloc/swipe_bloc.dart';

import 'package:hookup4u2/features/home/ui/screens/user_filter/bloc/userfilter_bloc.dart';
import 'package:hookup4u2/features/match/bloc/match_bloc.dart';
import 'package:hookup4u2/features/payment/ui/in-app purcahse/buy Products/buyproducts_bloc.dart';
import 'package:hookup4u2/features/report/bloc/report_bloc.dart';
import 'package:hookup4u2/features/user/bloc/update_user_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

class App extends StatefulWidget {
  final AuthRepo authRepo;
  final SharedPreferences sharedPreferences;

  const App({super.key, required this.authRepo, required this.sharedPreferences});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final anonConvoRepo = AnonConvoRepo();
    final chatMessageRepo = ChatMessageRepo();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: widget.authRepo),
        RepositoryProvider.value(
            value: SupabaseUserSearchRepo(supabaseClient: Supabase.instance.client)),
        RepositoryProvider.value(value: anonConvoRepo),
        RepositoryProvider.value(value: widget.sharedPreferences),
        RepositoryProvider.value(value: chatMessageRepo),
        RepositoryProvider.value(value: widget.sharedPreferences),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepo: widget.authRepo)),
          BlocProvider(create: (_) => PhoneAuthBloc(authRepo: widget.authRepo)),
          BlocProvider(create: (_) => ProfileCubit()),
          BlocProvider(
            create: (context) => ProfileVisitCubit(
              userSearchRepo: RepositoryProvider.of<SupabaseUserSearchRepo>(context),
            ),
          ),

          BlocProvider(create: (_) => ProfileBloc(authRepo: widget.authRepo)),
          BlocProvider<RegistrationBloc>(
            create: (BuildContext context) => RegistrationBloc(
              authRepo: widget.authRepo,
            ),
          ),

          BlocProvider<UserBloc>(create: (BuildContext context) => UserBloc()),
          BlocProvider<GetInAppProductsBloc>(
              create: (BuildContext context) => GetInAppProductsBloc()),
          BlocProvider<BuyConsumableInAppProductsBloc>(
              create: (BuildContext context) => BuyConsumableInAppProductsBloc()),
          BlocProvider<UserfilterBloc>(create: (BuildContext context) => UserfilterBloc()),
          BlocProvider<SearchUserBloc>(
              create: (BuildContext context) => SearchUserBloc(
                  userSearchRepo: RepositoryProvider.of<SupabaseUserSearchRepo>(context))),
          BlocProvider<SearchUserForMapBloc>(
              create: (BuildContext context) => SearchUserForMapBloc()),
          BlocProvider<StreetviewdataBloc>(create: (BuildContext context) => StreetviewdataBloc()),
          BlocProvider<MatchUserBloc>(create: (BuildContext context) => MatchUserBloc()),
          BlocProvider<ReportBloc>(create: (BuildContext context) => ReportBloc()),
          BlocProvider<SwipeBloc>(
              create: (BuildContext context) => SwipeBloc(
                  userSearchRepo: RepositoryProvider.of<SupabaseUserSearchRepo>(context))),
          BlocProvider<BlocUserListBloc>(create: (BuildContext context) => BlocUserListBloc()),
          // BlocProvider<VideoCallCubit>(
          //     create: (BuildContext context) => VideoCallCubit()),
          BlocProvider<UserLocationBloc>(
            create: (context) => UserLocationBloc(
                userLocationReporistory: RepositoryProvider.of<UserLocationReporistory>(context)),
          ),
          BlocProvider(create: (_) => ConversationBloc()),
          BlocProvider(create: (_) => SendMessageBloc(chatMessageRepo: chatMessageRepo)),
          BlocProvider(create: (_) => AiProfilesBloc()),
          BlocProvider(
            create: (_) => AiAnonConvoBloc(
              anonConvoRepo: anonConvoRepo,
            ),
          ),
          BlocProvider(create: (_) => ItemsBloc()..add(LoadItems())),
          BlocProvider(create: (_) => PurchaseItemBloc()),
          BlocProvider(
            create: (_) => AnonProfileBloc(sharedPref: widget.sharedPreferences),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({
    super.key,
  });

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, state) {
        // final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Hookup 4u2',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          theme: MyThemes.darkTheme,
          darkTheme: MyThemes.darkTheme,
          routes: AppRouter.allRoutes,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            return MultiBlocListener(
              listeners: [
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.status == AuthStatus.unauthenticated) {
                      if (kIsWeb) {
                        context.read<AiProfilesBloc>().add(const FetchAiProfiles());
                        context.read<AnonProfileBloc>().add(const LoadAnonProfile());
                        _navigator.pushNamedAndRemoveUntil(
                          RouteName.webHomeScreen,
                          (route) => false,
                        );
                      } else {
                        _navigator.pushNamedAndRemoveUntil(
                          RouteName.phoneNumberScreen,
                          (route) => false,
                        );
                      }
                    } else if (state.status == AuthStatus.authenticated) {
                      BlocProvider.of<RegistrationBloc>(context)
                          .add(CheckRegistration(user: state.user));
                    }
                  },
                ),
                BlocListener<RegistrationBloc, RegistrationState>(
                  listener: (context, state) {
                    if (state is RegistrationProfile) {
                      _navigator.pushNamedAndRemoveUntil(
                        RouteName.tabScreen,
                        (route) => false,
                      );
                      context.read<ProfileVisitCubit>().fetchLikedBy(state.profile.id);
                    } else if (state is NewRegistration) {
                      debugPrint("from new registration");
                      // Navigator.pushNamedAndRemoveUntil(context, RouteName.welcomeScreen);
                      _navigator.pushNamedAndRemoveUntil(
                        RouteName.welcomeScreen,
                        (route) => false,
                      );
                    }
                  },
                )
              ],
              child: child ?? Container(),
            );
          },
          onGenerateRoute: (_) => SplashPage.route(),
        );
      },
    );
  }
}
