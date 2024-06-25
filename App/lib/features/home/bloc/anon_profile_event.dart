part of 'anon_profile_bloc.dart';

abstract class AnonProfileEvent extends Equatable {
  const AnonProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadAnonProfile extends AnonProfileEvent {
  const LoadAnonProfile();
}

class CreateAnonProfile extends AnonProfileEvent {
  final String name;
  final String id;

  const CreateAnonProfile(this.id, this.name);

  @override
  List<Object> get props => [id, name];
}
