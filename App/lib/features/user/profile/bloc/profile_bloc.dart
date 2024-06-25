import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hookup4u2/features/auth/auth.dart';
import 'package:hookup4u2/features/user/models/profile.dart';
import 'package:hookup4u2/features/user/profile/cubit/profile_cubit.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(ProfileInitial()) {
    on<ProfilePicUpload>(_onProfilePicUpload);
    on<ProfileUpdate>(_onProfileUpload);
    on<ProfileMediaUpload>(_onProfileMediaUpload);
  }

  final AuthRepo _authRepo;

  _onProfilePicUpload(
      ProfilePicUpload event, Emitter<ProfileState> emit) async {
    emit(ProfilePicUploading());
    try {
      final path = await _authRepo.uploadUserPic(event.img);
      emit(ProfilePicUploaded(path));
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
  }

  FutureOr<void> _onProfileUpload(
      ProfileUpdate event, Emitter<ProfileState> emit) async {
    emit(ProfileUploading());
    try {
      final profile = await _authRepo.updateProfile(event.profileDto);
      emit(ProfileUpdated(profile));
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
  }

  FutureOr<void> _onProfileMediaUpload(
      ProfileMediaUpload event, Emitter<ProfileState> emit) async {
    emit(ProfileMediaUploading());
    try {
      final path = await _authRepo.uploadUserPic(event.img, 'medias');
      emit(ProfileMediaUploaded(path));
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
  }
}
