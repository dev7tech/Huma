import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/chat/ui/screens/chat_page.dart';
import 'package:hookup4u2/features/home/bloc/ai_anon_convo_bloc.dart';
import 'package:hookup4u2/features/home/bloc/ai_profiles_bloc.dart';
import 'package:hookup4u2/features/home/domain/model/anon_profile.dart';
import 'package:hookup4u2/features/home/ui/widgets/home/ai_profile_card.dart';

class AiProfiles extends StatelessWidget {
  final AnonProfile anonProfile;

  const AiProfiles({
    super.key,
    required this.anonProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AiAnonConvoBloc, AiAnonConvoState>(
      listener: (context, state) {
        if (state is AiAnonConvoError) {
          context.showError(state.message);
        }
        if (state is AiAnonConvoLoaded) {
          Navigator.of(context).push(ChatPage.route(state.aiAnonConvo));
        }
      },
      child: BlocBuilder<AiProfilesBloc, AiProfilesState>(
        builder: (context, state) {
          if (state is AiProfilesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AiProfilesError) {
            return Center(child: Text(state.message));
          } else if (state is AiProfilesLoaded) {
            return Center(
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth < 560
                        ? 1
                        : constraints.maxWidth < 800
                            ? 2
                            : 3;
                    final childAspectRatio = constraints.maxWidth < 560 ? 8 / 7 : 1.0;

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: childAspectRatio,
                      children: List.generate(state.profiles.length, (index) {
                        return AiProfileCard(
                          aiProfile: state.profiles[index],
                          anonProfile: anonProfile,
                        );
                      }),
                    );
                  },
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
