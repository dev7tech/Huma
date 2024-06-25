part of 'conversation_bloc.dart';

// State
abstract class ConversationState extends Equatable {
  final List<Conversation> conversations;

  const ConversationState({this.conversations = const []});

  @override
  List<Object> get props => [conversations];
}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  const ConversationLoaded(List<Conversation> conversations)
      : super(conversations: conversations);
}

class ConversationError extends ConversationState {
  final String errorMessage;

  const ConversationError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
