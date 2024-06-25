import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/features/auth/auth.dart';
import 'package:hookup4u2/features/user/models/profile.dart';

import '../../../../../../models/user_model.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvents, RegistrationState> {
  final AuthRepo authRepo;

  RegistrationBloc({required this.authRepo}) : super(RegistrationInitial()) {
    on<CheckRegistration>(_onCheckRegistration);
    on<AlreadyRegistered>((event, emit) {
      emit(RegistrationProfile(profile: event.profile));
    });
    on<UpdateRegisteredProfile>(
      (event, emit) => emit(UpdateRegistrationProfile(profile: event.profile)),
    );
  }

  FutureOr<void> _onCheckRegistration(
      CheckRegistration event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    try {
      final profile = await authRepo.getProfile(event.user.id);
      profile != null && profile.profileSetup == true
          ? emit(RegistrationProfile(profile: profile))
          : emit(NewRegistration(user: event.user));
    } catch (e) {
      emit(RegistrationFailed(message: e.toString()));
    }
  }
}
