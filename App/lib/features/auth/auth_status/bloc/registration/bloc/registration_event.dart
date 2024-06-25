part of 'registration_bloc.dart';

abstract class RegistrationEvents extends Equatable {
  const RegistrationEvents();
  @override
  List<Object> get props => [];
}

class CheckRegistration extends RegistrationEvents {
  final AppUser user;

  const CheckRegistration({required this.user});

  @override
  List<Object> get props => [user];
}

class AlreadyRegistered extends RegistrationEvents {
  final Profile profile;

  const AlreadyRegistered({required this.profile});

  @override
  List<Object> get props => [profile];
}

class UpdateRegisteredProfile extends RegistrationEvents {
  final Profile profile;

  const UpdateRegisteredProfile(this.profile);

  @override
  List<Object> get props => [profile];
}
