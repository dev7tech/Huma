part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  final Profile profile;

  const RegistrationState([this.profile = Profile.empty]);
  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final UserModel user;
  const RegistrationSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class RegistrationFailed extends RegistrationState {
  final String message;
  const RegistrationFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class RegistrationProfile extends RegistrationState {
  const RegistrationProfile({required Profile profile}) : super(profile);

  @override
  List<Object> get props => [profile];
}

class UpdateRegistrationProfile extends RegistrationState {
  const UpdateRegistrationProfile({required Profile profile}) : super(profile);

  @override
  List<Object> get props => [profile];
}

class NewRegistration extends RegistrationState {
  final AppUser user;

  const NewRegistration({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}
