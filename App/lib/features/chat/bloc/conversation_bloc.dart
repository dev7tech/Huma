import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/chat/domain/models/conversation.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationLoading()) {
    on<LoadConversationEvent>(_onLoadConversationEvent);
    on<UpsertConversationEvent>(_onUpsertConversationEvent);
  }

  FutureOr<void> _onLoadConversationEvent(
      LoadConversationEvent event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());
    try {
      final List<Map<String, dynamic>> response = await supabaseClient
          .from('conversations')
          .select('*,ai_profiles(*,ai_profile_images(*))')
          .eq('profiles_id', event.profileId);
      emit(ConversationLoaded(
          response.map((i) => Conversation.fromJson(i)).toList()));
    } catch (e) {
      emit(const ConversationError('Failed to load conversations'));
    }
  }

  FutureOr<void> _onUpsertConversationEvent(
      UpsertConversationEvent event, Emitter<ConversationState> emit) async {
    try {
      final response = await supabaseClient
          .from('conversations')
          .select('*,ai_profiles(*)')
          .eq('id', event.id)
          .single();

      final conversation = Conversation.fromJson(response);
      final List<Conversation> conversations = [...state.conversations];
      final index = conversations.indexWhere((i) => i.id == event.id);

      if (index != -1) {
        conversations[index] = conversation;
      } else {
        conversations.add(conversation);
      }
      emit(ConversationLoaded(conversations));
    } catch (e) {
      debugPrint('Failed to upsert conversation ${event.id}');
    }
  }
}
