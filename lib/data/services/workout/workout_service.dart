import 'package:dio/dio.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:retrofit/retrofit.dart';

part 'workout_service.g.dart';

@RestApi()
abstract class WorkoutService {
  factory WorkoutService(Dio dio, {String? baseUrl}) = _WorkoutService;

  @GET('/workout/start')
  Future<WorkoutResponse> startWorkout();

  @POST('/workout/change')
  Future<WorkoutResponse> changeExercise(@Field() int id, @Field() bool isSecond);

  @POST('/workout/set')
  Future<List<HistoryInfo>> addSetResult(@Field('exercise_id') int exerciseId, @Field() int weight, @Field() int repeats, @Field() int difficult, @Field() int time);
}
