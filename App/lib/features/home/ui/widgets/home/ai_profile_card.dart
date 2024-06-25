import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/features/ai/domain/models/ai_profile.dart';
import 'package:hookup4u2/features/home/bloc/ai_anon_convo_bloc.dart';
import 'package:hookup4u2/features/home/domain/model/anon_profile.dart';

class AiProfileCard extends StatelessWidget {
  const AiProfileCard({
    super.key,
    required this.aiProfile,
    required this.anonProfile,
  });

  final AiProfile aiProfile;
  final AnonProfile anonProfile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // final imgHeight = constraints.maxHeight * 0.35;

        return BlocBuilder<AiAnonConvoBloc, AiAnonConvoState>(
          builder: (context, state) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: constraints.maxHeight * 1,
                width: double.maxFinite,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade600,
                        image: aiProfile.profileImg == null
                            ? null
                            : DecorationImage(
                                image: NetworkImage(aiProfile.profileImg!),
                                fit: BoxFit.cover,
                                // colorFilter:
                                //     new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                              ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.25),
                            Colors.black.withOpacity(0.17),
                            Colors.black.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   height: imgHeight / 2,
                          // ),
                          const Spacer(),
                          Text(
                            aiProfile.name,
                            style: textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            aiProfile.ambitions,
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                          const Spacer(),
                          OutlinedButton(
                            onPressed: state is AiAnonConvoLoading
                                ? null
                                : () {
                                    context.read<AiAnonConvoBloc>().add(
                                          StartAnonConvo(aiProfile.id, anonProfile.id),
                                        );
                                  },
                            child: const Text('Start Chat'),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
