part of 'forgotpassword_bloc.dart';

abstract class ForgotpasswordEvent extends Equatable {
  const ForgotpasswordEvent();

  @override
  List<Object> get props => [];
}

// When the user reset password with email  this event is called and the [AuthRepository] is called to reset the user the user
class ResetPasswordRequested extends ForgotpasswordEvent {
  final String email;

  const ResetPasswordRequested(this.email);
}
