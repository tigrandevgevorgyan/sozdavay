// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferralInfo _$ReferralInfoFromJson(Map<String, dynamic> json) => ReferralInfo(
      code: json['code'] as String?,
      inviteesCount: (json['invitees_count'] as num).toInt(),
      invitees: (json['invitees'] as List<dynamic>)
          .map((e) => ReferralInvitee.fromJson(e as Map<String, dynamic>))
          .toList(),
      referrer: json['referrer'] == null
          ? null
          : ReferralReferrer.fromJson(json['referrer'] as Map<String, dynamic>),
      featureEnabled: json['feature_enabled'] as bool?,
    );

Map<String, dynamic> _$ReferralInfoToJson(ReferralInfo instance) =>
    <String, dynamic>{
      'code': instance.code,
      'invitees_count': instance.inviteesCount,
      'invitees': instance.invitees,
      'referrer': instance.referrer,
      'feature_enabled': instance.featureEnabled,
    };

ReferralInvitee _$ReferralInviteeFromJson(Map<String, dynamic> json) =>
    ReferralInvitee(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      joinedAt: json['joined_at'] as String?,
    );

Map<String, dynamic> _$ReferralInviteeToJson(ReferralInvitee instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'joined_at': instance.joinedAt,
    };

ReferralReferrer _$ReferralReferrerFromJson(Map<String, dynamic> json) =>
    ReferralReferrer(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$ReferralReferrerToJson(ReferralReferrer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
    };

ReferralResponse _$ReferralResponseFromJson(Map<String, dynamic> json) =>
    ReferralResponse(
      data: ReferralInfo.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReferralResponseToJson(ReferralResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
