import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/referral.dart';

class ReferralsViewModel extends ChangeNotifier {
  ReferralsViewModel({required this.repo}) {
    _load();
  }

  final IGamificationRepository repo;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  ReferralInfo? _info;
  ReferralInfo? get info => _info;

  Future<void> refresh() => _load();

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _info = await repo.getMyReferralInfo();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> copyCode() async {
    final code = _info?.code;
    if (code == null) return;
    await Clipboard.setData(ClipboardData(text: code));
  }
}
