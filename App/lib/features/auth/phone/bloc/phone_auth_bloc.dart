import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/features/auth/auth.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final AuthRepo _authRepo;

  PhoneAuthBloc({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(PhoneAuthInitial()) {
    on<SendOtpToPhone>(_onSendOtp);

    on<ReSendOtpToPhone>(_onReSendOtp);

    on<VerifyOtpSent>(_onVerifyOtp);
  }

  FutureOr<void> _onSendOtp(
      SendOtpToPhone event, Emitter<PhoneAuthState> emit) async {
    emit(const PhoneAuthLoading());
    try {
      await _authRepo.login(event.phoneNumber);
      emit(PhoneAuthCodeSentSuccess(phone: event.phoneNumber));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString(), phone: event.phoneNumber));
    }
  }

  FutureOr<void> _onReSendOtp(
      ReSendOtpToPhone event, Emitter<PhoneAuthState> emit) async {
    emit(PhoneAuthResending(event.phoneNumber));
    try {
      await _authRepo.login(event.phoneNumber);
      emit(PhoneAuthCodeResent(phone: event.phoneNumber));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString(), phone: event.phoneNumber));
    }
  }

  FutureOr<void> _onVerifyOtp(
      VerifyOtpSent event, Emitter<PhoneAuthState> emit) async {
    try {
      emit(PhoneAuthLoading(event.phone));
      await _authRepo.verifyOtp(event.phone, event.otpCode);
      emit(PhoneAuthVerified(phone: event.phone));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString(), phone: event.phone));
    }
  }
}
