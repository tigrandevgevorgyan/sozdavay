import 'package:json_annotation/json_annotation.dart';

part 'workout_sets.g.dart';

enum OfflineAction { add, update, delete }

@JsonSerializable()
class WorkoutSets {
  final int? id;
  final int? itemId;
  final int? exerciseId;
  final int? weight;
  final int? repeats;
  final int? difficult;
  final int? time;
  final OfflineAction action;

  WorkoutSets({
    this.id,
    this.itemId,
    this.exerciseId,
    this.weight,
    this.repeats,
    this.difficult,
    this.time,
    required this.action,
  });

  factory WorkoutSets.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetsFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutSetsToJson(this);
}