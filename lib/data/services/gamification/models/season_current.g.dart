// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_current.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonCurrent _$SeasonCurrentFromJson(Map<String, dynamic> json) =>
    SeasonCurrent(
      id: (json['id'] as num).toInt(),
      dateStart: json['date_start'] as String?,
      dateEnd: json['date_end'] as String?,
      labelRu: json['label_ru'] as String?,
      rewards: (json['rewards'] as List<dynamic>)
          .map((e) => SeasonReward.fromJson(e as Map<String, dynamic>))
          .toList(),
      myProgress: json['my_progress'] == null
          ? null
          : MySeasonProgress.fromJson(
              json['my_progress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SeasonCurrentToJson(SeasonCurrent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_start': instance.dateStart,
      'date_end': instance.dateEnd,
      'label_ru': instance.labelRu,
      'rewards': instance.rewards,
      'my_progress': instance.myProgress,
    };

SeasonReward _$SeasonRewardFromJson(Map<String, dynamic> json) => SeasonReward(
      id: (json['id'] as num).toInt(),
      scope: json['scope'] as String,
      rankFrom: (json['rank_from'] as num?)?.toInt(),
      rankTo: (json['rank_to'] as num?)?.toInt(),
      rewardType: json['reward_type'] as String?,
      rewardValue: (json['reward_value'] as num?)?.toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SeasonRewardToJson(SeasonReward instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scope': instance.scope,
      'rank_from': instance.rankFrom,
      'rank_to': instance.rankTo,
      'reward_type': instance.rewardType,
      'reward_value': instance.rewardValue,
      'description': instance.description,
    };

MySeasonProgress _$MySeasonProgressFromJson(Map<String, dynamic> json) =>
    MySeasonProgress(
      ratingBalance: (json['rating_balance'] as num?)?.toInt(),
      currentLevel: (json['current_level'] as num?)?.toInt(),
      drawMinLevel: (json['draw_min_level'] as num?)?.toInt(),
      drawThresholdPoints: (json['draw_threshold_points'] as num?)?.toInt(),
      qualifiedForDraw: json['qualified_for_draw'] as bool?,
    );

Map<String, dynamic> _$MySeasonProgressToJson(MySeasonProgress instance) =>
    <String, dynamic>{
      'rating_balance': instance.ratingBalance,
      'current_level': instance.currentLevel,
      'draw_min_level': instance.drawMinLevel,
      'draw_threshold_points': instance.drawThresholdPoints,
      'qualified_for_draw': instance.qualifiedForDraw,
    };

SeasonCurrentResponse _$SeasonCurrentResponseFromJson(
        Map<String, dynamic> json) =>
    SeasonCurrentResponse(
      data: json['data'] == null
          ? null
          : SeasonCurrent.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SeasonCurrentResponseToJson(
        SeasonCurrentResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
