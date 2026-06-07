import 'package:json_annotation/json_annotation.dart';

part 'battle_pass.g.dart';

@JsonSerializable()
class BattlePass {
  final int id;
  @JsonKey(name: 'workout_season_id')
  final int workoutSeasonId;
  final String name;
  final String? description;
  @JsonKey(name: 'vip_unlock_price_money_rub')
  final int? vipUnlockPriceMoneyRub;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final List<BattlePassTier> tiers;
  @JsonKey(name: 'my_progress')
  final BattlePassProgress? myProgress;

  BattlePass({
    required this.id,
    required this.workoutSeasonId,
    required this.name,
    this.description,
    this.vipUnlockPriceMoneyRub,
    required this.isActive,
    required this.tiers,
    this.myProgress,
  });

  factory BattlePass.fromJson(Map<String, dynamic> json) =>
      _$BattlePassFromJson(json);
  Map<String, dynamic> toJson() => _$BattlePassToJson(this);
}

@JsonSerializable()
class BattlePassProgress {
  @JsonKey(name: 'is_vip')
  final bool isVip;
  @JsonKey(name: 'current_tier')
  final int? currentTier;

  BattlePassProgress({required this.isVip, this.currentTier});

  factory BattlePassProgress.fromJson(Map<String, dynamic> json) =>
      _$BattlePassProgressFromJson(json);
  Map<String, dynamic> toJson() => _$BattlePassProgressToJson(this);
}

@JsonSerializable()
class BattlePassTier {
  final int id;
  final int level;
  final BattlePassReward free;
  final BattlePassReward vip;

  BattlePassTier({
    required this.id,
    required this.level,
    required this.free,
    required this.vip,
  });

  factory BattlePassTier.fromJson(Map<String, dynamic> json) =>
      _$BattlePassTierFromJson(json);
  Map<String, dynamic> toJson() => _$BattlePassTierToJson(this);
}

@JsonSerializable()
class BattlePassReward {
  @JsonKey(name: 'reward_type')
  final String? rewardType;
  @JsonKey(name: 'reward_value')
  final int? rewardValue;
  final bool claimed;

  BattlePassReward({this.rewardType, this.rewardValue, required this.claimed});

  factory BattlePassReward.fromJson(Map<String, dynamic> json) =>
      _$BattlePassRewardFromJson(json);
  Map<String, dynamic> toJson() => _$BattlePassRewardToJson(this);
}

@JsonSerializable()
class BattlePassResponse {
  final BattlePass? data;

  BattlePassResponse({this.data});

  factory BattlePassResponse.fromJson(Map<String, dynamic> json) =>
      _$BattlePassResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BattlePassResponseToJson(this);
}
