import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hookup4u2/features/user/user.dart';

part 'profile_dto.dart';

class ProfileCubit extends Cubit<ProfileDto> {
  ProfileCubit() : super(const ProfileDto());

  updateProfile({
    String? userName,
    DateTime? userDob,
    String? showMe,
    String? profileUrl,
  }) {
    emit(state.copyWith(
      userName: userName,
      userDob: userDob,
      showMe: showMe,
      profileUrl: profileUrl,
    ));
  }
}
