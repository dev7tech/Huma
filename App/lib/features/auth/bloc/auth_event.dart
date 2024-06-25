part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class _AuthStatusChanged extends AuthEvent {
  const _AuthStatusChanged(this.user);

  final AppUser user;
}

class AuthLogoutRequested extends AuthEvent {}
