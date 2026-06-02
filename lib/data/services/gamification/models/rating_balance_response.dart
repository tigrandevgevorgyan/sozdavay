import 'package:json_annotation/json_annotation.dart';

import 'rating_level_summary.dart';

part 'rating_balance_response.g.dart';

@JsonSerializable()
class RatingBalanceResponse {
  final RatingBalanceData data;

  RatingBalanceResponse({required this.data});

  factory RatingBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$RatingBalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RatingBalanceResponseToJson(this);
}

@JsonSerializable()
class RatingBalanceData {
  final SeasonRef? season;
  final int balance;
  @JsonKey(name: 'earned_in_season')
  final int earnedInSeason;
  @JsonKey(name: 'spent_in_season')
  final int spentInSeason;
  final RatingLevelSummary level;

  RatingBalanceData({
    required this.season,
    required this.balance,
    required this.earnedInSeason,
    required this.spentInSeason,
    required this.level,
  });

  factory RatingBalanceData.fromJson(Map<String, dynamic> json) =>
      _$RatingBalanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$RatingBalanceDataToJson(this);
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
