import 'dart:convert';

import 'package:level_up/data/services/workout/models/workout_sets.dart';
import 'package:level_up/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalStorage {
  Future<Result<String?>> getAccessToken();

  Future<Result<void>> saveAccessToken(String token);

  Future<Result<void>> clearAccessToken();

  Future<Result<void>> saveOfflineOperation(WorkoutSets set);

  Future<Result<List<WorkoutSets>>> getOfflineOperations();

  Future<Result<void>> removeOfflineOperation(WorkoutSets set);

  Future<Result<bool>> isFirstLogin();

  Future<Result<void>> setFirstLoginShown();

  Future<void> clearSharedPreferences();

}
const int maxCountOffline = 50;

class LocalStorageImpl extends ILocalStorage {
  static const _tokenKey = 'access_token';
  static const _workoutSetsKey = 'workout_sets';
  static const _firstLoginKey = 'first_login_shown';

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
      final operations = list
          .map((json) => WorkoutSets.fromJson(jsonDecode(json)))
          .toList();

      if (operations.length >= maxCountOffline) {
        operations.removeAt(0);
      }

      final updated = _processOperation(operations, set);
      final encoded = updated.map((op) => jsonEncode(op.toJson())).toList();
      await sp.setStringList(key, encoded);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<WorkoutSets>>> getOfflineOperations() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final list = sp.getStringList(_workoutSetsKey) ?? [];
      final result = list.map((json) => WorkoutSets.fromJson(jsonDecode(json)))
          .toList();
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
      final operations = list.map((json) => WorkoutSets.fromJson(jsonDecode(json)))
          .toList();

      operations.removeWhere((op) =>
          op.action == set.action &&
          op.id == set.id &&
          op.itemId == set.itemId &&
          op.date == set.date);

      final updated = operations.map((e) => jsonEncode(e.toJson())).toList();
      await sp.setStringList(_workoutSetsKey, updated);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  List<WorkoutSets> _processOperation(List<WorkoutSets> operations, WorkoutSets newSet) {
    final updated = List<WorkoutSets>.from(operations);

    switch (newSet.action) {
      case OfflineAction.add:
        if (newSet.id == null) break;

        final deleteIndex = updated.indexWhere(
              (op) => op.action == OfflineAction.delete && op.id == newSet.id,
        );

        if (deleteIndex != -1) {
          updated.removeAt(deleteIndex);
        } else {
          updated.removeWhere(
                (op) => op.id == newSet.id,
          );
          updated.add(newSet);
        }
        break;

      case OfflineAction.update:
        if (newSet.id == null) break;

        final addIndex = updated.indexWhere(
              (op) => op.action == OfflineAction.add && op.id == newSet.id,
        );

        if (addIndex != -1) {
          updated[addIndex] = newSet.copyWith(action: OfflineAction.add);
        } else {
          updated.removeWhere(
                (op) => op.id == newSet.id && op.action == OfflineAction.update,
          );
          updated.add(newSet);
        }
        break;

      case OfflineAction.delete:
        if (newSet.id == null) break;

        final addIndex = updated.indexWhere(
              (op) => op.action == OfflineAction.add && op.id == newSet.id,
        );

        if (addIndex != -1) {
          updated.removeAt(addIndex);
        } else {
          updated.removeWhere(
                (op) => op.id == newSet.id && (op.action == OfflineAction.update || op.action == OfflineAction.delete),
          );
          updated.add(newSet);
        }
        break;

      case OfflineAction.comment:
        updated.removeWhere(
              (op) => op.action == OfflineAction.comment && op.itemId == newSet.itemId,
        );
        updated.add(newSet);
        break;
    }

    return updated;
  }

  @override
  Future<Result<bool>> isFirstLogin() async {
    try {
      final sp = await SharedPreferences.getInstance();
      return Result.ok(!(sp.getBool(_firstLoginKey) ?? false));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> setFirstLoginShown() async{
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setBool(_firstLoginKey, true);
      return Result.ok(null);
    }  on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<void> clearSharedPreferences() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }

}

