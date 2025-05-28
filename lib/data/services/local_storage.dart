import 'dart:convert';

import 'package:level_up/data/services/workout/models/workout_sets.dart';
import 'package:level_up/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalStorage {
  Future<Result<String?>> getAccessToken();

  Future<Result<void>> saveAccessToken(String token);

  Future<Result<void>> clearAccessToken();

  Future<Result<void>> saveOfflineOperation(WorkoutSets set);

  Future<Result<List<Map<String, dynamic>>>> getOfflineOperations();

  Future<Result<void>> removeOfflineOperation(WorkoutSets set);

}

class LocalStorageImpl extends ILocalStorage {
  static const _tokenKey = 'access_token';
  static const _workoutSetsKey = 'workout_sets';

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
  Future<Result<void>> saveOfflineOperation(WorkoutSets set) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final key = _workoutSetsKey;
      final list = sp.getStringList(key) ?? [];
      final encoded = jsonEncode(set.toJson());
      list.removeWhere((entry) => entry == encoded);
      list.add(encoded);
      await sp.setStringList(key, list);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }


  @override
  Future<Result<List<Map<String, dynamic>>>> getOfflineOperations() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final list = sp.getStringList(_workoutSetsKey) ?? [];
      final result = list.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> removeOfflineOperation(WorkoutSets set) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final list = sp.getStringList(_workoutSetsKey) ?? [];
      list.removeWhere((entry) => entry == jsonEncode(set.toJson()));
      await sp.setStringList(_workoutSetsKey, list);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}

