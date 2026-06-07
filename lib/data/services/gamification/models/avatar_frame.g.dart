// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarFrameDefinition _$AvatarFrameDefinitionFromJson(
        Map<String, dynamic> json) =>
    AvatarFrameDefinition(
      id: (json['id'] as num).toInt(),
      key: json['key'] as String,
      rarity: json['rarity'] as String,
      ratingBoostPercent: (json['rating_boost_percent'] as num).toInt(),
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$AvatarFrameDefinitionToJson(
        AvatarFrameDefinition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'rarity': instance.rarity,
      'rating_boost_percent': instance.ratingBoostPercent,
      'name': instance.name,
      'image_url': instance.imageUrl,
    };

CustomerAvatarFrame _$CustomerAvatarFrameFromJson(Map<String, dynamic> json) =>
    CustomerAvatarFrame(
      id: (json['id'] as num).toInt(),
      avatarFrameDefinitionId:
          (json['avatar_frame_definition_id'] as num).toInt(),
      acquiredAt: json['acquired_at'] as String?,
      source: json['source'] as String?,
      definition: json['definition'] == null
          ? null
          : AvatarFrameDefinition.fromJson(
              json['definition'] as Map<String, dynamic>),
      isEquipped: json['is_equipped'] as bool,
    );

Map<String, dynamic> _$CustomerAvatarFrameToJson(
        CustomerAvatarFrame instance) =>
    <String, dynamic>{
      'id': instance.id,
      'avatar_frame_definition_id': instance.avatarFrameDefinitionId,
      'acquired_at': instance.acquiredAt,
      'source': instance.source,
      'definition': instance.definition,
      'is_equipped': instance.isEquipped,
    };

MyFramesResponse _$MyFramesResponseFromJson(Map<String, dynamic> json) =>
    MyFramesResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => CustomerAvatarFrame.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyFramesResponseToJson(MyFramesResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
