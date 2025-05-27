import 'dart:convert';

import 'package:level_up/data/services/workout/models/workout_sets.dart';
import 'package:level_up/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalStorage {
  Future<Result<String?>> getAccessToken();

  Future<Result<void>> saveAccessToken(String token);

  Future<Result<void>> clearAccessToken();

  Future<Result<void>> saveOfflineSet(WorkoutSets set);

  Future<Result<List<Map<String, dynamic>>>> getOfflineSets();

  Future<Result<void>> removeOfflineSet(WorkoutSets set);

  Future<Result<void>> saveOfflineDeletedSet(int id);

  Future<Result<List<int>>> getOfflineDeletedSets();

  Future<Result<void>> removeOfflineDeletedSet(int id);

  Future<Result<void>> removeOfflineSetsByItemId(int itemId);

}

class LocalStorageImpl extends ILocalStorage {
  static const _tokenKey = 'access_token';
  static const _workoutSetsKey = 'workout_sets_';
  static const _deletedSetsKey = 'deleted_sets';

  @override
  Future<Result<String?>> getAccessToken() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      return Result.ok(sp.getString(_tokenKey));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveAccessToken(String token) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setString(_tokenKey, token);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> clearAccessToken() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.remove(_tokenKey);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveOfflineSet(WorkoutSets set) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final key = '$_workoutSetsKey${set.itemId}';
      final list = sp.getStringList(key) ?? [];
      final encoded = jsonEncode(set.toJson());

      if (!list.contains(encoded)) {
        list.add(encoded);
        await sp.setStringList(key, list);
      }

      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getOfflineSets() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final allKeys = sp.getKeys().where((k) => k.startsWith(_workoutSetsKey));

      final result = <Map<String, dynamic>>[];

      for (final key in allKeys) {
        final list = sp.getStringList(key) ?? [];

        for (final json in list) {
          try {
            final map = jsonDecode(json) as Map<String, dynamic>;
            result.add(map);
          } catch (e) {
          }
        }
      }
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }


  @override
  Future<Result<void>> removeOfflineSet(WorkoutSets set) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final key = '$_workoutSetsKey${set.itemId}';
      final list = sp.getStringList(key) ?? [];

      list.removeWhere((entry) {
        try {
          final decoded = WorkoutSets.fromJson(jsonDecode(entry));
          return decoded.id == set.id &&
              decoded.weight == set.weight &&
              decoded.repeats == set.repeats &&
              decoded.time == set.time;
        } catch (_) {
          return false;
        }
      });

      if (list.isEmpty) {
        await sp.remove(key);
      } else {
        await sp.setStringList(key, list);
      }

      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> removeOfflineSetsByItemId(int itemId) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final key = '$_workoutSetsKey$itemId';
      await sp.remove(key);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }


  @override
  Future<Result<void>> saveOfflineDeletedSet(int id) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final key = _deletedSetsKey;
      final data = sp.getStringList(key) ?? [];

      final idStr = id.toString();
      if (!data.contains(idStr)) {
        data.add(idStr);
        await sp.setStringList(key, data);
      }

      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }


  @override
  Future<Result<List<int>>> getOfflineDeletedSets() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final data = sp.getStringList(_deletedSetsKey) ?? [];
      final result = data.map(int.parse).toList();
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> removeOfflineDeletedSet(int id) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final data = sp.getStringList(_deletedSetsKey) ?? [];
      data.remove(id.toString());
      await sp.setStringList(_deletedSetsKey, data);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

}

