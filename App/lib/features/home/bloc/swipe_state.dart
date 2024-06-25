part of 'swipe_bloc.dart';

abstract class SwipeBlocState extends Equatable {
  const SwipeBlocState();

  @override
  List<Object> get props => [];
}

class SwipeBlocInitial extends SwipeBlocState {}

class SwipeFailedState extends SwipeBlocState {}

class SwipeSuccessState extends SwipeBlocState {
  final List<Profile> users;

  const SwipeSuccessState(this.users);

  @override
  List<Object> get props => [users];
}
