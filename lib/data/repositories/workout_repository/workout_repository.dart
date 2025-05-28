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

  Future<void> sendOfflineOperations();

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

  @override
  Future<Result<List<WorkoutInfo>>> addSetResult( int exerciseId, int itemId, int weight, int repeats, int difficult, int time ) async {
    final offlineSet = WorkoutSets( itemId: itemId, exerciseId: exerciseId, weight: weight, repeats: repeats, difficult: difficult, time: time, action: OfflineAction.add );

    try {
      await _tryWithRetry(
            () => _workoutService.addSetResult(exerciseId, itemId, weight, repeats, difficult, time),
        onRetryError: (_) async {
          await _localStorage.saveOfflineOperation(offlineSet);
        },
      );
      return await _reloadWorkout();
    } catch (e) {
      return Result.ok([]);
    }
  }


  @override
  Future<Result<List<WorkoutInfo>>> updateSetResult( int id, int exerciseId, int weight, int repeats, int difficult, int time ) async {
    final offlineSet = WorkoutSets( id: id, exerciseId: exerciseId, weight: weight, repeats: repeats, difficult: difficult, time: time, action: OfflineAction.update );

    try {
      await _tryWithRetry(
            () => _workoutService.updateSetResult(id, exerciseId, weight, repeats, difficult, time),
        onRetryError: (_) async {
          await _localStorage.saveOfflineOperation(offlineSet);
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
      sendOfflineOperations();
    });

  }

  @override
  Future<void> sendOfflineOperations() async {
    final storedResult = await _localStorage.getOfflineOperations();

    if (storedResult is! Ok<List<Map<String, dynamic>>>) {
      _scheduleRetry();
      return;
    }

    final operations = storedResult.value;
    if (operations.isEmpty) return;

    for (final map in operations) {
      try {
        final set = WorkoutSets.fromJson(map);

        switch (set.action) {
          case OfflineAction.add:
            await _tryWithRetry(() => _workoutService.addSetResult(set.exerciseId!, set.itemId!, set.weight!, set.repeats!, set.difficult!, set.time!));
            break;

          case OfflineAction.update:
            if (set.id == null) throw Exception();
            await _tryWithRetry(() => _workoutService.updateSetResult(set.id!, set.exerciseId!, set.weight!, set.repeats!, set.difficult!, set.time!));
            break;

          case OfflineAction.delete:
            if (set.id == null) throw Exception();
            await _tryWithRetry(() => _workoutService.deleteSetResult(set.id!));
            break;
        }

        await _localStorage.removeOfflineOperation(set);

      } catch (e) {

        _scheduleRetry();
        return;
      }
    }

    _retryTimer?.cancel();
    _retryTimer = null;
  }



  @override
  Future<Result<List<WorkoutInfo>>> deleteSetResult(int id) async {
    final offlineSet = WorkoutSets(id: id, action: OfflineAction.delete);
    try {
      await _tryWithRetry(() => _workoutService.deleteSetResult(id),
        onRetryError: (_) async {
          await _localStorage.saveOfflineOperation(offlineSet);
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
