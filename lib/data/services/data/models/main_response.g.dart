// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainResponse _$MainResponseFromJson(Map<String, dynamic> json) => MainResponse(
      json['message'] as String?,
      MainInfo.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MainResponseToJson(MainResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

MainInfo _$MainInfoFromJson(Map<String, dynamic> json) => MainInfo(
      WorkoutStats.fromJson(json['workout'] as Map<String, dynamic>),
      (json['schedule'] as List<dynamic>)
          .map((e) => DayInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['rating'] as num).toInt(),
      json['label'] as String,
      (json['level_rating'] as num).toInt(),
    );

Map<String, dynamic> _$MainInfoToJson(MainInfo instance) => <String, dynamic>{
      'workout': instance.workout,
      'schedule': instance.schedule,
      'rating': instance.rating,
      'level_rating': instance.levelRating,
      'label': instance.label,
    };

DayInfo _$DayInfoFromJson(Map<String, dynamic> json) => DayInfo(
      json['day'] as String,
      json['name'] as String?,
      json['active'] as bool,
    );

Map<String, dynamic> _$DayInfoToJson(DayInfo instance) => <String, dynamic>{
      'day': instance.day,
      'name': instance.name,
      'active': instance.isActive,
    };

WorkoutStats _$WorkoutStatsFromJson(Map<String, dynamic> json) => WorkoutStats(
      (json['month'] as num?)?.toInt(),
      (json['year'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WorkoutStatsToJson(WorkoutStats instance) =>
    <String, dynamic>{
      'month': instance.month,
      'year': instance.year,
    };
