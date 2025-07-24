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
      (json['workout_id'] as num?)?.toInt(),
      (json['day'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WorkoutResponseToJson(WorkoutResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'workout_id': instance.workoutId,
      'day': instance.day,
      'data': instance.data,
    };

WorkoutInfo _$WorkoutInfoFromJson(Map<String, dynamic> json) => WorkoutInfo(
      (json['index'] as num).toInt(),
      json['is_double'] as bool,
      json['is_complex'] as bool,
      json['is_time'] as bool,
      (json['items'] as List<dynamic>)
          .map((e) => ExerciseInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['superset_repeats_from'] as num?)?.toInt(),
      (json['superset_repeats_to'] as num?)?.toInt(),
      json['superset_as_much_as_possible'] as bool?,
    );

Map<String, dynamic> _$WorkoutInfoToJson(WorkoutInfo instance) =>
    <String, dynamic>{
      'index': instance.index,
      'is_double': instance.isDouble,
      'is_complex': instance.isComplex,
      'is_time': instance.isTime,
      'superset_repeats_from': instance.supersetRepeatsFrom,
      'superset_repeats_to': instance.supersetRepeatsTo,
      'superset_as_much_as_possible': instance.supersetAsMuchAsPossible,
      'items': instance.items,
    };

ExerciseInfo _$ExerciseInfoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    disallowNullValues: const ['videos', 'sets'],
  );
  return ExerciseInfo(
    (json['item_id'] as num).toInt(),
    (json['id'] as num).toInt(),
    json['name'] as String,
    (json['exercise_count'] as num).toInt(),
    json['description'] as String?,
    (json['videos'] as List<dynamic>?)
            ?.map((e) => VideoInfo.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    (json['sets'] as List<dynamic>?)
            ?.map((e) => SetInfo.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    (json['rest_seconds'] as num?)?.toInt(),
    (json['history'] as List<dynamic>)
        .map((e) => HistoryInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ExerciseInfoToJson(ExerciseInfo instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'id': instance.id,
      'name': instance.name,
      'exercise_count': instance.exerciseCount,
      'description': instance.description,
      'videos': instance.videos,
      'sets': instance.sets,
      'rest_seconds': instance.restSeconds,
      'history': instance.history,
    };

SetInfo _$SetInfoFromJson(Map<String, dynamic> json) => SetInfo(
      (json['sets_count'] as num?)?.toInt(),
      (json['repeats_from'] as num?)?.toInt(),
      (json['repeats_to'] as num?)?.toInt(),
      (json['as_much_as_possible'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SetInfoToJson(SetInfo instance) => <String, dynamic>{
      'sets_count': instance.setsCount,
      'repeats_from': instance.repeatsFrom,
      'repeats_to': instance.repeatsTo,
      'as_much_as_possible': instance.asMuchAsPossible,
    };

VideoInfo _$VideoInfoFromJson(Map<String, dynamic> json) => VideoInfo(
      json['url'] as String,
      json['type'] as String,
      json['title'] as String?,
    );

Map<String, dynamic> _$VideoInfoToJson(VideoInfo instance) => <String, dynamic>{
      'url': instance.url,
      'type': instance.type,
      'title': instance.title,
    };

HistoryInfo _$HistoryInfoFromJson(Map<String, dynamic> json) => HistoryInfo(
      json['day'] as String,
      json['date'] as String,
      (json['values'] as List<dynamic>)
          .map((e) => ResultValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['comment'] as String?,
      (json['item_id'] as num).toInt(),
    );

Map<String, dynamic> _$HistoryInfoToJson(HistoryInfo instance) =>
    <String, dynamic>{
      'day': instance.day,
      'date': instance.date,
      'comment': instance.comment,
      'item_id': instance.itemId,
      'values': instance.values,
    };

ResultValue _$ResultValueFromJson(Map<String, dynamic> json) => ResultValue(
      (json['id'] as num).toInt(),
      (json['weight'] as num).toDouble(),
      (json['repeats'] as num).toInt(),
      (json['difficult'] as num).toInt(),
      (json['time'] as num).toInt(),
      json['date'] as String,
    );

Map<String, dynamic> _$ResultValueToJson(ResultValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weight': instance.weight,
      'repeats': instance.repeats,
      'difficult': instance.difficult,
      'time': instance.time,
      'date': instance.date,
    };
