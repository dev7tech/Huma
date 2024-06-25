part of 'search_user_bloc.dart';

abstract class SearchUserState extends Equatable {
  const SearchUserState();

  @override
  List<Object> get props => [];
}

class SearchUserInitial extends SearchUserState {}

class SearchUserLoadingState extends SearchUserState {}

class SearchUserLoadUserState extends SearchUserState {
  final List<Profile> users;

  const SearchUserLoadUserState(this.users);

  @override
  List<Object> get props => [users];
}

class SearchUserFailedState extends SearchUserState {}
