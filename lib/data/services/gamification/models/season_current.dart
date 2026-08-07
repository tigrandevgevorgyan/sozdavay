import 'package:json_annotation/json_annotation.dart';

part 'season_current.g.dart';

@JsonSerializable(explicitToJson: true)
class SeasonCurrent {
  final SeasonRef season;
  @JsonKey(name: 'label_ru')
  final String? labelRu;
  final List<SeasonReward> rewards;
  @JsonKey(name: 'my_progress')
  final MySeasonProgress? myProgress;

  SeasonCurrent({
    required this.season,
    this.labelRu,
    required this.rewards,
    this.myProgress,
  });

  int get id => season.id;
  String? get dateStart => season.dateStart;
  String? get dateEnd => season.dateEnd;

  factory SeasonCurrent.fromJson(Map<String, dynamic> json) =>
      _$SeasonCurrentFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonCurrentToJson(this);
}

@JsonSerializable()
class SeasonRef {
  final int id;
  @JsonKey(name: 'date_start')
  final String? dateStart;
  @JsonKey(name: 'date_end')
  final String? dateEnd;

  SeasonRef({required this.id, this.dateStart, this.dateEnd});

  factory SeasonRef.fromJson(Map<String, dynamic> json) =>
      _$SeasonRefFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonRefToJson(this);
}

@JsonSerializable()
class SeasonReward {
  final int id;
  final String scope;
  @JsonKey(name: 'rank_from')
  final int? rankFrom;
  @JsonKey(name: 'rank_to')
  final int? rankTo;
  @JsonKey(name: 'reward_type')
  final String? rewardType;
  @JsonKey(name: 'reward_value')
  final int? rewardValue;
  final String? description;

  SeasonReward({
    required this.id,
    required this.scope,
    this.rankFrom,
    this.rankTo,
    this.rewardType,
    this.rewardValue,
    this.description,
  });

  factory SeasonReward.fromJson(Map<String, dynamic> json) =>
      _$SeasonRewardFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonRewardToJson(this);
}

@JsonSerializable()
class MySeasonProgress {
  @JsonKey(name: 'rating_balance')
  final int? ratingBalance;
  @JsonKey(name: 'level')
  final int? currentLevel;
  @JsonKey(name: 'draw_min_level')
  final int? drawMinLevel;
  @JsonKey(name: 'draw_threshold_points')
  final int? drawThresholdPoints;
  @JsonKey(name: 'qualified_for_draw')
  final bool? qualifiedForDraw;

  MySeasonProgress({
    this.ratingBalance,
    this.currentLevel,
    this.drawMinLevel,
    this.drawThresholdPoints,
    this.qualifiedForDraw,
  });

  factory MySeasonProgress.fromJson(Map<String, dynamic> json) =>
      _$MySeasonProgressFromJson(json);
  Map<String, dynamic> toJson() => _$MySeasonProgressToJson(this);
}

@JsonSerializable()
class SeasonCurrentResponse {
  final SeasonCurrent? data;

  SeasonCurrentResponse({this.data});

  factory SeasonCurrentResponse.fromJson(Map<String, dynamic> json) =>
      _$SeasonCurrentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonCurrentResponseToJson(this);
}
