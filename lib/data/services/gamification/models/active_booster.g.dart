// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_booster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveBooster _$ActiveBoosterFromJson(Map<String, dynamic> json) =>
    ActiveBooster(
      id: (json['id'] as num).toInt(),
      shopProductId: (json['shop_product_id'] as num).toInt(),
      key: json['key'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      expiresAt: json['expires_at'] as String?,
    );

Map<String, dynamic> _$ActiveBoosterToJson(ActiveBooster instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_product_id': instance.shopProductId,
      'key': instance.key,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'quantity': instance.quantity,
      'expires_at': instance.expiresAt,
    };

ActiveBoostersResponse _$ActiveBoostersResponseFromJson(
        Map<String, dynamic> json) =>
    ActiveBoostersResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ActiveBooster.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActiveBoostersResponseToJson(
        ActiveBoostersResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
