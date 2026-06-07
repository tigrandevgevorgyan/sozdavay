import 'package:flutter/material.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/shop_product.dart';

class ShopViewModel extends ChangeNotifier {
  ShopViewModel({required this.repo}) {
    _load();
  }

  final IGamificationRepository repo;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _busy = false;
  bool get busy => _busy;

  List<ShopProduct> _items = [];
  List<ShopProduct> get items => _items;

  Future<void> refresh() => _load();

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await repo.getShopProducts();
      _error = null;
    } catch (e) {
      _error = e.toString();
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
      _error = e.toString();
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }
}
