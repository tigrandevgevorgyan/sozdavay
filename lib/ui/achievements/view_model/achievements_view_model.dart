import 'package:flutter/material.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/achievement.dart';

enum AchievementsFilter { all, earned, available }

class AchievementsViewModel extends ChangeNotifier {
  AchievementsViewModel({required this.repo}) {
    _load();
  }

  final IGamificationRepository repo;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _featureDisabled = false;
  bool get featureDisabled => _featureDisabled;

  String? _error;
  String? get error => _error;

  List<Achievement> _all = [];
  List<Achievement> get all => _all;

  AchievementsFilter _filter = AchievementsFilter.all;
  AchievementsFilter get filter => _filter;

  List<Achievement> get filtered {
    switch (_filter) {
      case AchievementsFilter.all:
        return _all;
      case AchievementsFilter.earned:
        return _all.where((a) => a.isGranted).toList();
      case AchievementsFilter.available:
        return _all.where((a) => !a.isGranted).toList();
    }
  }

  int get earnedCount => _all.where((a) => a.isGranted).length;

  void setFilter(AchievementsFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await _load();
  }

  Future<void> _load() async {
    try {
      _all = await repo.getAchievements();
      _featureDisabled = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
