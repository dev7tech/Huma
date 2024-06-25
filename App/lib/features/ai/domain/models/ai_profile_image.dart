import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'ai_profile_image.freezed.dart';
part 'ai_profile_image.g.dart';

@freezed
class AiProfileImage with _$AiProfileImage {
  const factory AiProfileImage({
    required String id,
    @JsonKey(name: 'ai_profiles_id') required String aiProfilesId,
    required String img,
    @JsonKey(name: 'is_default') required bool isDefault,
  }) = _AiProfileImage;

  factory AiProfileImage.fromJson(Map<String, Object?> json) =>
      _$AiProfileImageFromJson(json);
}
