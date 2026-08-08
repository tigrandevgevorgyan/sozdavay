import 'package:flutter/material.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/gamification/models/shop_product.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/utils/result.dart';
import 'package:level_up/utils/error_utils.dart';

/// Category tabs from Gohar's Shop design (Figma 55:472).
enum ShopCategory { all, avatars, boosters }

class ShopViewModel extends ChangeNotifier {
  ShopViewModel({required this.repo, required this.profileRepository}) {
    _load();
  }

  final IGamificationRepository repo;
  final IProfileRepository profileRepository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _busy = false;
  bool get busy => _busy;

  List<ShopProduct> _items = [];
  List<ShopProduct> get items => _items;

  ShopCategory _category = ShopCategory.all;
  ShopCategory get category => _category;

  /// Customer's creator-points balance — displayed at the top of the shop
  /// per Figma. Loaded via the cached profile (no extra /profile call).
  int _creatorPoints = 0;
  int get creatorPoints => _creatorPoints;

  /// Filtered view of [_items] honouring [_category].
  List<ShopProduct> get filtered {
    switch (_category) {
      case ShopCategory.all:
        return _items;
      case ShopCategory.avatars:
        return _items.where((p) => p.type == 'avatar_frame').toList();
      case ShopCategory.boosters:
        // Everything that isn't a frame is treated as a "booster" — covers
        // rating_points, creator_points, battle_pass, subscription_extension,
        // other. Backend ShopProduct.type doesn't have a literal "booster"
        // category; this maps Gohar's tab to a sensible product subset.
        return _items.where((p) => p.type != 'avatar_frame').toList();
    }
  }

  void setCategory(ShopCategory c) {
    if (_category == c) return;
    _category = c;
    notifyListeners();
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        repo.getShopProducts(),
        profileRepository.getProfile(),
      ]);
      _items = results[0] as List<ShopProduct>;
      final profile = results[1] as Result<UserProfileExtendedResponse>;
      if (profile is Ok<UserProfileExtendedResponse>) {
        _creatorPoints = profile.value.data.creatorPoints ?? 0;
      }
      _error = null;
    } catch (e) {
      _error = ErrorUtils.extract(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> purchase(int productId) async {
    if (_busy) return false;
    _busy = true;
    notifyListeners();
    try {
      await repo.purchaseProduct(productId);
      await _load();
      return true;
    } catch (e) {
      _error = ErrorUtils.extract(e);
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }
}
