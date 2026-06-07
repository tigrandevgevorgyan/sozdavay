import 'package:json_annotation/json_annotation.dart';

part 'referral.g.dart';

@JsonSerializable()
class ReferralInfo {
  final String? code;
  @JsonKey(name: 'invitees_count')
  final int inviteesCount;
  final List<ReferralInvitee> invitees;
  final ReferralReferrer? referrer;
  @JsonKey(name: 'feature_enabled')
  final bool? featureEnabled;

  ReferralInfo({
    this.code,
    required this.inviteesCount,
    required this.invitees,
    this.referrer,
    this.featureEnabled,
  });

  factory ReferralInfo.fromJson(Map<String, dynamic> json) =>
      _$ReferralInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ReferralInfoToJson(this);
}

@JsonSerializable()
class ReferralInvitee {
  final int id;
  final String? name;
  final String? nickname;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'joined_at')
  final String? joinedAt;

  ReferralInvitee({
    required this.id,
    this.name,
    this.nickname,
    this.avatarUrl,
    this.joinedAt,
  });

  String get displayName =>
      (nickname != null && nickname!.isNotEmpty) ? nickname! : (name ?? '');

  factory ReferralInvitee.fromJson(Map<String, dynamic> json) =>
      _$ReferralInviteeFromJson(json);
  Map<String, dynamic> toJson() => _$ReferralInviteeToJson(this);
}

@JsonSerializable()
class ReferralReferrer {
  final int id;
  final String? name;
  final String? nickname;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  ReferralReferrer({
    required this.id,
    this.name,
    this.nickname,
    this.avatarUrl,
  });

  String get displayName =>
      (nickname != null && nickname!.isNotEmpty) ? nickname! : (name ?? '');

  factory ReferralReferrer.fromJson(Map<String, dynamic> json) =>
      _$ReferralReferrerFromJson(json);
  Map<String, dynamic> toJson() => _$ReferralReferrerToJson(this);
}

@JsonSerializable()
class ReferralResponse {
  final ReferralInfo data;

  ReferralResponse({required this.data});

  factory ReferralResponse.fromJson(Map<String, dynamic> json) =>
      _$ReferralResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReferralResponseToJson(this);
}
