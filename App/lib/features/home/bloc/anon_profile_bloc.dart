import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/home/domain/model/anon_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'anon_profile_event.dart';
part 'anon_profile_state.dart';

const kProfileKey = 'profile';

class AnonProfileBloc extends Bloc<AnonProfileEvent, AnonProfileState> {
  final SharedPreferences sharedPref;

  AnonProfileBloc({
    required this.sharedPref,
  }) : super(AnonProfileInitial()) {
    on<LoadAnonProfile>(_onLoadAnonProfile);
    on<CreateAnonProfile>(_onCreateAnonProfile);
  }

  FutureOr<void> _onLoadAnonProfile(LoadAnonProfile event, Emitter<AnonProfileState> emit) async {
    emit(AnonProfileLoading());

    final profileJson = sharedPref.getString(kProfileKey);
    if (profileJson == null) {
      emit(AnonProfileEmpty());
      return;
    }

    final profile = AnonProfile.fromJson(jsonDecode(profileJson));

    try {
      final data =
          await supabaseClient.from('anon_profiles').select('*').eq('id', profile.id).single();

      emit(AnonProfileLoaded(AnonProfile.fromJson(data)));
    } catch (_err) {
      log('Failed to load profile: $_err', name: 'AnonProfileBloc');
      emit(const AnonProfileError('Failed to load profile'));
    }
  }

  FutureOr<void> _onCreateAnonProfile(
      CreateAnonProfile event, Emitter<AnonProfileState> emit) async {
    emit(AnonProfileCreating());

    try {
      final data = await supabaseClient
          .from('anon_profiles')
          .insert({'id': event.id, 'name': event.name})
          .select('*')
          .single();

      final profile = AnonProfile.fromJson(data);

      await sharedPref.setString(kProfileKey, jsonEncode(profile.toJson()));

      emit(AnonProfileLoaded(profile));
    } catch (_err) {
      log('Failed to create profile: $_err', name: 'AnonProfileBloc');
      emit(const AnonProfileError('Failed to create profile, please try again'));
    }
  }
}
