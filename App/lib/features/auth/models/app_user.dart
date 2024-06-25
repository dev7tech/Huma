import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AppUser extends Equatable {
  const AppUser({required this.id, required this.email, required this.token});

  final String id;
  final String email;
  final String token;

  factory AppUser.fromSession(Session? session) => session == null
      ? AppUser.empty
      : AppUser(
          id: session.user.id,
          email: session.user.email ?? '',
          token: session.accessToken,
        );

  static const empty = AppUser(id: '-', email: '-', token: '-');

  bool get isEmpty => this == AppUser.empty;

  @override
  List<Object> get props => [id, email];

  @override
  String toString() {
    return 'User { id: $id, email: $email }';
  }
}
