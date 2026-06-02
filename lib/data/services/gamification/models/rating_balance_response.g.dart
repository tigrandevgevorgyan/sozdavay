// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_balance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingBalanceResponse _$RatingBalanceResponseFromJson(
        Map<String, dynamic> json) =>
    RatingBalanceResponse(
      data: RatingBalanceData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RatingBalanceResponseToJson(
        RatingBalanceResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

RatingBalanceData _$RatingBalanceDataFromJson(Map<String, dynamic> json) =>
    RatingBalanceData(
      season: json['season'] == null
          ? null
          : SeasonRef.fromJson(json['season'] as Map<String, dynamic>),
      balance: (json['balance'] as num).toInt(),
      earnedInSeason: (json['earned_in_season'] as num).toInt(),
      spentInSeason: (json['spent_in_season'] as num).toInt(),
      level: RatingLevelSummary.fromJson(json['level'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RatingBalanceDataToJson(RatingBalanceData instance) =>
    <String, dynamic>{
      'season': instance.season,
      'balance': instance.balance,
      'earned_in_season': instance.earnedInSeason,
      'spent_in_season': instance.spentInSeason,
      'level': instance.level,
    };

SeasonRef _$SeasonRefFromJson(Map<String, dynamic> json) => SeasonRef(
      id: (json['id'] as num).toInt(),
      dateStart: json['date_start'] as String?,
      dateEnd: json['date_end'] as String?,
    );

Map<String, dynamic> _$SeasonRefToJson(SeasonRef instance) => <String, dynamic>{
      'id': instance.id,
      'date_start': instance.dateStart,
      'date_end': instance.dateEnd,
    };
