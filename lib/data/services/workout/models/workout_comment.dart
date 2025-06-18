import 'package:json_annotation/json_annotation.dart';

part 'workout_comment.g.dart';

@JsonSerializable()
class WorkoutComment {
  final String comment;

  WorkoutComment({required this.comment});

  factory WorkoutComment.fromJson(Map<String, dynamic> json) =>
      _$WorkoutCommentFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutCommentToJson(this);
}
