import 'package:json_annotation/json_annotation.dart';
import 'package:level_up/data/services/profile/models/user_profile.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';

import '../../common_models/base_response.dart';

part 'rating_response.g.dart';

@JsonSerializable()
class RatingResponse extends BaseResponse {
  RatingResponse(super.message, this.data, this.rating, this.categories, this.periods);

  final UserProfile data;
  final List<UserRating> rating;
  final List<IdNamePairWithPriority> categories;
  final List<IdLabelPairWithPriority> periods;

  factory RatingResponse.fromJson(Map<String, dynamic> json) => _$RatingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RatingResponseToJson(this);
}

@JsonSerializable()
class UserRating {
  UserRating(this.userId, this.name, this.totalRating, this.label);

  @JsonKey(name: 'customer_id')
  final int userId;
  final String name;
  @JsonKey(name: 'total_rating')
  final int totalRating;
  final String label;

  factory UserRating.fromJson(Map<String, dynamic> json) => _$UserRatingFromJson(json);

  Map<String, dynamic> toJson() => _$UserRatingToJson(this);
}

@JsonSerializable()
class IdLabelPairWithPriority {
  final int id;
  final String label;

  IdLabelPairWithPriority(
    this.id,
    this.label,
  );

  factory IdLabelPairWithPriority.fromJson(Map<String, dynamic> json) => _$IdLabelPairWithPriorityFromJson(json);

  Map<String, dynamic> toJson() => _$IdLabelPairWithPriorityToJson(this);

  IdNamePairWithPriority toIdNamePair() {
    return IdNamePairWithPriority(false, id, label);
  }
}
