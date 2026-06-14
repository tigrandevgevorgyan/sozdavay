// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clan _$ClanFromJson(Map<String, dynamic> json) => Clan(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      leaderCustomerId: (json['leader_customer_id'] as num?)?.toInt(),
      treasuryBalance: (json['treasury_balance'] as num).toInt(),
      slotsTotal: (json['slots_total'] as num).toInt(),
      slotsUsed: (json['slots_used'] as num?)?.toInt(),
      joinPolicy: json['join_policy'] as String,
      ratingCached: (json['rating_cached'] as num).toInt(),
      isDisabled: json['is_disabled'] as bool,
      myRole: json['my_role'] as String?,
      myMemberId: (json['my_member_id'] as num?)?.toInt(),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => ClanMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeBoosters: (json['active_boosters'] as List<dynamic>?)
          ?.map(
              (e) => ClanBoosterActivation.fromJson(e as Map<String, dynamic>))
          .toList(),
      availableBoosterDefinitions: (json['available_booster_definitions']
              as List<dynamic>?)
          ?.map(
              (e) => ClanBoosterDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
      pendingRequestsCount: (json['pending_requests_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClanToJson(Clan instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'leader_customer_id': instance.leaderCustomerId,
      'treasury_balance': instance.treasuryBalance,
      'slots_total': instance.slotsTotal,
      'slots_used': instance.slotsUsed,
      'join_policy': instance.joinPolicy,
      'rating_cached': instance.ratingCached,
      'is_disabled': instance.isDisabled,
      'my_role': instance.myRole,
      'my_member_id': instance.myMemberId,
      'members': instance.members,
      'active_boosters': instance.activeBoosters,
      'available_booster_definitions': instance.availableBoosterDefinitions,
      'pending_requests_count': instance.pendingRequestsCount,
    };

ClanMember _$ClanMemberFromJson(Map<String, dynamic> json) => ClanMember(
      id: (json['id'] as num).toInt(),
      customerId: (json['customer_id'] as num).toInt(),
      role: json['role'] as String,
      joinedAt: json['joined_at'] as String?,
      totalRatingContributed: (json['total_rating_contributed'] as num).toInt(),
      customer: json['customer'] == null
          ? null
          : ClanMemberCustomer.fromJson(
              json['customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClanMemberToJson(ClanMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer_id': instance.customerId,
      'role': instance.role,
      'joined_at': instance.joinedAt,
      'total_rating_contributed': instance.totalRatingContributed,
      'customer': instance.customer,
    };

ClanMemberCustomer _$ClanMemberCustomerFromJson(Map<String, dynamic> json) =>
    ClanMemberCustomer(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$ClanMemberCustomerToJson(ClanMemberCustomer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
    };

ClanBoosterDefinition _$ClanBoosterDefinitionFromJson(
        Map<String, dynamic> json) =>
    ClanBoosterDefinition(
      id: (json['id'] as num).toInt(),
      key: json['key'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      effectType: json['effect_type'] as String,
      effectValue: (json['effect_value'] as num).toDouble(),
      durationHours: (json['duration_hours'] as num).toInt(),
      cardCostRating: (json['card_cost_rating'] as num).toInt(),
      activationCostRating: (json['activation_cost_rating'] as num).toInt(),
      maxLevel: (json['max_level'] as num).toInt(),
    );

Map<String, dynamic> _$ClanBoosterDefinitionToJson(
        ClanBoosterDefinition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'effect_type': instance.effectType,
      'effect_value': instance.effectValue,
      'duration_hours': instance.durationHours,
      'card_cost_rating': instance.cardCostRating,
      'activation_cost_rating': instance.activationCostRating,
      'max_level': instance.maxLevel,
    };

ClanBoosterActivation _$ClanBoosterActivationFromJson(
        Map<String, dynamic> json) =>
    ClanBoosterActivation(
      id: (json['id'] as num).toInt(),
      boosterCardId: (json['booster_card_id'] as num).toInt(),
      activatedAt: json['activated_at'] as String?,
      expiresAt: json['expires_at'] as String?,
      costPaidRating: (json['cost_paid_rating'] as num).toInt(),
    );

Map<String, dynamic> _$ClanBoosterActivationToJson(
        ClanBoosterActivation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booster_card_id': instance.boosterCardId,
      'activated_at': instance.activatedAt,
      'expires_at': instance.expiresAt,
      'cost_paid_rating': instance.costPaidRating,
    };

ClanJoinRequest _$ClanJoinRequestFromJson(Map<String, dynamic> json) =>
    ClanJoinRequest(
      id: (json['id'] as num).toInt(),
      customerId: (json['customer_id'] as num).toInt(),
      createdAt: json['created_at'] as String?,
      customer: json['customer'] == null
          ? null
          : ClanMemberCustomer.fromJson(
              json['customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClanJoinRequestToJson(ClanJoinRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer_id': instance.customerId,
      'created_at': instance.createdAt,
      'customer': instance.customer,
    };

ClansListResponse _$ClansListResponseFromJson(Map<String, dynamic> json) =>
    ClansListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Clan.fromJson(e as Map<String, dynamic>))
          .toList(),
      featureEnabled: json['feature_enabled'] as bool?,
    );

Map<String, dynamic> _$ClansListResponseToJson(ClansListResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'feature_enabled': instance.featureEnabled,
    };

ClanResponse _$ClanResponseFromJson(Map<String, dynamic> json) => ClanResponse(
      data: json['data'] == null
          ? null
          : Clan.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClanResponseToJson(ClanResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
