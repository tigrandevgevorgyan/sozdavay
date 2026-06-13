import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'models/achievement.dart';
import 'models/avatar_frame.dart';
import 'models/battle_pass.dart';
import 'models/clan.dart';
import 'models/notification.dart';
import 'models/rating_balance_response.dart';
import 'models/referral.dart';
import 'models/season_current.dart';
import 'models/shop_product.dart';

part 'gamification_service.g.dart';

/// Retrofit interface for the Stream A gamification endpoints (backend
/// mobile-api(1)–(5)). Lean DTOs — only the fields the mobile UI consumes.
///
/// **Important**: after editing this file run:
///   `dart run build_runner build --delete-conflicting-outputs`
/// to regenerate `gamification_service.g.dart`.
@RestApi()
abstract class GamificationService {
  factory GamificationService(Dio dio, {String? baseUrl}) = _GamificationService;

  // ------ Rating ------
  @GET('/rating/balance')
  Future<RatingBalanceResponse> getRatingBalance();

  // ------ Achievements ------
  @GET('/achievements')
  Future<AchievementsListResponse> getAchievements();

  @GET('/achievements/mine')
  Future<MyAchievementsResponse> getMyAchievements();

  @POST('/achievements/expedition/{id}/join')
  Future<dynamic> joinExpedition(@Path('id') int achievementId);

  @POST('/achievements/expedition/{id}/abandon')
  Future<dynamic> abandonExpedition(@Path('id') int achievementId);

  @GET('/achievements/{id}/share-payload')
  Future<dynamic> getAchievementSharePayload(@Path('id') int achievementId);

  // ------ Clans ------
  @GET('/clans')
  Future<ClansListResponse> getClans(@Query('q') String? search);

  @GET('/clans/mine')
  Future<ClanResponse> getMyClan();

  @GET('/clans/{id}')
  Future<ClanResponse> getClan(@Path('id') int clanId);

  @POST('/clans')
  Future<ClanResponse> createClan(
    @Field('name') String name,
    @Field('description') String? description,
    @Field('join_policy') String joinPolicy,
  );

  @POST('/clans/{id}/join')
  Future<dynamic> joinClan(@Path('id') int clanId);

  @POST('/clans/{id}/leave')
  Future<dynamic> leaveClan(@Path('id') int clanId);

  @POST('/clans/{id}/treasury/contribute')
  Future<dynamic> contributeToTreasury(
    @Path('id') int clanId,
    @Field('amount') int amount,
  );

  @POST('/clans/{id}/boosters/purchase')
  Future<dynamic> buyBoosterCard(
    @Path('id') int clanId,
    @Field('booster_definition_id') int definitionId,
  );

  @POST('/clans/{id}/boosters/{cardId}/activate')
  Future<dynamic> activateBooster(
    @Path('id') int clanId,
    @Path('cardId') int cardId,
  );

  // ------ Shop ------
  @GET('/shop/products')
  Future<ShopProductsResponse> getShopProducts();

  @POST('/shop/purchase')
  Future<PurchaseResponse> purchaseProduct(@Field('product_id') int productId);

  @GET('/shop/frames')
  Future<MyFramesResponse> getMyFrames();

  @POST('/profile/equip-frame')
  Future<dynamic> equipFrame(@Field('avatar_frame_definition_id') int? definitionId);

  @GET('/shop/battle-pass')
  Future<BattlePassResponse> getBattlePass();

  @POST('/shop/battle-pass/claim')
  Future<dynamic> claimBattlePassTier(
    @Field('tier_id') int tierId,
    @Field('track') String track,
  );

  // ------ Notifications ------
  @GET('/notifications')
  Future<NotificationsResponse> getNotifications(@Query('only_unread') int? onlyUnread);

  @POST('/notifications/{id}/read')
  Future<dynamic> markNotificationRead(@Path('id') int notificationId);

  @POST('/notifications/read-all')
  Future<dynamic> markAllNotificationsRead();

  @GET('/notifications/preferences')
  Future<NotificationPreferencesResponse> getNotificationPreferences();

  @POST('/notifications/preferences')
  Future<dynamic> setNotificationPreference(
    @Field('channel') String channel,
    @Field('type') String type,
    @Field('enabled') bool enabled,
  );

  // ------ Season ------
  @GET('/season/current')
  Future<SeasonCurrentResponse> getCurrentSeason();

  // ------ Referrals ------
  @GET('/referrals/me')
  Future<ReferralResponse> getMyReferralInfo();
}
