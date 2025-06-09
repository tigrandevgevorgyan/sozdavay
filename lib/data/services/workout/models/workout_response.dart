import 'package:json_annotation/json_annotation.dart';
import '../../common_models/base_response.dart';

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

  @JsonKey(name: 'is_double')
  final bool isDouble;

  @JsonKey(name: 'is_complex')
  final bool isComplex;

  @JsonKey(name: 'is_time')
  final bool isTime;

  final List<ExerciseInfo> items;

  WorkoutInfo(this.index, this.isDouble, this.isComplex, this.isTime, this.items);

  factory WorkoutInfo.fromJson(Map<String, dynamic> json) => _$WorkoutInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ExerciseInfo {
  @JsonKey(name: 'item_id')
  final int itemId;

  final int id;
  final String name;
  final String? description;
  final List<VideoInfo> videos;
  final List<SetInfo> sets;

  @JsonKey(name: 'rest_seconds')
  final int restSeconds;

  final List<HistoryInfo> history;

  ExerciseInfo(
    this.itemId,
    this.id,
    this.name,
    this.description,
    this.videos,
    this.sets,
    this.restSeconds,
    this.history,
  );

  String? getFirstVideoLink() {
    return getVideoLinks().firstOrNull;
  }

  List<String> getVideoLinks() {
    List<String> result = [];
    result.addAll(videos.where((video) => video.type == 'other').map((e) => e.url).toList());
    return result;
  }

  factory ExerciseInfo.fromJson(Map<String, dynamic> json) => _$ExerciseInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseInfoToJson(this);
}

@JsonSerializable()
class SetInfo {
  @JsonKey(name: 'sets_count')
  final int? setsCount;

  @JsonKey(name: 'repeats_from')
  final int? repeatsFrom;

  @JsonKey(name: 'repeats_to')
  final int? repeatsTo;

  @JsonKey(name: 'as_much_as_possible')
  final int? asMuchAsPossible;

  SetInfo(this.setsCount, this.repeatsFrom, this.repeatsTo, this.asMuchAsPossible);

  factory SetInfo.fromJson(Map<String, dynamic> json) => _$SetInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SetInfoToJson(this);
}

@JsonSerializable()
class VideoInfo {
  final String url;
  final String type;
  final String? title;

  VideoInfo(this.url, this.type, this.title);

  factory VideoInfo.fromJson(Map<String, dynamic> json) => _$VideoInfoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoInfoToJson(this);
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
  final double weight;
  final int repeats;
  final int difficult;
  final int time;
  final String date;

  ResultValue(this.id, this.weight, this.repeats, this.difficult, this.time, this.date);

  factory ResultValue.fromJson(Map<String, dynamic> json) => _$ResultValueFromJson(json);
  Map<String, dynamic> toJson() => _$ResultValueToJson(this);
}

extension ResultValueCopyWith on ResultValue {
  ResultValue copyWith({
    double? weight,
    int? repeats,
  }) {
    return ResultValue(
      id,
      weight ?? this.weight,
      repeats ?? this.repeats,
      difficult,
      time,
      date
    );
  }
}

