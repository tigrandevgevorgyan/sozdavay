// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileShortResponse _$UserProfileShortResponseFromJson(
        Map<String, dynamic> json) =>
    UserProfileShortResponse(
      json['message'] as String?,
      UserProfile.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileShortResponseToJson(
        UserProfileShortResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

UserProfileExtendedResponse _$UserProfileExtendedResponseFromJson(
        Map<String, dynamic> json) =>
    UserProfileExtendedResponse(
      json['message'] as String?,
      UserProfile.fromJson(json['data'] as Map<String, dynamic>),
      (json['ages'] as List<dynamic>)
          .map(
              (e) => IdNamePairWithPriority.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['experiences'] as List<dynamic>)
          .map(
              (e) => IdNamePairWithPriority.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['goals'] as List<dynamic>)
          .map(
              (e) => IdNamePairWithPriority.fromJson(e as Map<String, dynamic>))
          .toList(),
      const DaysConverter().fromJson(json['days'] as List),
      (json['priorites'] as List<dynamic>)
          .map(
              (e) => IdNamePairWithPriority.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserProfileExtendedResponseToJson(
        UserProfileExtendedResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'ages': instance.ages,
      'experiences': instance.experiences,
      'goals': instance.goals,
      'days': const DaysConverter().toJson(instance.days),
      'priorites': instance.priorities,
    };

IdNamePairWithPriority _$IdNamePairWithPriorityFromJson(
        Map<String, dynamic> json) =>
    IdNamePairWithPriority(
      json['available_priority'] as bool?,
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$IdNamePairWithPriorityToJson(
        IdNamePairWithPriority instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'available_priority': instance.isPriorityAvailable,
    };
