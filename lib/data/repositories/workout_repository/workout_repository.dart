import 'package:dio/dio.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/data/services/workout/workout_service.dart';
import 'package:level_up/utils/result.dart';

abstract class IWorkoutRepository {
  Future<Result<List<WorkoutInfo>>> loadWorkout({required int dayIndex});

  Future<Result<List<WorkoutInfo>>> changeExercise(int id, bool isSecond);

  Future<Result<List<WorkoutInfo>>> addSetResult(int exerciseId, int itemId, int weight, int repeats, int difficult, int time);

  Future<Result<void>> finishWorkout();

  Future<Result<List<WorkoutInfo>>> updateSetResult(int id, int exerciseId, int weight, int repeats, int difficult, int time);

  Future<Result<List<WorkoutInfo>>> deleteSetResult(int id);
}

class WorkoutRepositoryImp extends IWorkoutRepository {
  final WorkoutService _workoutService;

  WorkoutResponse? _workoutResponse;
  int? _lastDayIndex;

  WorkoutRepositoryImp({required workoutService}) : _workoutService = workoutService;

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

  @override
  Future<Result<List<WorkoutInfo>>> addSetResult(int exerciseId, int itemId, int weight, int repeats, int difficult, int time) async {
    try {
      final result = await _workoutService.addSetResult(exerciseId, itemId, weight, repeats, difficult, time);
      return await _reloadWorkout();
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<WorkoutInfo>>> updateSetResult(int id, int exerciseId, int weight, int repeats, int difficult, int time) async {
    try {
      final result = await _workoutService.updateSetResult(id, exerciseId, weight, repeats, difficult, time);
      return await _reloadWorkout();
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<WorkoutInfo>>> deleteSetResult(int id) async {
    try {
      final result = await _workoutService.deleteSetResult(id);
      return await _reloadWorkout();
    } on DioException catch (e) {
      return Result.error(e);
    }
  }
}
