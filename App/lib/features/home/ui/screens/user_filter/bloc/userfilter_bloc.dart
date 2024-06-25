import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/data/repo/user_repo.dart';

part 'userfilter_event.dart';
part 'userfilter_state.dart';

class UserfilterBloc extends Bloc<UserfilterEvent, UserfilterState> {
  UserfilterBloc() : super(UserfilterInitial()) {
    on<ChangefilterRequest>((event, emit) async {
      emit(UpdatingUserFilter());
      try {
        debugPrint("ankit i am in filterbloc");
        await UserRepo.updatefilter(event.details);
        debugPrint("ankit i am in filterbloc after update");
        emit(UserFilterUpdated());
      } on SocketException {
        emit(const UserFilterUpdationFailed(message: 'No Internet Connection'));
      } catch (e) {
        rethrow;
      }
    });
  }
}
