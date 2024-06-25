part of 'send_message_bloc.dart';

abstract class SendMessageEvent extends Equatable {
  const SendMessageEvent();

  @override
  List<Object> get props => [];
}

class SendMessage extends SendMessageEvent {
  final SendMessageDto dto;
  final ChatMessage? lastMessage;

  const SendMessage(this.dto, this.lastMessage);

  @override
  List<Object> get props => [dto];
}
