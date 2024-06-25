import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/features/auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(const AuthState.unknown()) {
    on<_AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    debugPrint('AUTH_LISTENING');

    _userSubscription = authRepo.onAuthStateChanged().listen((event) {
      add(_AuthStatusChanged(event));
    });
  }

  final AuthRepo _authRepo;
  StreamSubscription<AppUser>? _userSubscription;

  FutureOr<void> _onAuthStatusChanged(
      _AuthStatusChanged event, Emitter<AuthState> emit) {
    print('new user ${event.user} ${event.user.isEmpty}');
    emit(event.user.isEmpty
        ? const AuthState.unauthenticated()
        : AuthState.authenticated(event.user));
  }

  FutureOr<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepo.logOut();
  }

  @override
  close() {
    debugPrint('CLOSE AUTH_BLOC');
    _userSubscription?.cancel();
    return super.close();
  }
}
