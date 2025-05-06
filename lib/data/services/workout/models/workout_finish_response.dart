import 'package:json_annotation/json_annotation.dart';

part 'workout_finish_response.g.dart';

@JsonSerializable()
class WorkoutFinishResponse {
  @JsonKey(name: 'success')
  final bool isSuccess;

  WorkoutFinishResponse(this.isSuccess);

  factory WorkoutFinishResponse.fromJson(Map<String, dynamic> json) => _$WorkoutFinishResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutFinishResponseToJson(this);
}
