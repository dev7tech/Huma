// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiProfileImpl _$$AiProfileImplFromJson(Map<String, dynamic> json) =>
    _$AiProfileImpl(
      id: json['id'] as String,
      age: json['age'] as int,
      name: json['name'] as String,
      location: json['location'] as String,
      ambitions: json['ambitions'] as String,
      images: (json['ai_profile_images'] as List<dynamic>?)
          ?.map((e) => AiProfileImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AiProfileImplToJson(_$AiProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'age': instance.age,
      'name': instance.name,
      'location': instance.location,
      'ambitions': instance.ambitions,
      'ai_profile_images': instance.images,
    };
