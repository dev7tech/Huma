part of 'ai_profiles_bloc.dart';

abstract class AiProfilesState extends Equatable {
  const AiProfilesState();

  @override
  List<Object> get props => [];
}

class AiProfilesInitial extends AiProfilesState {}

class AiProfilesLoading extends AiProfilesState {}

class AiProfilesLoaded extends AiProfilesState {
  final List<AiProfile> profiles;

  const AiProfilesLoaded(this.profiles);

  @override
  List<Object> get props => [profiles];
}

class AiProfilesError extends AiProfilesState {
  final String message;

  const AiProfilesError(this.message);

  @override
  List<Object> get props => [message];
}
