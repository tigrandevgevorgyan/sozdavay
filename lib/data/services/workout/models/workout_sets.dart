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
  final String? date;

  WorkoutSets({
    this.id,
    this.itemId,
    this.exerciseId,
    this.weight,
    this.repeats,
    this.difficult,
    this.time,
    this.date,
    required this.action,
  });

  WorkoutSets._({
    this.id,
    this.itemId,
    this.exerciseId,
    this.weight,
    this.repeats,
    this.difficult,
    this.time,
    this.date,
    required this.action,
  });

  factory WorkoutSets.add({
    required int itemId,
    required int exerciseId,
    required int weight,
    required int repeats,
    required int difficult,
    required int time,
    required String date,
  }) {
    return WorkoutSets._(
      itemId: itemId,
      exerciseId: exerciseId,
      weight: weight,
      repeats: repeats,
      difficult: difficult,
      time: time,
      date: date,
      action: OfflineAction.add,
    );
  }

  factory WorkoutSets.update({
    required int id,
    required int exerciseId,
    required int weight,
    required int repeats,
    required int difficult,
    required int time,
  }) {
    return WorkoutSets._(
      id: id,
      exerciseId: exerciseId,
      weight: weight,
      repeats: repeats,
      difficult: difficult,
      time: time,
      action: OfflineAction.update,
    );
  }

  factory WorkoutSets.delete({required int id}) {
    return WorkoutSets._(
      id: id,
      action: OfflineAction.delete,
    );
  }

  factory WorkoutSets.fromJson(Map<String, dynamic> json) => _$WorkoutSetsFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutSetsToJson(this);
}
