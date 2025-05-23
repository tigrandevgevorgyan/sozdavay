import 'package:dio/dio.dart';
import 'package:level_up/data/services/workout/models/workout_finish_response.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:retrofit/retrofit.dart';

part 'workout_service.g.dart';

@RestApi()
abstract class WorkoutService {
  factory WorkoutService(Dio dio, {String? baseUrl}) = _WorkoutService;

  @GET('/workout/start')
  Future<WorkoutResponse> startWorkout(@Query('day') int dayIndex);

  @POST('/workout/finish')
  Future<WorkoutFinishResponse> finishWorkout();

  @POST('/workout/change')
  Future<WorkoutResponse> changeExercise(@Field() int id, @Field() bool isSecond);

  @POST('/workout/set')
  Future<List<HistoryInfo>> addSetResult(@Field('exercise_id') int exerciseId, @Field() int weight, @Field() int repeats, @Field() int difficult, @Field() int time);

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
