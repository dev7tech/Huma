import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchUserBloc extends Bloc<MatchUserEvent, MatchUserState> {
  MatchUserBloc() : super(MatchUserInitial()) {
    on<LoadMatchUserEvent>((event, emit) async {
      emit(MatchUserLoadingState());
      try {
        // List<UserModel> matchList =
        //     await UserMessagingRepo.getMatches(event.currentUser);
        // debugPrint("matchuser${matchList.toString()}");
        // debugPrint("matchuser from matchbloc");
        // emit(MatchUserLoadedState(matchList));
        emit(const MatchUserLoadedState([]));
      } catch (e) {
        emit(MatchUserFailedState());
        rethrow;
      }
    });
  }
}
