import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hookup4u2/features/ai/domain/models/ai_profile_image.dart';

part 'ai_profile.freezed.dart';
part 'ai_profile.g.dart';

@freezed
class AiProfile with _$AiProfile {
  const factory AiProfile({
    required String id,
    required int age,
    required String name,
    required String location,
    required String ambitions,
    @JsonKey(name: 'ai_profile_images') List<AiProfileImage>? images,
  }) = _AiProfile;

  factory AiProfile.fromJson(Map<String, Object?> json) =>
      _$AiProfileFromJson(json);
}

extension AiProfileX on AiProfile {
  String? get profileImg {
    final profileImages = [...images ?? []];
    profileImages.sort((a, b) => a.isDefault ? -1 : 1);

    return profileImages.isEmpty ? null : profileImages.first.img;
  }
}
