class Profile {
  final String id;
  final String? userName;
  final DateTime? userDob;
  final String? showMe;
  final String? profileUrl;
  final List<String> imgs;
  final bool profileSetup;

  const Profile({
    required this.id,
    this.userName,
    this.userDob,
    this.showMe,
    this.profileUrl,
    this.imgs = const [],
    this.profileSetup = false,
  });

  static const empty = Profile(id: '');

  bool get isEmpty => this == Profile.empty;

  int? get age => userDob != null ? DateTime.now().year - userDob!.year : null;

  String get parsedName => '${userName ?? ''}${age != null ? ', $age' : ''}';

  String get profileInfo => "$userName, $age";

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      userName: map['name'],
      userDob: DateTime.tryParse(map['birth_date'] ?? ''),
      showMe: map['show'],
      profileUrl: map['profile_url'],
      imgs: List<String>.from(map['imgs'] ?? []),
      profileSetup: map['profile_setup'] ?? false,
    );
  }

  String? get mainProfileUrl => profileUrl;

  List<String> get images {
    final List<String> imgList = [];
    if (profileUrl != null) {
      imgList.add(profileUrl!);
    }

    return [...imgList, ...imgs];
  }

  @override
  String toString() {
    return 'Profile{id: $id, userName: $userName }';
  }
}
