import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/chat/chat.dart';
import 'package:hookup4u2/features/chat/domain/models/item.dart';

part 'purchase_item_event.dart';
part 'purchase_item_state.dart';

class PurchaseItemBloc extends Bloc<PurchaseItemEvent, PurchaseItemState> {
  PurchaseItemBloc() : super(PurchaseItemInitial()) {
    on<PurchaseItem>(_onPurchaseItem);
  }

  FutureOr<void> _onPurchaseItem(PurchaseItem event, Emitter<PurchaseItemState> emit) async {
    emit(PurchaseItemLoading());

    try {
      // Perform purchase logic here
      await supabaseClient.from('chat_messages').insert(
            SendMessageDto(
              message: '${event.userProfileName} has sent you a gift item ${event.item.name ?? ''}',
              profileId: (event.conversation.type == 'user'
                  ? event.conversation.profilesId
                  : event.conversation.anonProfilesId)!,
              conversationId: event.conversation.id,
              receiverId: event.conversation.aiProfileId,
              itemsId: event.item.id,
            ),
          );

      emit(PurchaseItemSuccess());
    } catch (e) {
      emit(PurchaseItemFailure(error: e.toString()));
    }
  }
}
