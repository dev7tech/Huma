part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChat extends ChatEvent {
  final String conversationId;

  const LoadChat(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class ChatMessageReceived extends ChatEvent {
  final ChatMessage message;

  const ChatMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class LoadMoreChat extends ChatEvent {
  final String conversationId;
  final ChatMessage lastMessage;

  const LoadMoreChat(this.conversationId, this.lastMessage);

  @override
  List<Object> get props => [conversationId, lastMessage];
}
