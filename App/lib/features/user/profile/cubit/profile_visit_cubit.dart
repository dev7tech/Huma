import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hookup4u2/common/data/repo/user_search_repo.dart';

part 'profile_visit_state.dart';

class ProfileVisitCubit extends Cubit<ProfileVisitState> {
  final SupabaseUserSearchRepo userSearchRepo;

  ProfileVisitCubit({required this.userSearchRepo})
      : super(const ProfileVisitState());

  fetchLikedBy(String profileId) async {
    final likedBy = await userSearchRepo.fetchLikedBy(profileId);
    emit(state.copyWith(likedBy: likedBy));
  }
}
