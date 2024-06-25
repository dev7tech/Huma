part of 'forgotpassword_bloc.dart';

abstract class ForgotpasswordState extends Equatable {
  const ForgotpasswordState();

  @override
  List<Object> get props => [];
}

class ForgotpasswordInitial extends ForgotpasswordState {}

class ForgotPasswordLoding extends ForgotpasswordState {}

class ForgotPasswordSuccess extends ForgotpasswordState {}

class ForgotPasswordError extends ForgotpasswordState {
  final String error;
  const ForgotPasswordError(this.error);
}
