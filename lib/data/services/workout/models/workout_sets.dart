import 'package:json_annotation/json_annotation.dart';

part 'workout_sets.g.dart';

@JsonSerializable()
class WorkoutSets {
  final int? id;
  final int itemId;
  final int exerciseId;
  final int weight;
  final int repeats;
  final int difficult;
  final int time;

  WorkoutSets({
    this.id,
    required this.itemId,
    required this.exerciseId,
    required this.weight,
    required this.repeats,
    required this.difficult,
    required this.time,
  });

  factory WorkoutSets.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetsFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutSetsToJson(this);
}