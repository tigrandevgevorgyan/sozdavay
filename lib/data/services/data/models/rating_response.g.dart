// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingResponse _$RatingResponseFromJson(Map<String, dynamic> json) =>
    RatingResponse(
      json['message'] as String?,
      UserProfile.fromJson(json['data'] as Map<String, dynamic>),
      (json['rating'] as List<dynamic>)
          .map((e) => UserRating.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['categories'] as List<dynamic>)
          .map(
              (e) => IdNamePairWithPriority.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['periods'] as List<dynamic>)
          .map((e) =>
              IdLabelPairWithPriority.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RatingResponseToJson(RatingResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'rating': instance.rating,
      'categories': instance.categories,
      'periods': instance.periods,
    };

UserRating _$UserRatingFromJson(Map<String, dynamic> json) => UserRating(
      (json['customer_id'] as num).toInt(),
      json['name'] as String,
      (json['total_rating'] as num).toInt(),
      json['label'] as String,
    );

Map<String, dynamic> _$UserRatingToJson(UserRating instance) =>
    <String, dynamic>{
      'customer_id': instance.userId,
      'name': instance.name,
      'total_rating': instance.totalRating,
      'label': instance.label,
    };

IdLabelPairWithPriority _$IdLabelPairWithPriorityFromJson(
        Map<String, dynamic> json) =>
    IdLabelPairWithPriority(
      (json['id'] as num).toInt(),
      json['label'] as String,
    );

Map<String, dynamic> _$IdLabelPairWithPriorityToJson(
        IdLabelPairWithPriority instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
    };
