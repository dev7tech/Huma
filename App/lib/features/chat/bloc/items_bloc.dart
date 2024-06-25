import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/chat/domain/models/item.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  ItemsBloc() : super(ItemsInitial()) {
    on<LoadItems>(_onLoadItems);
  }

  FutureOr<void> _onLoadItems(LoadItems event, Emitter<ItemsState> emit) async {
    emit(ItemsLoading());

    try {
      final data = await supabaseClient.from('items').select('*');

      emit(ItemsLoaded(data.map((i) => Item.fromJson(i)).toList()));
    } catch (error) {
      debugPrint('Error: $error');
      emit(const ItemsError('Unable to load items. Please try again.'));
    }
  }
}
