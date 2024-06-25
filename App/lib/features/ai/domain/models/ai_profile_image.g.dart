// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_profile_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiProfileImageImpl _$$AiProfileImageImplFromJson(Map<String, dynamic> json) =>
    _$AiProfileImageImpl(
      id: json['id'] as String,
      aiProfilesId: json['ai_profiles_id'] as String,
      img: json['img'] as String,
      isDefault: json['is_default'] as bool,
    );

Map<String, dynamic> _$$AiProfileImageImplToJson(
        _$AiProfileImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ai_profiles_id': instance.aiProfilesId,
      'img': instance.img,
      'is_default': instance.isDefault,
    };
