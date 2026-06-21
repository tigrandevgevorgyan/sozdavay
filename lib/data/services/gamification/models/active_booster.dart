import 'package:json_annotation/json_annotation.dart';

part 'active_booster.g.dart';

/// One active personal booster the customer owns — returned by
/// `GET /shop/my-boosters`. Renders as a card in the Profile "Мои Бустеры"
/// preview (Figma 32:638). Permanent items have `expiresAt == null`.
@JsonSerializable()
class ActiveBooster {
  final int id;
  @JsonKey(name: 'shop_product_id')
  final int shopProductId;
  final String key;
  final String name;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final int quantity;
  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  ActiveBooster({
    required this.id,
    required this.shopProductId,
    required this.key,
    required this.name,
    this.imageUrl,
    required this.quantity,
    this.expiresAt,
  });

  factory ActiveBooster.fromJson(Map<String, dynamic> json) =>
      _$ActiveBoosterFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveBoosterToJson(this);
}

@JsonSerializable()
class ActiveBoostersResponse {
  final List<ActiveBooster> data;

  ActiveBoostersResponse({required this.data});

  factory ActiveBoostersResponse.fromJson(Map<String, dynamic> json) =>
      _$ActiveBoostersResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveBoostersResponseToJson(this);
}
