// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      json['records'] as String?,
      json['measurements'] as String?,
      json['paid_until'] as String?,
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      category: json['category'] == null
          ? null
          : IdNamePairWithPriority.fromJson(
              json['category'] as Map<String, dynamic>),
      days: (json['days'] as num?)?.toInt(),
      age: json['age'] == null
          ? null
          : IdNamePairWithPriority.fromJson(
              json['age'] as Map<String, dynamic>),
      experience: json['experience'] == null
          ? null
          : IdNamePairWithPriority.fromJson(
              json['experience'] as Map<String, dynamic>),
      goal: json['goal'] == null
          ? null
          : IdNamePairWithPriority.fromJson(
              json['goal'] as Map<String, dynamic>),
      priority: json['priority'] == null
          ? null
          : IdNamePairWithPriority.fromJson(
              json['priority'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'days': instance.days,
      'category': instance.category,
      'age': instance.age,
      'experience': instance.experience,
      'goal': instance.goal,
      'priority': instance.priority,
      'records': instance.records,
      'measurements': instance.measurements,
      'paid_until': instance.paidUntil,
    };
