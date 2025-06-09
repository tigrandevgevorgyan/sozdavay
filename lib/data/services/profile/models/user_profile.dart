import 'package:json_annotation/json_annotation.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final int id;
  final String name;
  final String phone;

  // final String? sex;
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

  UserProfile(
    this.records,
    this.measurements,
    this.paidUntil, {
    required this.id,
    required this.name,
    required this.phone,
    required this.category,
    required this.days,
    required this.age,
    required this.experience,
    required this.goal,
    required this.priority,
    required this.planType,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
