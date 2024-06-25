part of 'ai_anon_convo_bloc.dart';

abstract class AiAnonConvoEvent extends Equatable {
  const AiAnonConvoEvent();

  @override
  List<Object> get props => [];
}

class StartAnonConvo extends AiAnonConvoEvent {
  final String aiProfileId;
  final String anonId;

  const StartAnonConvo(this.aiProfileId, this.anonId);

  @override
  List<Object> get props => [aiProfileId, anonId];
}
