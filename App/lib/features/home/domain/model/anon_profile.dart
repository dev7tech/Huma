import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'anon_profile.freezed.dart';
part 'anon_profile.g.dart';

@freezed
class AnonProfile with _$AnonProfile {
  const factory AnonProfile({
    required String id,
    required String name,
  }) = _AnonProfile;

  factory AnonProfile.fromJson(Map<String, Object?> json) => _$AnonProfileFromJson(json);
}
