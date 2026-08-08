import 'package:flutter/material.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/utils/error_utils.dart';

class NotificationPrefsViewModel extends ChangeNotifier {
  NotificationPrefsViewModel({required this.repo}) {
    _load();
  }

  final IGamificationRepository repo;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<String> _channels = [];
  List<String> get channels => _channels;

  List<String> _types = [];
  List<String> get types => _types;

  /// Indexed as `_state[channel][type] = enabled?` — missing entry = enabled
  /// (server default).
  final Map<String, Map<String, bool>> _state = {};

  /// True if the user has an explicit override for (channel, type), false if
  /// missing (server default: enabled).
  bool isEnabled(String channel, String type) =>
      _state[channel]?[type] ?? true;

  Future<void> _load() async {
    try {
      final r = await repo.getNotificationPreferences();
      _channels = r.channels;
      _types = r.types;
      _state.clear();
      for (final ch in _channels) {
        _state[ch] = {};
      }
      for (final pref in r.data) {
        _state[pref.channel] ??= {};
        _state[pref.channel]![pref.type] = pref.enabled;
      }
      _error = null;
    } catch (e) {
      _error = ErrorUtils.extract(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggle(String channel, String type) async {
    final current = isEnabled(channel, type);
    final next = !current;
    _state[channel] ??= {};
    _state[channel]![type] = next;
    notifyListeners();
    try {
      await repo.setNotificationPreference(channel: channel, type: type, enabled: next);
    } catch (_) {
      // Revert
      _state[channel]![type] = current;
      notifyListeners();
    }
  }

  String channelLabel(String channel) {
    switch (channel) {
      case 'push':
        return 'Push-уведомления';
      case 'in_app':
        return 'В приложении';
      default:
        return channel;
    }
  }

  String typeLabel(String type) {
    switch (type) {
      case 'subscription':
        return 'Подписка';
      case 'retention':
        return 'Возвращение';
      case 'achievement':
        return 'Достижения';
      case 'challenge':
        return 'Челленджи';
      case 'clan':
        return 'Клан';
      case 'level':
        return 'Повышение уровня';
      default:
        return type;
    }
  }
}
