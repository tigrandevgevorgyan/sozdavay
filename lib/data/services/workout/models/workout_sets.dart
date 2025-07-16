import 'package:json_annotation/json_annotation.dart';

part 'workout_sets.g.dart';

@JsonEnum(fieldRename: FieldRename.none)
enum OfflineAction {
  @JsonValue('add')
  add,

  @JsonValue('update')
  update,

  @JsonValue('delete')
  delete,

  @JsonValue('comment')
  comment,
}


@JsonSerializable()
class WorkoutSets {
  final int? id;
  final int? itemId;
  final int? exerciseId;
  final double? weight;
  final int? repeats;
  final int? difficult;
  final int? time;
  final OfflineAction action;
  final String? date;
  final String? comment;

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
    this.comment,
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
    this.comment,
    required this.action,
  });

  factory WorkoutSets.add({
    required int itemId,
    required int exerciseId,
    required double weight,
    required int repeats,
    required int difficult,
    required int time,
    required String date,
    int? id,
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
      id: id,
    );
  }

  factory WorkoutSets.update({
    required int itemId,
    required int id,
    required int exerciseId,
    required double weight,
    required int repeats,
    required int difficult,
    required int time,
    required String date,
  }) {
    return WorkoutSets._(
      itemId: itemId,
      id: id,
      exerciseId: exerciseId,
      weight: weight,
      repeats: repeats,
      difficult: difficult,
      time: time,
      action: OfflineAction.update,
      date: date,
    );
  }

  factory WorkoutSets.delete({required int id}) {
    return WorkoutSets._(
      id: id,
      action: OfflineAction.delete,
    );
  }

  factory WorkoutSets.comment({
    required int itemId,
    required  comment,
  }) {
    return WorkoutSets._(
      itemId: itemId,
      comment: comment,
      action: OfflineAction.comment,
    );
  }

  factory WorkoutSets.fromJson(Map<String, dynamic> json) => _$WorkoutSetsFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutSetsToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WorkoutSets &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              itemId == other.itemId &&
              exerciseId == other.exerciseId &&
              weight == other.weight &&
              repeats == other.repeats &&
              difficult == other.difficult &&
              time == other.time &&
              date == other.date &&
              comment == other.comment &&
              action == other.action;

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    exerciseId,
    weight,
    repeats,
    difficult,
    time,
    date,
    comment,
    action,
  );

}

extension WorkoutSetsCopyWith on WorkoutSets {
  WorkoutSets copyWith({
    int? id,
    int? itemId,
    int? exerciseId,
    double? weight,
    int? repeats,
    int? difficult,
    int? time,
    String? date,
    String? comment,
    OfflineAction? action,
  }) {
    return WorkoutSets(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      exerciseId: exerciseId ?? this.exerciseId,
      weight: weight ?? this.weight,
      repeats: repeats ?? this.repeats,
      difficult: difficult ?? this.difficult,
      time: time ?? this.time,
      date: date ?? this.date,
      comment: comment ?? this.comment,
      action: action ?? this.action,
    );
  }
}

