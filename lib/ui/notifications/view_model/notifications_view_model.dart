import 'package:flutter/material.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/notification.dart';
import 'package:level_up/utils/error_utils.dart';

class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel({required this.repo}) {
    _load();
  }

  final IGamificationRepository repo;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<AppNotification> _items = [];
  List<AppNotification> get items => _items;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await _load();
  }

  Future<void> _load() async {
    try {
      final r = await repo.getNotifications();
      _items = r.data;
      _unreadCount = r.unreadCount ?? 0;
      _error = null;
    } catch (e) {
      _error = ErrorUtils.extract(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> markRead(AppNotification n) async {
    if (n.isRead) return;
    final idx = _items.indexWhere((it) => it.id == n.id);
    if (idx == -1) return;
    // Optimistic update
    _items[idx] = AppNotification(
      id: n.id,
      templateKey: n.templateKey,
      title: n.title,
      body: n.body,
      data: n.data,
      readAt: DateTime.now().toIso8601String(),
      isRead: true,
      createdAt: n.createdAt,
    );
    if (_unreadCount > 0) _unreadCount--;
    notifyListeners();
    try {
      await repo.markNotificationRead(n.id);
    } catch (_) {
      // Revert silently — re-fetch on next refresh.
    }
  }

  Future<void> markAllRead() async {
    if (_unreadCount == 0) return;
    final previous = List<AppNotification>.from(_items);
    _items = _items
        .map((n) => AppNotification(
              id: n.id,
              templateKey: n.templateKey,
              title: n.title,
              body: n.body,
              data: n.data,
              readAt: DateTime.now().toIso8601String(),
              isRead: true,
              createdAt: n.createdAt,
            ))
        .toList();
    _unreadCount = 0;
    notifyListeners();
    try {
      await repo.markAllNotificationsRead();
    } catch (_) {
      _items = previous;
      _unreadCount = _items.where((n) => !n.isRead).length;
      notifyListeners();
    }
  }
}
