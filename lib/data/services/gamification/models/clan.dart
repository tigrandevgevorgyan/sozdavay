import 'package:json_annotation/json_annotation.dart';

part 'clan.g.dart';

/// Mirrors `ClanResource` (two-tier — summary + detail).
@JsonSerializable()
class Clan {
  final int id;
  final String name;
  final String? description;
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @JsonKey(name: 'leader_customer_id')
  final int? leaderCustomerId;
  @JsonKey(name: 'treasury_balance')
  final int treasuryBalance;
  @JsonKey(name: 'slots_total')
  final int slotsTotal;
  @JsonKey(name: 'slots_used')
  final int? slotsUsed;
  @JsonKey(name: 'join_policy')
  final String joinPolicy;
  @JsonKey(name: 'rating_cached')
  final int ratingCached;
  @JsonKey(name: 'is_disabled')
  final bool isDisabled;
  @JsonKey(name: 'my_role')
  final String? myRole;
  @JsonKey(name: 'my_member_id')
  final int? myMemberId;
  final List<ClanMember>? members;
  @JsonKey(name: 'active_boosters')
  final List<ClanBoosterActivation>? activeBoosters;
  @JsonKey(name: 'available_booster_definitions')
  final List<ClanBoosterDefinition>? availableBoosterDefinitions;
  @JsonKey(name: 'pending_requests_count')
  final int? pendingRequestsCount;

  Clan({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    this.leaderCustomerId,
    required this.treasuryBalance,
    required this.slotsTotal,
    this.slotsUsed,
    required this.joinPolicy,
    required this.ratingCached,
    required this.isDisabled,
    this.myRole,
    this.myMemberId,
    this.members,
    this.activeBoosters,
    this.availableBoosterDefinitions,
    this.pendingRequestsCount,
  });

  bool get isLeader => myRole == 'leader';
  bool get isMember => myRole != null;

  factory Clan.fromJson(Map<String, dynamic> json) => _$ClanFromJson(json);
  Map<String, dynamic> toJson() => _$ClanToJson(this);
}

@JsonSerializable()
class ClanMember {
  final int id;
  @JsonKey(name: 'customer_id')
  final int customerId;
  final String role;
  @JsonKey(name: 'joined_at')
  final String? joinedAt;
  @JsonKey(name: 'total_rating_contributed')
  final int totalRatingContributed;
  final ClanMemberCustomer? customer;

  ClanMember({
    required this.id,
    required this.customerId,
    required this.role,
    this.joinedAt,
    required this.totalRatingContributed,
    this.customer,
  });

  factory ClanMember.fromJson(Map<String, dynamic> json) =>
      _$ClanMemberFromJson(json);
  Map<String, dynamic> toJson() => _$ClanMemberToJson(this);
}

@JsonSerializable()
class ClanMemberCustomer {
  final int id;
  final String? name;
  final String? nickname;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  ClanMemberCustomer({required this.id, this.name, this.nickname, this.avatarUrl});

  String get displayName =>
      (nickname != null && nickname!.isNotEmpty) ? nickname! : (name ?? '');

  factory ClanMemberCustomer.fromJson(Map<String, dynamic> json) =>
      _$ClanMemberCustomerFromJson(json);
  Map<String, dynamic> toJson() => _$ClanMemberCustomerToJson(this);
}

@JsonSerializable()
class ClanBoosterDefinition {
  final int id;
  final String key;
  final String name;
  final String? description;
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @JsonKey(name: 'effect_type')
  final String effectType;
  @JsonKey(name: 'effect_value')
  final double effectValue;
  @JsonKey(name: 'duration_hours')
  final int durationHours;
  @JsonKey(name: 'card_cost_rating')
  final int cardCostRating;
  @JsonKey(name: 'activation_cost_rating')
  final int activationCostRating;
  @JsonKey(name: 'max_level')
  final int maxLevel;

  ClanBoosterDefinition({
    required this.id,
    required this.key,
    required this.name,
    this.description,
    this.iconUrl,
    required this.effectType,
    required this.effectValue,
    required this.durationHours,
    required this.cardCostRating,
    required this.activationCostRating,
    required this.maxLevel,
  });

  factory ClanBoosterDefinition.fromJson(Map<String, dynamic> json) =>
      _$ClanBoosterDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$ClanBoosterDefinitionToJson(this);
}

@JsonSerializable()
class ClanBoosterActivation {
  final int id;
  @JsonKey(name: 'booster_card_id')
  final int boosterCardId;
  @JsonKey(name: 'activated_at')
  final String? activatedAt;
  @JsonKey(name: 'expires_at')
  final String? expiresAt;
  @JsonKey(name: 'cost_paid_rating')
  final int costPaidRating;

  ClanBoosterActivation({
    required this.id,
    required this.boosterCardId,
    this.activatedAt,
    this.expiresAt,
    required this.costPaidRating,
  });

  factory ClanBoosterActivation.fromJson(Map<String, dynamic> json) =>
      _$ClanBoosterActivationFromJson(json);
  Map<String, dynamic> toJson() => _$ClanBoosterActivationToJson(this);
}

@JsonSerializable()
class ClansListResponse {
  final List<Clan> data;
  @JsonKey(name: 'feature_enabled')
  final bool? featureEnabled;

  ClansListResponse({required this.data, this.featureEnabled});

  factory ClansListResponse.fromJson(Map<String, dynamic> json) =>
      _$ClansListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClansListResponseToJson(this);
}

@JsonSerializable()
class ClanResponse {
  final Clan? data;

  ClanResponse({this.data});

  factory ClanResponse.fromJson(Map<String, dynamic> json) =>
      _$ClanResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClanResponseToJson(this);
}
