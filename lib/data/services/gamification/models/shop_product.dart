import 'package:json_annotation/json_annotation.dart';

part 'shop_product.g.dart';

@JsonSerializable()
class ShopProduct {
  final int id;
  final String key;
  final String type;
  final String name;
  final String? description;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'vip_required')
  final bool vipRequired;
  @JsonKey(name: 'duration_days')
  final int? durationDays;
  @JsonKey(name: 'grant_quantity')
  final int? grantQuantity;
  final ProductPricing? pricing;

  ShopProduct({
    required this.id,
    required this.key,
    required this.type,
    required this.name,
    this.description,
    this.imageUrl,
    required this.vipRequired,
    this.durationDays,
    this.grantQuantity,
    this.pricing,
  });

  factory ShopProduct.fromJson(Map<String, dynamic> json) =>
      _$ShopProductFromJson(json);
  Map<String, dynamic> toJson() => _$ShopProductToJson(this);
}

@JsonSerializable()
class ProductPricing {
  @JsonKey(name: 'base_rating')
  final int? baseRating;
  @JsonKey(name: 'discounted_rating')
  final int? discountedRating;
  @JsonKey(name: 'discount_percent')
  final int? discountPercent;
  @JsonKey(name: 'money_rub')
  final int? moneyRub;

  ProductPricing({
    this.baseRating,
    this.discountedRating,
    this.discountPercent,
    this.moneyRub,
  });

  factory ProductPricing.fromJson(Map<String, dynamic> json) =>
      _$ProductPricingFromJson(json);
  Map<String, dynamic> toJson() => _$ProductPricingToJson(this);
}

@JsonSerializable()
class ShopProductsResponse {
  final List<ShopProduct> data;
  @JsonKey(name: 'feature_enabled')
  final bool? featureEnabled;

  ShopProductsResponse({required this.data, this.featureEnabled});

  factory ShopProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ShopProductsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ShopProductsResponseToJson(this);
}

@JsonSerializable()
class PurchaseResponse {
  final Map<String, dynamic>? data;

  PurchaseResponse({this.data});

  factory PurchaseResponse.fromJson(Map<String, dynamic> json) =>
      _$PurchaseResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseResponseToJson(this);
}
