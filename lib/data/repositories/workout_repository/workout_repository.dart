import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:level_up/data/services/common_models/is_completed_response.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/data/services/workout/workout_service.dart';
import 'package:level_up/utils/result.dart';
import '../../../config/dio_client.dart';
import '../../services/local_storage.dart';
import '../../services/workout/models/workout_comment.dart';
import '../../services/workout/models/workout_sets.dart';

abstract class IWorkoutRepository {
  Future<Result<WorkoutResponse>> loadWorkout({required int dayIndex});

  Future<Result<List<WorkoutInfo>>> changeExercise(int index, bool second);

  Future<Result<List<HistoryInfo>>> addSetResult(int exerciseId, int itemId, double weight, int repeats, int difficult, int time, String date, {required int localId});

  Future<Result<void>> finishWorkout();

  Future<Result<IsCompletedResponse>> deleteWorkout(int workoutId);

  Future<Result<List<HistoryInfo>>> updateSetResult(int id, int itemId, int exerciseId, double weight, int repeats, int difficult, int time, String date);

  Future<Result<List<HistoryInfo>>> deleteSetResult(int id);

  Future<Result<int>> sendOfflineOperations();

  Future<Result<void>> updateWorkoutComment(int itemId, WorkoutComment body);

}

class WorkoutRepositoryImp extends IWorkoutRepository {
  final WorkoutService _workoutService;
  final ILocalStorage _localStorage;

  WorkoutResponse? _workoutResponse;
  int? _lastDayIndex;
  bool isLocalId(int id) => id < 0;

  WorkoutRepositoryImp(this._localStorage, {required workoutService}) : _workoutService = workoutService;

