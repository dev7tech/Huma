import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/chat/data/chat_message_repo.dart';
import 'package:hookup4u2/features/chat/domain/models/chat_message.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  SendMessageBloc({
    required this.chatMessageRepo,
  }) : super(SendMessageInitial()) {
    on<SendMessage>(_onSendMessage);
  }

  final ChatMessageRepo chatMessageRepo;

  _tryClear(ChatMessage lastMessage, SendMessageDto dto) async {
    if (chatMessageRepo.shouldClear(lastMessage)) {
      debugPrint('Clearing chat convo');
      await supabaseClient
          .from('chat_messages')
          .insert(dto.copyWith(message: '', sleepOrder: true).toJson());

      // Add delay for clear to finish
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  FutureOr<void> _onSendMessage(SendMessage event, Emitter<SendMessageState> emit) async {
    emit(SendMessageInProgress());

    try {
      if (event.lastMessage != null) {
        await _tryClear(event.lastMessage!, event.dto);
      }
      await supabaseClient.from('chat_messages').insert(event.dto.toJson());

      emit(SendMessageSuccess());
    } catch (e) {
      debugPrint('Failed to send message: $e');
      emit(const SendMessageError('Failed to send message. Please try again.'));
    }
  }
}
