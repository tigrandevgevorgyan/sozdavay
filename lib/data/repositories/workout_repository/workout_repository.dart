import 'dart:async';

import 'package:dio/dio.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/data/services/workout/workout_service.dart';
import 'package:level_up/utils/result.dart';

import '../../services/local_storage.dart';
import '../../services/workout/models/workout_sets.dart';

abstract class IWorkoutRepository {
  Future<Result<List<WorkoutInfo>>> loadWorkout({required int dayIndex});

  Future<Result<List<WorkoutInfo>>> changeExercise(int id, bool isSecond);

  Future<Result<List<WorkoutInfo>>> addSetResult(int exerciseId, int itemId, int weight, int repeats, int difficult, int time);

  Future<Result<void>> finishWorkout();

  Future<Result<List<WorkoutInfo>>> updateSetResult(int id, int exerciseId, int weight, int repeats, int difficult, int time);

  Future<Result<List<WorkoutInfo>>> deleteSetResult(int id);

  Future<void> sendOfflineSets();

  void dispose();
}

class WorkoutRepositoryImp extends IWorkoutRepository {
  final WorkoutService _workoutService;
  final ILocalStorage _localStorage;
  Timer? _retryTimer;

  WorkoutResponse? _workoutResponse;
  int? _lastDayIndex;

  WorkoutRepositoryImp(this._localStorage, {required workoutService}) : _workoutService = workoutService;

  @override
  Future<Result<List<WorkoutInfo>>> loadWorkout({required int dayIndex}) async {
    try {
      final result = await _workoutService.startWorkout(dayIndex);
      _workoutResponse = result;
      _lastDayIndex = dayIndex;
      return Result.ok(result.data);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> finishWorkout() async {
    try {
      final result = await _workoutService.finishWorkout();
      if (result.isSuccess) {
        return Result.ok(null);
      } else {
        return Result.error(Exception('Не удалось завершить тренировку'));
      }
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<WorkoutInfo>>> changeExercise(int id, bool isSecond) async {
    try {
      final result = await _workoutService.changeExercise(id, isSecond);
      _workoutResponse = result;
      return Result.ok(result.data);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<WorkoutInfo>>> _reloadWorkout() async {
    if (_lastDayIndex == null) {
      return Result.error(Exception('Не указан день тренировки'));
    }
    return await loadWorkout(dayIndex: _lastDayIndex!);

  }


  Future<void> _tryWithRetry(
      Future<void> Function() operation, {
        int maxTryCount = 3,
        void Function(Object error)? onRetryError,
      }) async {
    for (int tryCount = 1; tryCount <= maxTryCount; tryCount++) {
      try {
        await operation();
        return;
      } catch (e) {

        if (tryCount == 1 && onRetryError != null) {
          onRetryError(e);
        }

        if (tryCount == maxTryCount) rethrow;
        await Future.delayed(Duration(seconds: 1));
      }
    }
  }

  int _findItemIdByExerciseId(int exerciseId) {
    for (final w in _workoutResponse?.data ?? []) {
      for (final item in w.items) {
        if (item.id == exerciseId) {
          return item.itemId;
        }
      }
    }
    throw Exception();
  }


  @override
  Future<Result<List<WorkoutInfo>>> addSetResult( int exerciseId, int itemId, int weight, int repeats, int difficult, int time ) async {
    final offlineSet = WorkoutSets( itemId: itemId, exerciseId: exerciseId, weight: weight, repeats: repeats, difficult: difficult, time: time );

    try {
      await _tryWithRetry(
            () => _workoutService.addSetResult(exerciseId, itemId, weight, repeats, difficult, time),
        onRetryError: (_) async {
          await _localStorage.removeOfflineSetsByItemId(itemId);
          await _localStorage.saveOfflineSet(offlineSet);
        },
      );
      return await _reloadWorkout();
    } catch (e) {
      return Result.ok([]);
    }
  }


  @override
  Future<Result<List<WorkoutInfo>>> updateSetResult( int id, int exerciseId, int weight, int repeats, int difficult, int time ) async {
    final itemId = _findItemIdByExerciseId(exerciseId);
    final offlineSet = WorkoutSets( id: id, itemId: itemId, exerciseId: exerciseId, weight: weight, repeats: repeats, difficult: difficult, time: time );

    try {
      await _tryWithRetry(
            () => _workoutService.updateSetResult(id, exerciseId, weight, repeats, difficult, time),
        onRetryError: (_) async {
          await _localStorage.removeOfflineSetsByItemId(itemId);
          await _localStorage.saveOfflineSet(offlineSet);
        },
      );
      return await _reloadWorkout();
    } catch (e) {
      return Result.ok([]);
    }
  }



  void _scheduleRetry() {
    if (_retryTimer?.isActive ?? false) {
      return;
    }
    _retryTimer = Timer(Duration(minutes: 5), () {
      sendOfflineSets();
    });

  }

  @override
  Future<void> sendOfflineSets() async {
    try {
      await _sendOfflineDeletedSets();

      final storedSetsResult = await _localStorage.getOfflineSets();
      if (storedSetsResult is Ok<List<Map<String, dynamic>>>) {
        final storedSets = storedSetsResult.value;
        if (storedSets.isEmpty) {
          return;
        }

        for (final setMap in storedSets) {
          try {
            final set = WorkoutSets.fromJson(setMap);

            if (set.id != null) {
              await _tryWithRetry(() => _workoutService.updateSetResult(
                  set.id!, set.exerciseId, set.weight, set.repeats, set.difficult, set.time
              ));
            } else {
              await _tryWithRetry(() => _workoutService.addSetResult(
                  set.exerciseId, set.itemId, set.weight, set.repeats, set.difficult, set.time
              ));
            }

            await _localStorage.removeOfflineSet(set);

          } catch (e) {
            _scheduleRetry();
            return;
          }
        }

        _retryTimer?.cancel();
        _retryTimer = null;
      }
    } catch (e) {
      _scheduleRetry();
    }
  }


  Future<void> _sendOfflineDeletedSets() async {
    final deletedResult = await _localStorage.getOfflineDeletedSets();

    if (deletedResult is! Ok<List<int>>) {
      return;
    }

    final deletedIds = deletedResult.value;
    if (deletedIds.isEmpty) {
      return;
    }

    for (final id in deletedIds) {
      try {
        await _tryWithRetry(() => _workoutService.deleteSetResult(id));
        await _localStorage.removeOfflineDeletedSet(id);
      } catch (e) {
        _scheduleRetry();
        return;
      }
    }
  }


  @override
  Future<Result<List<WorkoutInfo>>> deleteSetResult(int id) async {
    try {
      await _tryWithRetry(() => _workoutService.deleteSetResult(id),
        onRetryError: (_) async {
          await _localStorage.saveOfflineDeletedSet(id);
        },
      );
      return await _reloadWorkout();
    } catch (e) {
      return Result.ok([]);
    }
  }


  @override
  void dispose() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }
}
