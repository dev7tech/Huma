// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'phone_auth_bloc.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState({this.phone = ''});

  final String phone;

  @override
  List<Object> get props => [];
}

class PhoneAuthInitial extends PhoneAuthState {}

// This state is used to show the loading indicator when the phone number is being sent to the server for verification and the user is being redirected to the verification page.
class PhoneAuthLoading extends PhoneAuthState {
  const PhoneAuthLoading([String phone = '']) : super(phone: phone);
}

class PhoneAuthResending extends PhoneAuthState {
  const PhoneAuthResending([String phone = '']) : super(phone: phone);
}

// This state is used to show the error message.
class PhoneAuthError extends PhoneAuthState {
  final String error;

  const PhoneAuthError({required this.error, String phone = ''})
      : super(phone: phone);

  @override
  List<Object> get props => [error];
}

// This state indicates that verification is completed and the user is being redirected to the home page.
// ignore: must_be_immutable
class PhoneAuthVerified extends PhoneAuthState {
  const PhoneAuthVerified({
    required String phone,
  }) : super(phone: phone);
}

// This state is used to show the OTP widget in which the user enters the OTP sent to his/her phone number.
class PhoneAuthCodeSentSuccess extends PhoneAuthState {
  const PhoneAuthCodeSentSuccess({required String phone}) : super(phone: phone);

  @override
  List<Object> get props => [phone];
}

class PhoneAuthCodeResent extends PhoneAuthState {
  const PhoneAuthCodeResent({required String phone}) : super(phone: phone);

  @override
  List<Object> get props => [phone];
}

class PhoneUpdateSuccess extends PhoneAuthState {
  final String verificationId;
  const PhoneUpdateSuccess({
    required this.verificationId,
  });
  @override
  List<Object> get props => [verificationId];
}
