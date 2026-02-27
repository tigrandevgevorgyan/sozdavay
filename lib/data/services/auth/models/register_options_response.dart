import 'package:json_annotation/json_annotation.dart';
import 'package:level_up/data/services/common_models/base_response.dart';

part 'register_options_response.g.dart';

@JsonSerializable()
class RegisterOptionsResponse extends BaseResponse {
  final List<TrainingPlaceOption> training_places;
  final List<TrainingGoalOption> training_goals;
  final List<TrainingPerWeekOption> training_per_week;
  final List<GenderOption> genders;

  RegisterOptionsResponse(
    super.message,
    this.training_places,
    this.training_goals,
    this.training_per_week,
    this.genders,
  );

  factory RegisterOptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterOptionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterOptionsResponseToJson(this);
}

@JsonSerializable()
class TrainingPlaceOption {
  final int id;
  final String name;

  TrainingPlaceOption(this.id, this.name);

  factory TrainingPlaceOption.fromJson(Map<String, dynamic> json) =>
      _$TrainingPlaceOptionFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingPlaceOptionToJson(this);
}

@JsonSerializable()
class TrainingGoalOption {
  final int id;
  final String name;

  TrainingGoalOption(this.id, this.name);

  factory TrainingGoalOption.fromJson(Map<String, dynamic> json) =>
      _$TrainingGoalOptionFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingGoalOptionToJson(this);
}

@JsonSerializable()
class TrainingPerWeekOption {
  final String title;
  final dynamic value; // backend returns "2" or 3, 4, so dynamic

  TrainingPerWeekOption(this.title, this.value);

  factory TrainingPerWeekOption.fromJson(Map<String, dynamic> json) =>
      _$TrainingPerWeekOptionFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingPerWeekOptionToJson(this);
}

@JsonSerializable()
class GenderOption {
  final String label;
  final int value;

  GenderOption(this.label, this.value);

  factory GenderOption.fromJson(Map<String, dynamic> json) =>
      _$GenderOptionFromJson(json);

  Map<String, dynamic> toJson() => _$GenderOptionToJson(this);
}
