import 'package:json_annotation/json_annotation.dart';
import 'package:level_up/data/services/common_models/base_response.dart';

part 'main_response.g.dart';

@JsonSerializable()
class MainResponse extends BaseResponse {
  MainResponse(super.message, this.success, this.data);

  final MainInfo data;

  final bool? success;

  bool get isSuccess => success ?? true;

  factory MainResponse.fromJson(Map<String, dynamic> json) => _$MainResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainResponseToJson(this);
}

@JsonSerializable()
class MainInfo {
  final WorkoutStats workout;
  final List<DayInfo> schedule;
  final int rating;
  @JsonKey(name: 'level_rating')
  final int levelRating;
  @JsonKey(name: 'season_rating')
  final int seasonRating;
  final String label;

  MainInfo(this.workout, this.schedule, this.rating, this.label, this.levelRating, this.seasonRating);

  factory MainInfo.fromJson(Map<String, dynamic> json) => _$MainInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MainInfoToJson(this);
}

@JsonSerializable()
class DayInfo {
  DayInfo(this.day, this.name, this.isActive);

  final String day;
  final String? name;
  @JsonKey(name: 'active')
  final bool isActive;

  factory DayInfo.fromJson(Map<String, dynamic> json) => _$DayInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DayInfoToJson(this);
}

@JsonSerializable()
class WorkoutStats {
  WorkoutStats(this.month, this.year);

  final int? month;
  final int? year;

  factory WorkoutStats.fromJson(Map<String, dynamic> json) => _$WorkoutStatsFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutStatsToJson(this);
}
