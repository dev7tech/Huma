part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfilePicUpload extends ProfileEvent {
  final File img;

  const ProfilePicUpload(this.img);

  @override
  List<Object?> get props => [img];
}

class ProfileUpdate extends ProfileEvent {
  final ProfileDto profileDto;

  const ProfileUpdate(this.profileDto);

  @override
  List<Object?> get props => [profileDto];
}

class ProfileMediaUpload extends ProfileEvent {
  final File img;

  const ProfileMediaUpload(this.img);

  @override
  List<Object?> get props => [img];
}
