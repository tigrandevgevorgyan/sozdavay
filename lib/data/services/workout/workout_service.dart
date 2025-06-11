import 'package:dio/dio.dart';
import 'package:level_up/data/services/common_models/is_completed_response.dart';
import 'package:level_up/data/services/workout/models/workout_finish_response.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:retrofit/retrofit.dart';

part 'workout_service.g.dart';

@RestApi()
abstract class WorkoutService {
  factory WorkoutService(Dio dio, {String? baseUrl}) = _WorkoutService;

  @GET('/workout/start')
  Future<WorkoutResponse> startWorkout(@Query('day') int dayIndex);

  @DELETE('/workout/{id}')
  Future<IsCompletedResponse> deleteWorkout(@Path("id") int workoutId);

  @POST('/workout/finish')
  Future<WorkoutFinishResponse> finishWorkout();

  @POST('/workout/change')
  Future<WorkoutResponse> changeExercise(@Field() int index, @Field() bool second, @Field() int day);

  @POST('/workout/set')
  Future<List<HistoryInfo>> addSetResult(
    @Field('exercise_id') int exerciseId,
    @Field('item_id') int itemId,
    @Field() int weight,
    @Field() int repeats,
    @Field() int difficult,
    @Field() int time,
    @Field() String date,
  );

  @PUT('/workout/set')
  Future<List<HistoryInfo>> updateSetResult(
    @Query('id') int id,
    @Query('exercise_id') int exerciseId,
    @Query('weight') int weight,
    @Query('repeats') int repeats,
    @Query('difficult') int difficult,
    @Query('time') int time,
  );

  @DELETE('/workout/set')
  Future<List<HistoryInfo>> deleteSetResult(@Query('id') int id);
}
