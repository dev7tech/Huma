part of 'search_user_bloc.dart';

abstract class SearchUserEvent extends Equatable {
  const SearchUserEvent();

  @override
  List<Object> get props => [];
}

class LoadUserEvent extends SearchUserEvent {
  final Profile currentUser;

  const LoadUserEvent({
    required this.currentUser,
  });

  @override
  List<Object> get props => [currentUser];
}
