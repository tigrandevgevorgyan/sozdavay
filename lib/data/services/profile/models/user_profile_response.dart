import 'package:json_annotation/json_annotation.dart';
import 'package:level_up/data/services/common_models/base_response.dart';
import 'package:level_up/data/services/profile/models/user_profile.dart';

part 'user_profile_response.g.dart';

@JsonSerializable()
class UserProfileShortResponse extends BaseResponse {
  UserProfileShortResponse(super.message, this.data);

  final UserProfile data;

  factory UserProfileShortResponse.fromJson(Map<String, dynamic> json) => _$UserProfileShortResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileShortResponseToJson(this);
}

@JsonSerializable()
class UserProfileExtendedResponse extends BaseResponse {
  UserProfileExtendedResponse(super.message, this.data, this.ages, this.experiences, this.goals, this.days, this.priorities);

  UserProfile data;
  final List<IdNamePairWithPriority> ages;
  final List<IdNamePairWithPriority> experiences;
  final List<IdNamePairWithPriority> goals;
  @DaysConverter()
  final List<IdNamePairWithPriority> days;
  @JsonKey(name: 'priorites')
  final List<IdNamePairWithPriority> priorities;

  factory UserProfileExtendedResponse.fromJson(Map<String, dynamic> json) => _$UserProfileExtendedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileExtendedResponseToJson(this);
}

@JsonSerializable()
class IdNamePairWithPriority {
  final int id;
  final String name;
  @JsonKey(name: 'available_priority')
  final bool? isPriorityAvailable;

  IdNamePairWithPriority(
    this.isPriorityAvailable,
    this.id,
    this.name,
  );

  factory IdNamePairWithPriority.fromJson(Map<String, dynamic> json) => _$IdNamePairWithPriorityFromJson(json);

  Map<String, dynamic> toJson() => _$IdNamePairWithPriorityToJson(this);
}

class DaysConverter implements JsonConverter<List<IdNamePairWithPriority>, List<dynamic>> {
  const DaysConverter();

  @override
  List<IdNamePairWithPriority> fromJson(List<dynamic> json) => json.map((day) => IdNamePairWithPriority(false, day, '$day тренировки')).toList();

  @override
  List<int> toJson(List<IdNamePairWithPriority> object) => object.map((o) => o.id).toList();
}
