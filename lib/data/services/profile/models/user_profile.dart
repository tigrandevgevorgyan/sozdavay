import 'package:json_annotation/json_annotation.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/data/services/gamification/models/rating_level_summary.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final int id;
  final String name;
  @JsonKey(name: 'sex')
  final int? sex;

  final String phone;
  final int? days;
  final IdNamePairWithPriority? category;
  final IdNamePairWithPriority? age;
  final IdNamePairWithPriority? experience;
  final IdNamePairWithPriority? goal;
  final IdNamePairWithPriority? priority;
  final String? records;
  final String? measurements;
  @JsonKey(name: 'paid_until')
  final String? paidUntil;
  @JsonKey(name: 'plan_type')
  final int planType;

  // --- Gamification fields (added in mobile-api(1) on the backend) ---
  // All nullable so the model still parses against pre-gamification API
  // responses without throwing.
  final String? nickname;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'equipped_avatar_frame_id')
  final int? equippedAvatarFrameId;
  @JsonKey(name: 'creator_points')
  final int? creatorPoints;
  @JsonKey(name: 'account_level')
  final int? accountLevel;
  @JsonKey(name: 'shop_discount_percent')
  final int? shopDiscountPercent;
  @JsonKey(name: 'rating_balance')
  final int? ratingBalance;
  @JsonKey(name: 'rating_level')
  final RatingLevelSummary? ratingLevel;
  @JsonKey(name: 'referral_code')
  final String? referralCode;

  UserProfile(
    this.records,
    this.measurements,
    this.paidUntil, {
    required this.id,
    required this.name,
    this.sex,
    required this.phone,
    required this.category,
    required this.days,
    required this.age,
    required this.experience,
    required this.goal,
    required this.priority,
    required this.planType,
    this.nickname,
    this.avatarUrl,
    this.equippedAvatarFrameId,
    this.creatorPoints,
    this.accountLevel,
    this.shopDiscountPercent,
    this.ratingBalance,
    this.ratingLevel,
    this.referralCode,
  });

  /// Convenience getter — returns nickname if set, otherwise the legacy `name`.
  String get displayName =>
      (nickname != null && nickname!.isNotEmpty) ? nickname! : name;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
