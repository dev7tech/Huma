// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'phone_auth_bloc.dart';

abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object> get props => [];
}

// This event will be triggered when the user enters the phone number and presses the Send OTP button on the UI.
class SendOtpToPhone extends PhoneAuthEvent {
  final String phoneNumber;

  const SendOtpToPhone({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

// This event will be triggered when the user enters the phone number and presses the Send OTP button on the UI.
class ReSendOtpToPhone extends PhoneAuthEvent {
  final String phoneNumber;

  const ReSendOtpToPhone({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

// This event will be triggered when the user enters the OTP and presses the Verify OTP button on the UI.
class VerifyOtpSent extends PhoneAuthEvent {
  final String otpCode;
  final String phone;

  const VerifyOtpSent({required this.otpCode, required this.phone});

  @override
  List<Object> get props => [otpCode, phone];
}

// This event will be triggered when any error occurs while sending the OTP to the user's phone number. This can be due to network issues or firebase's error.
class PhoneAuthErrorEvent extends PhoneAuthEvent {
  final String error;
  const PhoneAuthErrorEvent({required this.error});

  @override
  List<Object> get props => [error];
}

// This event will be triggered when the verification of the OTP is successful.
class PhoneAuthVerificationComplete extends PhoneAuthEvent {
  const PhoneAuthVerificationComplete();
}

class PhoneNumberUpdate extends PhoneAuthEvent {
  final String verificationId;
  final String token;
  final String phoneNumber;
  const PhoneNumberUpdate({
    required this.verificationId,
    required this.token,
    required this.phoneNumber,
  });
}
