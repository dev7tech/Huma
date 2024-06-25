part of 'profile_visit_cubit.dart';

class ProfileVisitState extends Equatable {
  final List<String> likedBy;

  const ProfileVisitState({this.likedBy = const []});

  @override
  List<Object> get props => [];

  ProfileVisitState copyWith({
    List<String>? likedBy,
  }) {
    return ProfileVisitState(
      likedBy: likedBy ?? this.likedBy,
    );
  }
}
