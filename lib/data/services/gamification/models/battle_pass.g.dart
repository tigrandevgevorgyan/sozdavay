// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattlePass _$BattlePassFromJson(Map<String, dynamic> json) => BattlePass(
      id: (json['id'] as num).toInt(),
      workoutSeasonId: (json['workout_season_id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      vipUnlockPriceMoneyRub:
          (json['vip_unlock_price_money_rub'] as num?)?.toInt(),
      isActive: json['is_active'] as bool,
      tiers: (json['tiers'] as List<dynamic>)
          .map((e) => BattlePassTier.fromJson(e as Map<String, dynamic>))
          .toList(),
      myProgress: json['my_progress'] == null
          ? null
          : BattlePassProgress.fromJson(
              json['my_progress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BattlePassToJson(BattlePass instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workout_season_id': instance.workoutSeasonId,
      'name': instance.name,
      'description': instance.description,
      'vip_unlock_price_money_rub': instance.vipUnlockPriceMoneyRub,
      'is_active': instance.isActive,
      'tiers': instance.tiers,
      'my_progress': instance.myProgress,
    };

BattlePassProgress _$BattlePassProgressFromJson(Map<String, dynamic> json) =>
    BattlePassProgress(
      isVip: json['is_vip'] as bool,
      currentTier: (json['current_tier'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BattlePassProgressToJson(BattlePassProgress instance) =>
    <String, dynamic>{
      'is_vip': instance.isVip,
      'current_tier': instance.currentTier,
    };

BattlePassTier _$BattlePassTierFromJson(Map<String, dynamic> json) =>
    BattlePassTier(
      id: (json['id'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      free: BattlePassReward.fromJson(json['free'] as Map<String, dynamic>),
      vip: BattlePassReward.fromJson(json['vip'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BattlePassTierToJson(BattlePassTier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'free': instance.free,
      'vip': instance.vip,
    };

BattlePassReward _$BattlePassRewardFromJson(Map<String, dynamic> json) =>
    BattlePassReward(
      rewardType: json['reward_type'] as String?,
      rewardValue: (json['reward_value'] as num?)?.toInt(),
      claimed: json['claimed'] as bool,
    );

Map<String, dynamic> _$BattlePassRewardToJson(BattlePassReward instance) =>
    <String, dynamic>{
      'reward_type': instance.rewardType,
      'reward_value': instance.rewardValue,
      'claimed': instance.claimed,
    };

BattlePassResponse _$BattlePassResponseFromJson(Map<String, dynamic> json) =>
    BattlePassResponse(
      data: json['data'] == null
          ? null
          : BattlePass.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BattlePassResponseToJson(BattlePassResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
