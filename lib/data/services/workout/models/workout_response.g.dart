// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutResponse _$WorkoutResponseFromJson(Map<String, dynamic> json) =>
    WorkoutResponse(
      json['message'] as String?,
      (json['data'] as List<dynamic>)
          .map((e) => WorkoutInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutResponseToJson(WorkoutResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

WorkoutInfo _$WorkoutInfoFromJson(Map<String, dynamic> json) => WorkoutInfo(
      (json['index'] as num).toInt(),
      json['is_double'] as bool,
      json['is_complex'] as bool,
      (json['items'] as List<dynamic>)
          .map((e) => ExerciseInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutInfoToJson(WorkoutInfo instance) =>
    <String, dynamic>{
      'index': instance.index,
      'is_double': instance.isDouble,
      'is_complex': instance.isComplex,
      'items': instance.items,
    };

ExerciseInfo _$ExerciseInfoFromJson(Map<String, dynamic> json) => ExerciseInfo(
      (json['id'] as num).toInt(),
      json['name'] as String,
      (json['history'] as List<dynamic>)
          .map((e) => HistoryInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['min_repeats'] as num).toInt(),
      (json['max_repeats'] as num).toInt(),
      (json['min_sets'] as num).toInt(),
      (json['max_sets'] as num).toInt(),
      (json['min_rest'] as num).toInt(),
      (json['max_rest'] as num).toInt(),
      json['last_sets_full'] as bool,
    );

Map<String, dynamic> _$ExerciseInfoToJson(ExerciseInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'min_repeats': instance.minRepeats,
      'max_repeats': instance.maxRepeats,
      'min_sets': instance.minSets,
      'max_sets': instance.maxSets,
      'min_rest': instance.minRest,
      'max_rest': instance.maxRest,
      'last_sets_full': instance.lastSetsFull,
      'history': instance.history,
    };

HistoryInfo _$HistoryInfoFromJson(Map<String, dynamic> json) => HistoryInfo(
      json['day'] as String,
      json['date'] as String,
      (json['values'] as List<dynamic>)
          .map((e) => ResultValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HistoryInfoToJson(HistoryInfo instance) =>
    <String, dynamic>{
      'day': instance.day,
      'date': instance.date,
      'values': instance.values,
    };

ResultValue _$ResultValueFromJson(Map<String, dynamic> json) => ResultValue(
      json['weight'] as String,
      (json['repeats'] as num).toInt(),
      (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$ResultValueToJson(ResultValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weight': instance.weight,
      'repeats': instance.repeats,
    };
