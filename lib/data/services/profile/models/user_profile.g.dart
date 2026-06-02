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
      sex: (json['sex'] as num?)?.toInt(),
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
      planType: (json['plan_type'] as num).toInt(),
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      equippedAvatarFrameId:
          (json['equipped_avatar_frame_id'] as num?)?.toInt(),
      creatorPoints: (json['creator_points'] as num?)?.toInt(),
      accountLevel: (json['account_level'] as num?)?.toInt(),
      shopDiscountPercent: (json['shop_discount_percent'] as num?)?.toInt(),
      ratingBalance: (json['rating_balance'] as num?)?.toInt(),
      ratingLevel: json['rating_level'] == null
          ? null
          : RatingLevelSummary.fromJson(
              json['rating_level'] as Map<String, dynamic>),
      referralCode: json['referral_code'] as String?,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sex': instance.sex,
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
      'plan_type': instance.planType,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'equipped_avatar_frame_id': instance.equippedAvatarFrameId,
      'creator_points': instance.creatorPoints,
      'account_level': instance.accountLevel,
      'shop_discount_percent': instance.shopDiscountPercent,
      'rating_balance': instance.ratingBalance,
      'rating_level': instance.ratingLevel,
      'referral_code': instance.referralCode,
    };
