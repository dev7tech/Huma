import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hookup4u2/features/chat/chat.dart';
import 'package:hookup4u2/features/home/domain/repo/anon_convo_repo.dart';

part 'ai_anon_convo_event.dart';
part 'ai_anon_convo_state.dart';

class AiAnonConvoBloc extends Bloc<AiAnonConvoEvent, AiAnonConvoState> {
  AiAnonConvoBloc({
    required this.anonConvoRepo,
  }) : super(AiAnonConvoInitial()) {
    on<StartAnonConvo>(_onStartAnonConvo);
  }
  final AnonConvoRepo anonConvoRepo;

  FutureOr<void> _onStartAnonConvo(StartAnonConvo event, Emitter<AiAnonConvoState> emit) async {
    emit(AiAnonConvoLoading());
    try {
      final convo = await anonConvoRepo.getOrCreateConvo(event.aiProfileId, event.anonId);
      emit(AiAnonConvoLoaded(convo));
    } catch (e) {
      emit(AiAnonConvoError(e.toString()));
    }
  }
}
