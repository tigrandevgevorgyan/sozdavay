// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_sets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutSets _$WorkoutSetsFromJson(Map<String, dynamic> json) => WorkoutSets(
      id: (json['id'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
      exerciseId: (json['exerciseId'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toInt(),
      repeats: (json['repeats'] as num?)?.toInt(),
      difficult: (json['difficult'] as num?)?.toInt(),
      time: (json['time'] as num?)?.toInt(),
      action: $enumDecode(_$OfflineActionEnumMap, json['action']),
    );

Map<String, dynamic> _$WorkoutSetsToJson(WorkoutSets instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'exerciseId': instance.exerciseId,
      'weight': instance.weight,
      'repeats': instance.repeats,
      'difficult': instance.difficult,
      'time': instance.time,
      'action': _$OfflineActionEnumMap[instance.action]!,
    };

const _$OfflineActionEnumMap = {
  OfflineAction.add: 'add',
  OfflineAction.update: 'update',
  OfflineAction.delete: 'delete',
};
