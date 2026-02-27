// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_options_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterOptionsResponse _$RegisterOptionsResponseFromJson(
        Map<String, dynamic> json) =>
    RegisterOptionsResponse(
      json['message'] as String?,
      (json['training_places'] as List<dynamic>)
          .map((e) => TrainingPlaceOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['training_goals'] as List<dynamic>)
          .map((e) => TrainingGoalOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['training_per_week'] as List<dynamic>)
          .map((e) => TrainingPerWeekOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['genders'] as List<dynamic>)
          .map((e) => GenderOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RegisterOptionsResponseToJson(
        RegisterOptionsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'training_places': instance.training_places,
      'training_goals': instance.training_goals,
      'training_per_week': instance.training_per_week,
      'genders': instance.genders,
    };

TrainingPlaceOption _$TrainingPlaceOptionFromJson(Map<String, dynamic> json) =>
    TrainingPlaceOption(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$TrainingPlaceOptionToJson(
        TrainingPlaceOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

TrainingGoalOption _$TrainingGoalOptionFromJson(Map<String, dynamic> json) =>
    TrainingGoalOption(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$TrainingGoalOptionToJson(TrainingGoalOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

TrainingPerWeekOption _$TrainingPerWeekOptionFromJson(
        Map<String, dynamic> json) =>
    TrainingPerWeekOption(
      json['title'] as String,
      json['value'],
    );

Map<String, dynamic> _$TrainingPerWeekOptionToJson(
        TrainingPerWeekOption instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
    };

GenderOption _$GenderOptionFromJson(Map<String, dynamic> json) => GenderOption(
      json['label'] as String,
      (json['value'] as num).toInt(),
    );

Map<String, dynamic> _$GenderOptionToJson(GenderOption instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
    };
