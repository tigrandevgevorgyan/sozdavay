import 'package:json_annotation/json_annotation.dart';

part 'avatar_frame.g.dart';

@JsonSerializable()
class AvatarFrameDefinition {
  final int id;
  final String key;
  final String rarity;
  @JsonKey(name: 'rating_boost_percent')
  final int ratingBoostPercent;
  final String name;
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  AvatarFrameDefinition({
    required this.id,
    required this.key,
    required this.rarity,
    required this.ratingBoostPercent,
    required this.name,
    this.imageUrl,
  });

  factory AvatarFrameDefinition.fromJson(Map<String, dynamic> json) =>
      _$AvatarFrameDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$AvatarFrameDefinitionToJson(this);
}

@JsonSerializable()
class CustomerAvatarFrame {
  final int id;
  @JsonKey(name: 'avatar_frame_definition_id')
  final int avatarFrameDefinitionId;
  @JsonKey(name: 'acquired_at')
  final String? acquiredAt;
  final String? source;
  final AvatarFrameDefinition? definition;
  @JsonKey(name: 'is_equipped')
  final bool isEquipped;

  CustomerAvatarFrame({
    required this.id,
    required this.avatarFrameDefinitionId,
    this.acquiredAt,
    this.source,
    this.definition,
    required this.isEquipped,
  });

  factory CustomerAvatarFrame.fromJson(Map<String, dynamic> json) =>
      _$CustomerAvatarFrameFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerAvatarFrameToJson(this);
}

@JsonSerializable()
class MyFramesResponse {
  final List<CustomerAvatarFrame> data;

  MyFramesResponse({required this.data});

  factory MyFramesResponse.fromJson(Map<String, dynamic> json) =>
      _$MyFramesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyFramesResponseToJson(this);
}
