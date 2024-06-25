import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/auth_repositories.dart';
part 'forgotpassword_event.dart';
part 'forgotpassword_state.dart';

class ForgotpasswordBloc
    extends Bloc<ForgotpasswordEvent, ForgotpasswordState> {
  final AuthRepository authRepository;
  ForgotpasswordBloc(this.authRepository) : super(ForgotpasswordInitial()) {
    // when user hit forgot password
    on<ResetPasswordRequested>((event, emit) async {
      emit(ForgotPasswordLoding());
      try {
        await authRepository.resetPassword(
          email: event.email,
        );
        emit(ForgotPasswordSuccess());
      } catch (e) {
        emit(ForgotPasswordError(e.toString()));
      }
    });
  }
}
