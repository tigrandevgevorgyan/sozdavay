import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/clan.dart';
import 'package:level_up/routing/levelup_router.dart';
// Re-export so view widgets can `import 'clans_view_model.dart'` and still
// use ClanJoinRequest typed handlers without a second import.
export 'package:level_up/data/services/gamification/models/clan.dart' show ClanJoinRequest;

class ClansListViewModel extends ChangeNotifier {
  ClansListViewModel({required this.repo}) {
    _load();
  }

  final IGamificationRepository repo;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<Clan> _items = [];
  List<Clan> get items => _items;

  Clan? _myClan;
  Clan? get myClan => _myClan;

  Timer? _searchDebounce;
  String _search = '';
  String get search => _search;

  void onSearchChanged(String v) {
    _search = v;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _load();
    });
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await _load();
  }

  Future<void> _load() async {
    try {
      // Run in parallel.
      final results = await Future.wait([
        repo.getClans(search: _search.isEmpty ? null : _search),
        _safeMyClan(),
      ]);
      _items = results[0] as List<Clan>;
      _myClan = results[1] as Clan?;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Clan?> _safeMyClan() async {
    try {
      return await repo.getMyClan();
    } catch (_) {
      // No clan = 404 or empty data — both fine.
      return null;
    }
  }

  void onOpenClan(BuildContext context, int clanId) {
    GoRouter.of(context)
        .push(LevelUpRouter.homePath + LevelUpRouter.clanDetailPath, extra: clanId)
        .then((_) => refresh());
  }

  void onCreateClanTap(BuildContext context) {
    GoRouter.of(context)
        .push(LevelUpRouter.homePath + LevelUpRouter.createClanPath)
        .then((_) => refresh());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}

class ClanDetailViewModel extends ChangeNotifier {
  ClanDetailViewModel({required this.repo, required this.clanId}) {
    _load();
  }

  final IGamificationRepository repo;
  final int clanId;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Clan? _clan;
  Clan? get clan => _clan;

  bool _busy = false;
  bool get busy => _busy;

  /// Leader-only — pending join requests fetched in parallel with the clan
  /// detail. Empty for non-leaders or when there are no pending requests.
  List<ClanJoinRequest> _pendingRequests = [];
  List<ClanJoinRequest> get pendingRequests => _pendingRequests;

  Future<void> refresh() => _load();

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _clan = await repo.getClan(clanId);
      _error = null;
      // Leaders see the pending join-request list; everyone else skips the
      // call (the endpoint 403s for non-leaders).
      if (_clan?.isLeader == true) {
        try {
          _pendingRequests = await repo.getClanJoinRequests(clanId);
        } catch (_) {
          _pendingRequests = [];
        }
      } else {
        _pendingRequests = [];
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> kickMember(int memberCustomerId) async {
    if (_busy) return false;
    _busy = true;
    notifyListeners();
    try {
      await repo.kickClanMember(clanId: clanId, memberCustomerId: memberCustomerId);
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

  Future<bool> reviewJoinRequest(int requestId, bool approve) async {
    if (_busy) return false;
    _busy = true;
    notifyListeners();
    try {
      await repo.reviewClanJoinRequest(requestId: requestId, approve: approve);
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

  Future<bool> join() async {
    if (_busy) return false;
    _busy = true;
    notifyListeners();
    try {
      await repo.joinClan(clanId);
      await _load();
      return true;
    } catch (e) {
      _error = e.toString();
      _busy = false;
      notifyListeners();
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<bool> leave() async {
    if (_busy) return false;
    _busy = true;
    notifyListeners();
    try {
      await repo.leaveClan(clanId);
      await _load();
      return true;
    } catch (e) {
      _error = e.toString();
      _busy = false;
      notifyListeners();
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<bool> contribute(int amount) async {
    if (_busy) return false;
    _busy = true;
    notifyListeners();
    try {
      await repo.contributeToTreasury(clanId, amount);
      await _load();
      return true;
    } catch (e) {
      _error = e.toString();
      _busy = false;
      notifyListeners();
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<bool> buyBoosterCard(int definitionId) async {
    if (_busy) return false;
    _busy = true;
    notifyListeners();
    try {
      await repo.buyBoosterCard(clanId, definitionId);
      await _load();
      return true;
    } catch (e) {
      _error = e.toString();
      _busy = false;
      notifyListeners();
      return false;
    } finally {
      _busy = false;
    }
  }
}

class CreateClanViewModel extends ChangeNotifier {
  CreateClanViewModel({required this.repo});

  final IGamificationRepository repo;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String _joinPolicy = 'open';
  String get joinPolicy => _joinPolicy;
  void setJoinPolicy(String v) {
    _joinPolicy = v;
    notifyListeners();
  }

  bool _busy = false;
  bool get busy => _busy;
  String? _error;
  String? get error => _error;

  Future<Clan?> submit() async {
    if (nameController.text.trim().isEmpty) {
      _error = 'Введите название клана';
      notifyListeners();
      return null;
    }
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      final c = await repo.createClan(
        name: nameController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        joinPolicy: _joinPolicy,
      );
      return c;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
