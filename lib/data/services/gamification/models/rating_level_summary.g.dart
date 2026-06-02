// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_level_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingLevelSummary _$RatingLevelSummaryFromJson(Map<String, dynamic> json) =>
    RatingLevelSummary(
      points: (json['points'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      label: json['label'] as String,
      pointsInLevel: (json['points_in_level'] as num).toInt(),
      pointsToNextLevel: (json['points_to_next_level'] as num).toInt(),
      nextLevel: (json['next_level'] as num).toInt(),
      nextLevelLabel: json['next_level_label'] as String,
      isMaxLevel: json['is_max_level'] as bool,
      formula: json['formula'] as String,
    );

Map<String, dynamic> _$RatingLevelSummaryToJson(RatingLevelSummary instance) =>
    <String, dynamic>{
      'points': instance.points,
      'level': instance.level,
      'label': instance.label,
      'points_in_level': instance.pointsInLevel,
      'points_to_next_level': instance.pointsToNextLevel,
      'next_level': instance.nextLevel,
      'next_level_label': instance.nextLevelLabel,
      'is_max_level': instance.isMaxLevel,
      'formula': instance.formula,
    };
