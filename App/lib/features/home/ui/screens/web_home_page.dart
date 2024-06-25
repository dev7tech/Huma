import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/common/routes/route_name.dart';
import 'package:hookup4u2/features/home/bloc/anon_profile_bloc.dart';
import 'package:hookup4u2/features/home/ui/widgets/home/ai_profiles.dart';
import 'package:hookup4u2/features/home/ui/widgets/home/anon_profile_form.dart';
import 'package:hookup4u2/features/home/ui/widgets/home/loading.dart';

class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const WebHomePage(),
      );

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Huma'),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(RouteName.phoneNumberScreen);
          //   },
          //   icon: const Icon(Icons.login),
          // ),
        ],
      ),
      body: BlocConsumer<AnonProfileBloc, AnonProfileState>(
        listener: (context, state) {
          if (state is AnonProfileError) {
            context.showError(state.message);
          }
        },
        builder: (context, state) {
          if (state is AnonProfileLoading) {
            return const Loading(message: 'Looking for profile');
          }
          if (state is AnonProfileEmpty || state is AnonProfileCreating) {
            return const AnonProfileForm();
          }
          if (state is AnonProfileLoaded) {
            return AiProfiles(anonProfile: state.anonProfile);
          }

          return const Loading(message: 'Processing');
        },
      ),
    );
  }
}
