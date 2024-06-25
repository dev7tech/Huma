part of 'ai_profiles_bloc.dart';

abstract class AiProfilesEvent extends Equatable {
  const AiProfilesEvent();

  @override
  List<Object> get props => [];
}

class FetchAiProfiles extends AiProfilesEvent {
  const FetchAiProfiles();
}
