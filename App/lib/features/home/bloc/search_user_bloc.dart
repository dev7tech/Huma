import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/features/user/user.dart';

import '../../../common/data/repo/user_search_repo.dart';

part 'search_user_event.dart';
part 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final SupabaseUserSearchRepo userSearchRepo;

  SearchUserBloc({required this.userSearchRepo}) : super(SearchUserInitial()) {
    on<LoadUserEvent>(_onLoadUsers);
  }

  FutureOr<void> _onLoadUsers(
      LoadUserEvent event, Emitter<SearchUserState> emit) async {
    emit(SearchUserLoadingState());
    try {
      debugPrint("called for map false");
      // List<UserModel> userList = await UserSearchRepo.getUserList(event.currentUser);
      final users = await userSearchRepo.getUserList(event.currentUser);
      emit(SearchUserLoadUserState(users));
    } catch (e) {
      emit(SearchUserFailedState());
      rethrow;
    }
  }
}
