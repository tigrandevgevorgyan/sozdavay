// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopProduct _$ShopProductFromJson(Map<String, dynamic> json) => ShopProduct(
      id: (json['id'] as num).toInt(),
      key: json['key'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      vipRequired: json['vip_required'] as bool,
      durationDays: (json['duration_days'] as num?)?.toInt(),
      grantQuantity: (json['grant_quantity'] as num?)?.toInt(),
      pricing: json['pricing'] == null
          ? null
          : ProductPricing.fromJson(json['pricing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopProductToJson(ShopProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'vip_required': instance.vipRequired,
      'duration_days': instance.durationDays,
      'grant_quantity': instance.grantQuantity,
      'pricing': instance.pricing,
    };

ProductPricing _$ProductPricingFromJson(Map<String, dynamic> json) =>
    ProductPricing(
      baseRating: (json['base_rating'] as num?)?.toInt(),
      discountedRating: (json['discounted_rating'] as num?)?.toInt(),
      discountPercent: (json['discount_percent'] as num?)?.toInt(),
      moneyRub: (json['money_rub'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductPricingToJson(ProductPricing instance) =>
    <String, dynamic>{
      'base_rating': instance.baseRating,
      'discounted_rating': instance.discountedRating,
      'discount_percent': instance.discountPercent,
      'money_rub': instance.moneyRub,
    };

ShopProductsResponse _$ShopProductsResponseFromJson(
        Map<String, dynamic> json) =>
    ShopProductsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ShopProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      featureEnabled: json['feature_enabled'] as bool?,
    );

Map<String, dynamic> _$ShopProductsResponseToJson(
        ShopProductsResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'feature_enabled': instance.featureEnabled,
    };

PurchaseResponse _$PurchaseResponseFromJson(Map<String, dynamic> json) =>
    PurchaseResponse(
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PurchaseResponseToJson(PurchaseResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
