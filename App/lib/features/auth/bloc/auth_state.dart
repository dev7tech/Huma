part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user = AppUser.empty,
  });

  final AuthStatus status;
  final AppUser user;

  const AuthState.unknown() : this._();

  const AuthState.authenticated(AppUser user)
      : this._(user: user, status: AuthStatus.authenticated);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}
