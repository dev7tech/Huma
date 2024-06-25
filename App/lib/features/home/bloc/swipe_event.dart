part of 'swipe_bloc.dart';

abstract class SwipeBlocEvent extends Equatable {
  const SwipeBlocEvent();

  @override
  List<Object> get props => [];
}

class RightSwipeEvent extends SwipeBlocEvent {
  final Profile currentUser, selectedUser;

  const RightSwipeEvent(
      {required this.currentUser, required this.selectedUser});

  @override
  List<Object> get props => [currentUser, selectedUser];
}

class LeftSwipeEvent extends SwipeBlocEvent {
  final Profile currentUser, selectedUser;

  const LeftSwipeEvent({required this.currentUser, required this.selectedUser});

  @override
  List<Object> get props => [currentUser, selectedUser];
}
