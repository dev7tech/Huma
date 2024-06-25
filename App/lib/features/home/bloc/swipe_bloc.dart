import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/features/user/user.dart';

import '../../../common/data/repo/user_search_repo.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeBlocEvent, SwipeBlocState> {
  final SupabaseUserSearchRepo userSearchRepo;

  SwipeBloc({required this.userSearchRepo}) : super(SwipeBlocInitial()) {
    on<LeftSwipeEvent>(_onLeftSwipe);
    on<RightSwipeEvent>(_onRightSwipe);
  }

  FutureOr<void> _onLeftSwipe(
      LeftSwipeEvent event, Emitter<SwipeBlocState> emit) async {
    // emit(SearchUserLoadingState());
    try {
      await userSearchRepo.leftSwipe(event.currentUser, event.selectedUser);

      // TODO: Validate refetching the user list
      // List<Profile> userList = await userSearchRepo.getUserList(event.currentUser);
      // emit(SwipeSuccessState(userList));
    } catch (e) {
      emit(SwipeFailedState());
    }
  }

  FutureOr<void> _onRightSwipe(
      RightSwipeEvent event, Emitter<SwipeBlocState> emit) async {
    try {
      await userSearchRepo.rightSwipe(event.currentUser, event.selectedUser);
    } catch (e) {
      emit(SwipeFailedState());
    }
  }
}
