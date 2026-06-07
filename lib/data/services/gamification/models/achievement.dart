import 'package:json_annotation/json_annotation.dart';

part 'achievement.g.dart';

/// Mirrors `AchievementResource` on the backend.
@JsonSerializable()
class Achievement {
  final int id;
  final String key;
  final String type;
  final String name;
  final String? description;
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @JsonKey(name: 'creator_points_reward')
  final int creatorPointsReward;
  @JsonKey(name: 'is_granted')
  final bool isGranted;
  @JsonKey(name: 'granted_at')
  final String? grantedAt;
  final AchievementParticipation? participation;

  Achievement({
    required this.id,
    required this.key,
    required this.type,
    required this.name,
    this.description,
    this.iconUrl,
    required this.creatorPointsReward,
    required this.isGranted,
    this.grantedAt,
    this.participation,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementToJson(this);
}

@JsonSerializable()
class AchievementParticipation {
  final String status;
  @JsonKey(name: 'participation_year')
  final int participationYear;
  @JsonKey(name: 'joined_at')
  final String? joinedAt;

  AchievementParticipation({
    required this.status,
    required this.participationYear,
    this.joinedAt,
  });

  factory AchievementParticipation.fromJson(Map<String, dynamic> json) =>
      _$AchievementParticipationFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementParticipationToJson(this);
}

@JsonSerializable()
class AchievementsListResponse {
  final List<Achievement> data;
  @JsonKey(name: 'feature_enabled')
  final bool? featureEnabled;

  AchievementsListResponse({required this.data, this.featureEnabled});

  factory AchievementsListResponse.fromJson(Map<String, dynamic> json) =>
      _$AchievementsListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementsListResponseToJson(this);
}

@JsonSerializable()
class MyAchievementsResponse {
  final List<CustomerAchievement> data;

  MyAchievementsResponse({required this.data});

  factory MyAchievementsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyAchievementsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyAchievementsResponseToJson(this);
}

@JsonSerializable()
class CustomerAchievement {
  final int id;
  @JsonKey(name: 'achievement_id')
  final int achievementId;
  @JsonKey(name: 'granted_at')
  final String? grantedAt;
  final Achievement? achievement;

  CustomerAchievement({
    required this.id,
    required this.achievementId,
    this.grantedAt,
    this.achievement,
  });

  factory CustomerAchievement.fromJson(Map<String, dynamic> json) =>
      _$CustomerAchievementFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerAchievementToJson(this);
}
