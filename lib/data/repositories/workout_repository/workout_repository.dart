import 'package:dio/dio.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/data/services/workout/workout_service.dart';
import 'package:level_up/utils/result.dart';

abstract class IWorkoutRepository {
  Future<Result<List<WorkoutInfo>>> loadWorkout();

  Future<Result<List<WorkoutInfo>>> changeExercise(int id, bool isSecond);

  Future<Result<List<WorkoutInfo>>> addSetResult(int exerciseId, int weight, int repeats, int difficult, int time);
}

class WorkoutRepositoryImp extends IWorkoutRepository {
  final WorkoutService _workoutService;

  WorkoutResponse? _workoutResponse;

  WorkoutRepositoryImp({required workoutService}) : _workoutService = workoutService;

  @override
  Future<Result<List<WorkoutInfo>>> loadWorkout() async {
    try {
      final result = await _workoutService.startWorkout();
      _workoutResponse = result;
      return Result.ok(result.data);
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

  @override
  Future<Result<List<WorkoutInfo>>> addSetResult(int exerciseId, int weight, int repeats, int difficult, int time) async {
    try {
      final result = await _workoutService.addSetResult(exerciseId, weight, repeats, difficult, time);
      return await loadWorkout();
    } on DioException catch (e) {
      return Result.error(e);
    }
  }
}
