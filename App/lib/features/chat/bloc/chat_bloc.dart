import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/chat/domain/models/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

const kChatLimit = 20;

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChat>(_onLoadChat);
    on<ChatMessageReceived>(_onChatMessageReceived);
    on<LoadMoreChat>(_onLoadMoreChat);
  }

  FutureOr<void> _onLoadChat(LoadChat event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final List<Map<String, dynamic>> response = await supabaseClient
          .from('chat_messages')
          .select('*')
          .eq('conversations_id', event.conversationId)
          .eq('sleep_order', false)
          .neq('message', '')
          .order('created_at', ascending: false)
          .limit(kChatLimit);
      emit(
        ChatLoaded(
          response.map((i) => ChatMessage.fromJson(i)).toList(),
          response.length < kChatLimit,
        ),
      );
    } catch (e) {
      debugPrint('Failed to load chats: $e');
      emit(const ChatError('Failed to load chats'));
      rethrow;
    }
  }

  FutureOr<void> _onChatMessageReceived(ChatMessageReceived event, Emitter<ChatState> emit) {
    final msgExists = state.chats.any((item) => item.id == event.message.id);

    if (!msgExists) {
      emit(ChatLoaded([event.message, ...state.chats]));
    }
  }

  FutureOr<void> _onLoadMoreChat(LoadMoreChat event, Emitter<ChatState> emit) async {
    if (state is ChatLoading || state is ChatMoreLoading) return;

    emit(ChatMoreLoading(state.chats));
    try {
      final List<Map<String, dynamic>> response = await supabaseClient
          .from('chat_messages')
          .select('*')
          .eq('conversations_id', event.conversationId)
          .eq('sleep_order', false)
          .neq('message', '')
          .lt('created_at', event.lastMessage.createdAt)
          .order('created_at', ascending: false)
          .limit(kChatLimit);
      emit(
        ChatLoaded(
          [
            ...state.chats,
            ...response.map((i) => ChatMessage.fromJson(i)),
          ],
          response.length < kChatLimit,
        ),
      );
    } catch (e) {
      debugPrint('Failed to load more chats: $e');
      emit(const ChatError('Failed to load more chats'));
      rethrow;
    }
  }
}
