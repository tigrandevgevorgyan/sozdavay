import 'package:flutter/material.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/avatar_frame.dart';
import 'package:level_up/utils/error_utils.dart';

class FramesViewModel extends ChangeNotifier {
  FramesViewModel({required this.repo}) {
    _load();
  }

  final IGamificationRepository repo;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _busy = false;
  bool get busy => _busy;

  String? _error;
  String? get error => _error;

  List<CustomerAvatarFrame> _items = [];
  List<CustomerAvatarFrame> get items => _items;

  CustomerAvatarFrame? get equipped =>
      _items.where((f) => f.isEquipped).cast<CustomerAvatarFrame?>().firstWhere(
            (_) => true,
            orElse: () => null,
          );

  Future<void> refresh() => _load();

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await repo.getMyFrames();
      _error = null;
    } catch (e) {
      _error = ErrorUtils.extract(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> equip(CustomerAvatarFrame frame) async {
    if (_busy || frame.definition == null) return;
    _busy = true;
    notifyListeners();
    try {
      final isCurrentlyEquipped = frame.isEquipped;
      await repo.equipFrame(isCurrentlyEquipped ? null : frame.definition!.id);
      await _load();
    } catch (e) {
      _error = ErrorUtils.extract(e);
    } finally {
      _busy = false;
      notifyListeners();
    }
  }
}
