part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfilePicUploading extends ProfileState {}

class ProfilePicUploaded extends ProfileState {
  final String imageUrl;

  const ProfilePicUploaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ProfileUploading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileUpdated extends ProfileState {
  final Profile profile;

  const ProfileUpdated(this.profile);

  @override
  List<Object> get props => [profile];
}

class ProfileSuccess extends ProfileState {}

class ProfileMediaUploading extends ProfileState {}

class ProfileMediaUploaded extends ProfileState {
  final String imageUrl;

  const ProfileMediaUploaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ProfileMediaSuccess extends ProfileState {}
