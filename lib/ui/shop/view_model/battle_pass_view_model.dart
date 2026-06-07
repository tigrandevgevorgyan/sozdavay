import 'package:flutter/material.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/battle_pass.dart';

class BattlePassViewModel extends ChangeNotifier {
  BattlePassViewModel({required this.repo}) {
    _load();
  }

  final IGamificationRepository repo;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _busy = false;
  bool get busy => _busy;

  BattlePass? _bp;
  BattlePass? get bp => _bp;

  bool get isVip => _bp?.myProgress?.isVip ?? false;

  Future<void> refresh() => _load();

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _bp = await repo.getBattlePass();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> claim(int tierId, String track) async {
    if (_busy) return false;
    _busy = true;
    notifyListeners();
    try {
      await repo.claimBattlePassTier(tierId: tierId, track: track);
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
