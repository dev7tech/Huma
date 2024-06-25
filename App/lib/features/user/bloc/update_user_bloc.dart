import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/data/repo/user_repo.dart';

import 'package:hookup4u2/features/user/bloc/update_user_state.dart';
import 'package:hookup4u2/features/user/bloc/user_event.dart';
import 'package:hookup4u2/services/firestore_database.dart';

// TODO: Remove

class UserBloc extends Bloc<UserEvents, UserStates> {
  UserBloc() : super(UpdateUserInitial()) {
    on<UpdateUserRequest>((event, emit) async {
      emit(UpdatingUser());
      try {
        debugPrint("ankit i am in userbloc");
        await UserRepo.updateData(event.details);
        emit(UserUpdated());
      } on SocketException {
        emit(const UserUpdationFailed(message: 'No Internet Connection'));
      } catch (e) {
        rethrow;
      }
    });
    on<UpdateUserProfilePictures>((event, emit) async {
      emit(UpdatingUser());
      try {
        var task = await FireStoreClass.uploadFile(
            currentUser: event.currentUser,
            checktype: event.checktype,
            file: event.photo);
        final imageUrl = await task?.snapshot.ref.getDownloadURL();

        emit(UserProfilePictureUploaded(url: imageUrl));
      } on SocketException {
        emit(const UserUpdationFailed(message: 'No Internet Connection'));
      } catch (e) {
        emit(UserUpdationFailed(message: e.toString()));
      }
    });
  }
}
