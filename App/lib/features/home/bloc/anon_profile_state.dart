part of 'anon_profile_bloc.dart';

abstract class AnonProfileState extends Equatable {
  const AnonProfileState();

  @override
  List<Object> get props => [];
}

class AnonProfileInitial extends AnonProfileState {}

class AnonProfileLoading extends AnonProfileState {}

class AnonProfileError extends AnonProfileState {
  final String message;

  const AnonProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class AnonProfileEmpty extends AnonProfileState {}

class AnonProfileLoaded extends AnonProfileState {
  final AnonProfile anonProfile;

  const AnonProfileLoaded(this.anonProfile);

  @override
  List<Object> get props => [anonProfile];
}

class AnonProfileCreating extends AnonProfileState {}
