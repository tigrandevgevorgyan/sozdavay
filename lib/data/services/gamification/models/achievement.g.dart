// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
      id: (json['id'] as num).toInt(),
      key: json['key'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      creatorPointsReward: (json['creator_points_reward'] as num).toInt(),
      isGranted: json['is_granted'] as bool,
      grantedAt: json['granted_at'] as String?,
      participation: json['participation'] == null
          ? null
          : AchievementParticipation.fromJson(
              json['participation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'creator_points_reward': instance.creatorPointsReward,
      'is_granted': instance.isGranted,
      'granted_at': instance.grantedAt,
      'participation': instance.participation,
    };

AchievementParticipation _$AchievementParticipationFromJson(
        Map<String, dynamic> json) =>
    AchievementParticipation(
      status: json['status'] as String,
      participationYear: (json['participation_year'] as num).toInt(),
      joinedAt: json['joined_at'] as String?,
    );

Map<String, dynamic> _$AchievementParticipationToJson(
        AchievementParticipation instance) =>
    <String, dynamic>{
      'status': instance.status,
      'participation_year': instance.participationYear,
      'joined_at': instance.joinedAt,
    };

AchievementsListResponse _$AchievementsListResponseFromJson(
        Map<String, dynamic> json) =>
    AchievementsListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
      featureEnabled: json['feature_enabled'] as bool?,
    );

Map<String, dynamic> _$AchievementsListResponseToJson(
        AchievementsListResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'feature_enabled': instance.featureEnabled,
    };

MyAchievementsResponse _$MyAchievementsResponseFromJson(
        Map<String, dynamic> json) =>
    MyAchievementsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => CustomerAchievement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyAchievementsResponseToJson(
        MyAchievementsResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

CustomerAchievement _$CustomerAchievementFromJson(Map<String, dynamic> json) =>
    CustomerAchievement(
      id: (json['id'] as num).toInt(),
      achievementId: (json['achievement_id'] as num).toInt(),
      grantedAt: json['granted_at'] as String?,
      achievement: json['achievement'] == null
          ? null
          : Achievement.fromJson(json['achievement'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomerAchievementToJson(
        CustomerAchievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'achievement_id': instance.achievementId,
      'granted_at': instance.grantedAt,
      'achievement': instance.achievement,
    };
