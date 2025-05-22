import 'package:json_annotation/json_annotation.dart';
import 'package:level_up/data/services/common_models/base_response.dart';

part 'workout_response.g.dart';

@JsonSerializable()
class WorkoutResponse extends BaseResponse {
  WorkoutResponse(super.message, this.data);

  final List<WorkoutInfo> data;

  factory WorkoutResponse.fromJson(Map<String, dynamic> json) => _$WorkoutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WorkoutInfo {
  final int index;
  final bool isDouble;
  final bool isComplex;
  final List<ExerciseInfo> items;

  factory WorkoutInfo.fromJson(Map<String, dynamic> json) => _$WorkoutInfoFromJson(json);

  WorkoutInfo(this.index, this.isDouble, this.isComplex, this.items);

  Map<String, dynamic> toJson() => _$WorkoutInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ExerciseInfo {
  final int id;
  final String name;
  final int minRepeats;
  final int maxRepeats;
  final int minSets;
  final int maxSets;
  final int minRest;
  final int maxRest;
  final bool lastSetsFull;
  final String? description;
  final List<HistoryInfo> history;

  factory ExerciseInfo.fromJson(Map<String, dynamic> json) => _$ExerciseInfoFromJson(json);

  ExerciseInfo(this.id, this.name, this.history, this.minRepeats, this.maxRepeats, this.minSets, this.maxSets, this.minRest, this.maxRest, this.lastSetsFull, this.description);

  Map<String, dynamic> toJson() => _$ExerciseInfoToJson(this);
}

@JsonSerializable()
class HistoryInfo {
  final String day;
  final String date;
  final List<ResultValue> values;

  HistoryInfo(this.day, this.date, this.values);

  factory HistoryInfo.fromJson(Map<String, dynamic> json) => _$HistoryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryInfoToJson(this);
}

@JsonSerializable()
class ResultValue {
  final int id;
  final String weight;
  final int repeats;

  ResultValue(this.weight, this.repeats, this.id);

  factory ResultValue.fromJson(Map<String, dynamic> json) => _$ResultValueFromJson(json);

  Map<String, dynamic> toJson() => _$ResultValueToJson(this);
}
