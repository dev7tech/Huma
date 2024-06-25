part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class LoadConversationEvent extends ConversationEvent {
  final String profileId;

  const LoadConversationEvent(this.profileId);

  @override
  List<Object> get props => [profileId];
}

class UpsertConversationEvent extends ConversationEvent {
  final String id;

  const UpsertConversationEvent(this.id);

  @override
  List<Object> get props => [id];
}
