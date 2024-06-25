part of 'send_message_bloc.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object> get props => [];
}

class SendMessageInitial extends SendMessageState {}

class SendMessageInProgress extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {}

class SendMessageError extends SendMessageState {
  final String message;

  const SendMessageError(this.message);

  @override
  List<Object> get props => [message];
}
