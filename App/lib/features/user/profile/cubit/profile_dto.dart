part of 'profile_cubit.dart';

enum FormStatus { initial, loading, success, error }

class ProfileDto extends Equatable {
  final String? userName;
  final DateTime? userDob;
  final String? showMe;
  final String? profileUrl;
  final List<String> imgs;
  final bool profileSetup;

  const ProfileDto({
    this.userName = '',
    this.userDob,
    this.showMe = '',
    this.profileUrl,
    this.imgs = const [],
    this.profileSetup = false,
  });

  factory ProfileDto.fromProfile(Profile profile) {
    return ProfileDto(
      userName: profile.userName,
      userDob: profile.userDob,
      showMe: profile.showMe,
      profileUrl: profile.profileUrl,
      imgs: profile.imgs,
      profileSetup: profile.profileSetup,
    );
  }

  ProfileDto copyWith({
    String? userName,
    DateTime? userDob,
    String? showMe,
    String? profileUrl,
    List<String>? imgs,
    bool? profileSetup,
  }) {
    return ProfileDto(
      userName: userName ?? this.userName,
      userDob: userDob ?? this.userDob,
      showMe: showMe ?? this.showMe,
      profileUrl: profileUrl ?? this.profileUrl,
      imgs: imgs ?? this.imgs,
      profileSetup: profileSetup ?? this.profileSetup,
    );
  }

  @override
  List<Object?> get props => [
        userName,
        userDob,
        showMe,
        profileUrl,
      ];

  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'birth_date': userDob?.toIso8601String(),
      'show': showMe,
      'profile_url': profileUrl,
      'imgs': imgs,
      'profile_setup': profileSetup,
    };
  }

  @override
  String toString() {
    return 'ProfileState(userName: $userName, userDob: $userDob, showMe: $showMe, profileUrl: $profileUrl)';
  }
}
