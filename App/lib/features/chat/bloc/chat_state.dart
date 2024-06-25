part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<ChatMessage> chats;
  final bool hasReachedEnd;

  const ChatState({this.chats = const [], this.hasReachedEnd = false});

  @override
  List<Object> get props => [chats];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  const ChatLoaded(List<ChatMessage> chats, [bool hasReachedEnd = false])
      : super(
          chats: chats,
          hasReachedEnd: hasReachedEnd,
        );

  @override
  List<Object> get props => [chats];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}

class ChatMoreLoading extends ChatState {
  const ChatMoreLoading(List<ChatMessage> chats) : super(chats: chats);
}
