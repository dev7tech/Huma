import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/ai/domain/models/ai_profile.dart';

part 'ai_profiles_event.dart';
part 'ai_profiles_state.dart';

class AiProfilesBloc extends Bloc<AiProfilesEvent, AiProfilesState> {
  AiProfilesBloc() : super(AiProfilesInitial()) {
    on<FetchAiProfiles>(_onFetchAiProfiles);
  }

  FutureOr<void> _onFetchAiProfiles(
      FetchAiProfiles event, Emitter<AiProfilesState> emit) async {
    emit(AiProfilesLoading());

    try {
      final profiles = await supabaseClient
          .from('ai_profiles')
          .select('*,ai_profile_images(*)');

      emit(AiProfilesLoaded(
          profiles.map((e) => AiProfile.fromJson(e)).toList()));
    } catch (e) {
      emit(AiProfilesError(e.toString()));
    }
  }
}
