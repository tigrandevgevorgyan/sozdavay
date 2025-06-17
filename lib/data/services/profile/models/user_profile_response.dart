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
  UserProfileExtendedResponse(super.message, this.data, this.experiences, this.goals, this.days, this.priorities, this.categories, this.availablePriority);

  UserProfile data;
  final List<IdNamePairWithPriority> experiences;
  final List<GoalWithPriorities> goals;
  @DaysConverter()
  final List<IdNamePairWithPriority> days;
  @JsonKey(name: 'available_priority')
  final bool? availablePriority;
  @JsonKey(name: 'priorites')
  final List<IdNamePairWithPriority> priorities;
  final List<IdNamePairWithPriority> categories;

  factory UserProfileExtendedResponse.fromJson(Map<String, dynamic> json) => _$UserProfileExtendedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileExtendedResponseToJson(this);
}

@JsonSerializable()
class GoalWithPriorities {
  final int id;
  final String name;

  @JsonKey(name: 'available_priority')
  final bool? isPriorityAvailable;

  final List<int> priorities;

  GoalWithPriorities(this.id, this.name, this.isPriorityAvailable, this.priorities);

  factory GoalWithPriorities.fromJson(Map<String, dynamic> json) => _$GoalWithPrioritiesFromJson(json);
  Map<String, dynamic> toJson() => _$GoalWithPrioritiesToJson(this);
}

@JsonSerializable()
class IdNamePairWithPriority {
  final int id;
  final String name;
  @JsonKey(name: 'available_priority')
  final bool? isPriorityAvailable;

  IdNamePairWithPriority(this.id, this.name, {this.isPriorityAvailable});


  factory IdNamePairWithPriority.fromJson(Map<String, dynamic> json) => _$IdNamePairWithPriorityFromJson(json);

  Map<String, dynamic> toJson() => _$IdNamePairWithPriorityToJson(this);
}

class DaysConverter implements JsonConverter<List<IdNamePairWithPriority>, List<dynamic>> {
  const DaysConverter();

  @override
  List<IdNamePairWithPriority> fromJson(List<dynamic> json) => json.map((day) => IdNamePairWithPriority(day, '$day тренировки')).toList();

  @override
  List<int> toJson(List<IdNamePairWithPriority> object) => object.map((o) => o.id).toList();
}
