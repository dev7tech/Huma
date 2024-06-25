part of 'ai_anon_convo_bloc.dart';

abstract class AiAnonConvoState extends Equatable {
  const AiAnonConvoState();

  @override
  List<Object> get props => [];
}

class AiAnonConvoInitial extends AiAnonConvoState {}

class AiAnonConvoLoading extends AiAnonConvoState {}

class AiAnonConvoLoaded extends AiAnonConvoState {
  final Conversation aiAnonConvo;

  const AiAnonConvoLoaded(this.aiAnonConvo);

  @override
  List<Object> get props => [aiAnonConvo];
}

class AiAnonConvoError extends AiAnonConvoState {
  final String message;

  const AiAnonConvoError(this.message);

  @override
  List<Object> get props => [message];
}