  @override
  Future<Result<WorkoutResponse>> loadWorkout({required int dayIndex}) async {
    try {
      final result = await _workoutService.startWorkout(dayIndex);
      _workoutResponse = result;
      _lastDayIndex = dayIndex;
      _preloadWorkoutVideos(result);
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  Future<void> _preloadWorkoutVideos(WorkoutResponse workout) async {
    final cache = DefaultCacheManager();
    final videoUrls = <String>{};

    for (final block in workout.data) {
      for (final item in block.items) {
        final videos = item.videos ?? [];

        for (final video in videos) {
          final url = video.url;

          if (url.trim().isNotEmpty) {
            videoUrls.add(url);
          }
        }
      }
    }

    for (final url in videoUrls) {
      try {
        await cache.downloadFile(url);
      } catch (e) {
      }
    }
  }

  @override
  Future<Result<IsCompletedResponse>> deleteWorkout(int workoutId) async {
    try {
      final result = await _workoutService.deleteWorkout(workoutId);
      if (result.isSuccess) {
        return Result.ok(result);
      } else {
        return Result.error(Exception('Не удалось завершить тренировку'));
      }
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
  Future<Result<List<WorkoutInfo>>> changeExercise(int index, bool second) async {
    try {
      final dayIndex = _lastDayIndex ?? 0;
      final result = await _workoutService.changeExercise(index, second, dayIndex);
      _workoutResponse = result;
      _preloadWorkoutVideos(result);
      return Result.ok(result.data);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  Future<T> _tryWithRetry<T>(
    Future<T> Function() operation, {
    int maxTryCount = 3,
    void Function(Object error)? onRetryError,
  }) async {
    for (int tryCount = 1; tryCount <= maxTryCount; tryCount++) {
      try {
        return await operation();
      } catch (e) {
        if (tryCount == 1 && onRetryError != null) {
          onRetryError(e);
        }

        if (tryCount == maxTryCount) rethrow;
        await Future.delayed(Duration(seconds: 1));
      }
    }
    throw Exception();
  }

  @override
  Future<Result<List<HistoryInfo>>> addSetResult(int exerciseId, int itemId, double weight, int repeats, int difficult, int time, String date, {required int localId}) async {
    final offlineSet = WorkoutSets.add(itemId: itemId, exerciseId: exerciseId, weight: weight, repeats: repeats, difficult: difficult, time: time, date: date, id: localId);

    try {
      final response = await _tryWithRetry(
            () => _workoutService.addSetResult(exerciseId, itemId, weight, repeats, difficult, time, date),
        onRetryError: (_) async {
          await _localStorage.saveOfflineOperation(offlineSet);
        },
      );
      await _localStorage.removeOfflineOperation(offlineSet);
      return Result.ok(response);
    } on DataNotFoundError {
      await _localStorage.removeOfflineOperation(offlineSet);
      return Result.error(Exception("Данные не найдены"));
    } catch (_) {
      debugPrint('НЕ УДАЛОСЬ ДОБАВИТЬ СЕТ');
      return Result.ok([]);
    }
  }

  @override
  Future<Result<List<HistoryInfo>>> updateSetResult(int id, int itemId, int exerciseId, double weight, int repeats, int difficult, int time, String date) async {
    final offlineSet = WorkoutSets.update(id: id, itemId: itemId, exerciseId: exerciseId, weight: weight, repeats: repeats, difficult: difficult, time: time, date: date);

    if (isLocalId(id)) {
      await _localStorage.saveOfflineOperation(offlineSet);
      return Result.ok([]);
    }

    try {
      final response = await _tryWithRetry(
            () => _workoutService.updateSetResult(id, exerciseId, weight, repeats, difficult, time),
        onRetryError: (e) async {
          await _localStorage.saveOfflineOperation(offlineSet);
        },
      );
      await _localStorage.removeOfflineOperation(offlineSet);
      return Result.ok(response);
    } on DataNotFoundError {
      await _localStorage.removeOfflineOperation(offlineSet);
      return Result.error(Exception("Данные не найдены"));
    } catch (_) {
      debugPrint('НЕ УДАЛОСЬ ОБНОВИТЬ СЕТ');
      return Result.ok([]);
    }
  }

  @override
  Future<Result<int>> sendOfflineOperations() async {
    final storedResult = await _localStorage.getOfflineOperations();

    if (storedResult is! Ok<List<WorkoutSets>>) return Result.error(Exception('НЕ УДАЛОСЬ ЗАГРУЗИТЬ ОФФЛАЙН-ОПЕРАЦИИ'));

    final operations = storedResult.value;
    if (operations.isEmpty) return Result.ok(0);

    int successCount = 0;

    for (final set in operations) {
      try {
        switch (set.action) {
          case OfflineAction.add:
            await _tryWithRetry(() => _workoutService.addSetResult(set.exerciseId!, set.itemId!, set.weight!, set.repeats!, set.difficult!, set.time!, set.date!));
            break;

          case OfflineAction.update:
            if (set.id == null) throw Exception();
            await _tryWithRetry(() => _workoutService.updateSetResult(set.id!, set.exerciseId!, set.weight!, set.repeats!, set.difficult!, set.time!));
            break;

          case OfflineAction.delete:
            if (set.id == null) throw Exception();
            await _tryWithRetry(() => _workoutService.deleteSetResult(set.id!));
            break;
          case OfflineAction.comment:
            if (set.itemId == null || set.comment == null) throw Exception();
            await _tryWithRetry(() => _workoutService.updateWorkoutComment(
              set.itemId!,
              WorkoutComment(comment: set.comment!),
            ));
            break;
        }
        await _localStorage.removeOfflineOperation(set);
        successCount++;
      } on DataNotFoundError {
        await _localStorage.removeOfflineOperation(set);
        continue;
      } catch (_) {
        debugPrint('ОШИБКА ОТПРАВКИ ОФФЛАЙН ОПЕРАЦИЙ');
      }
    }
    return Result.ok(successCount);
  }

  @override
  Future<Result<List<HistoryInfo>>> deleteSetResult(int id) async {
    final offlineSet = WorkoutSets.delete(id: id);

    if (isLocalId(id)) {
      await _localStorage.saveOfflineOperation(offlineSet);
      return Result.ok([]);
    }

    try {
      final response = await _tryWithRetry(
            () => _workoutService.deleteSetResult(id),
        onRetryError: (_) async {
          await _localStorage.saveOfflineOperation(offlineSet);
        },
      );
      await _localStorage.removeOfflineOperation(offlineSet);
      return Result.ok(response);
    } on DataNotFoundError {
      await _localStorage.removeOfflineOperation(offlineSet);
      return Result.error(Exception("Данные не найдены"));
    } catch (_) {
      debugPrint('НЕ УДАЛОСЬ УДАЛИТЬ СЕТ');
      return Result.ok([]);
    }
  }

  @override
  Future<Result<void>> updateWorkoutComment(int itemId, WorkoutComment body) async {
    final offlineComment = WorkoutSets.comment(itemId: itemId, comment: body.comment);
    try {
      await _workoutService.updateWorkoutComment(itemId, body);
      return Result.ok(null);
    } catch (e) {
      await _localStorage.saveOfflineOperation(offlineComment);
      return Result.ok(null);
    }
  }
}
