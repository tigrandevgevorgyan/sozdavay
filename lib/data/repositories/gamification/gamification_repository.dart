import 'package:level_up/data/services/gamification/gamification_service.dart';
import 'package:level_up/data/services/gamification/models/achievement.dart';
import 'package:level_up/data/services/gamification/models/avatar_frame.dart';
import 'package:level_up/data/services/gamification/models/battle_pass.dart';
import 'package:level_up/data/services/gamification/models/clan.dart';
import 'package:level_up/data/services/gamification/models/notification.dart';
import 'package:level_up/data/services/gamification/models/rating_balance_response.dart';
import 'package:level_up/data/services/gamification/models/referral.dart';
import 'package:level_up/data/services/gamification/models/season_current.dart';
import 'package:level_up/data/services/gamification/models/shop_product.dart';

abstract class IGamificationRepository {
  Future<RatingBalanceData> getRatingBalance();

  // achievements
  Future<List<Achievement>> getAchievements();
  Future<List<CustomerAchievement>> getMyAchievements();
  Future<void> joinExpedition(int achievementId);
  Future<void> abandonExpedition(int achievementId);
  Future<Map<String, dynamic>?> getAchievementSharePayload(int achievementId);

  // clans
  Future<List<Clan>> getClans({String? search});
  Future<Clan?> getMyClan();
  Future<Clan?> getClan(int clanId);
  Future<Clan?> createClan({required String name, String? description, String joinPolicy = 'open'});
  Future<void> joinClan(int clanId);
  Future<void> leaveClan(int clanId);
  Future<void> contributeToTreasury(int clanId, int amount);
  Future<void> buyBoosterCard(int clanId, int definitionId);
  Future<void> activateBooster(int clanId, int cardId);

  // shop
  Future<List<ShopProduct>> getShopProducts();
  Future<void> purchaseProduct(int productId);
  Future<List<CustomerAvatarFrame>> getMyFrames();
  Future<void> equipFrame(int? avatarFrameDefinitionId);
  Future<BattlePass?> getBattlePass();
  Future<void> claimBattlePassTier({required int tierId, required String track});

  // notifications
  Future<NotificationsResponse> getNotifications({bool onlyUnread = false});
  Future<void> markNotificationRead(int notificationId);
  Future<void> markAllNotificationsRead();
  Future<NotificationPreferencesResponse> getNotificationPreferences();
  Future<void> setNotificationPreference({
    required String channel,
    required String type,
    required bool enabled,
  });

  // season & referrals
  Future<SeasonCurrent?> getCurrentSeason();
  Future<ReferralInfo> getMyReferralInfo();
}

class GamificationRepository implements IGamificationRepository {
  GamificationRepository(this._service);

  final GamificationService _service;

  @override
  Future<RatingBalanceData> getRatingBalance() async {
    final r = await _service.getRatingBalance();
    return r.data;
  }

  @override
  Future<List<Achievement>> getAchievements() async {
    final r = await _service.getAchievements();
    return r.data;
  }

  @override
  Future<List<CustomerAchievement>> getMyAchievements() async {
    final r = await _service.getMyAchievements();
    return r.data;
  }

  @override
  Future<void> joinExpedition(int achievementId) =>
      _service.joinExpedition(achievementId);

  @override
  Future<void> abandonExpedition(int achievementId) =>
      _service.abandonExpedition(achievementId);

  @override
  Future<Map<String, dynamic>?> getAchievementSharePayload(int achievementId) async {
    final raw = await _service.getAchievementSharePayload(achievementId);
    if (raw is Map<String, dynamic>) {
      final data = raw['data'];
      if (data is Map<String, dynamic>) return data;
    }
    return null;
  }

  @override
  Future<List<Clan>> getClans({String? search}) async {
    final r = await _service.getClans(search);
    return r.data;
  }

  @override
  Future<Clan?> getMyClan() async {
    final r = await _service.getMyClan();
    return r.data;
  }

  @override
  Future<Clan?> getClan(int clanId) async {
    final r = await _service.getClan(clanId);
    return r.data;
  }

  @override
  Future<Clan?> createClan({
    required String name,
    String? description,
    String joinPolicy = 'open',
  }) async {
    final r = await _service.createClan(name, description, joinPolicy);
    return r.data;
  }

  @override
  Future<void> joinClan(int clanId) => _service.joinClan(clanId);

  @override
  Future<void> leaveClan(int clanId) => _service.leaveClan(clanId);

  @override
  Future<void> contributeToTreasury(int clanId, int amount) =>
      _service.contributeToTreasury(clanId, amount);

  @override
  Future<void> buyBoosterCard(int clanId, int definitionId) =>
      _service.buyBoosterCard(clanId, definitionId);

  @override
  Future<void> activateBooster(int clanId, int cardId) =>
      _service.activateBooster(clanId, cardId);

  @override
  Future<List<ShopProduct>> getShopProducts() async {
    final r = await _service.getShopProducts();
    return r.data;
  }

  @override
  Future<void> purchaseProduct(int productId) =>
      _service.purchaseProduct(productId);

  @override
  Future<List<CustomerAvatarFrame>> getMyFrames() async {
    final r = await _service.getMyFrames();
    return r.data;
  }

  @override
  Future<void> equipFrame(int? avatarFrameDefinitionId) =>
      _service.equipFrame(avatarFrameDefinitionId);

  @override
  Future<BattlePass?> getBattlePass() async {
    final r = await _service.getBattlePass();
    return r.data;
  }

  @override
  Future<void> claimBattlePassTier({required int tierId, required String track}) =>
      _service.claimBattlePassTier(tierId, track);

  @override
  Future<NotificationsResponse> getNotifications({bool onlyUnread = false}) =>
      _service.getNotifications(onlyUnread ? 1 : null);

  @override
  Future<void> markNotificationRead(int notificationId) =>
      _service.markNotificationRead(notificationId);

  @override
  Future<void> markAllNotificationsRead() =>
      _service.markAllNotificationsRead();

  @override
  Future<NotificationPreferencesResponse> getNotificationPreferences() =>
      _service.getNotificationPreferences();

  @override
  Future<void> setNotificationPreference({
    required String channel,
    required String type,
    required bool enabled,
  }) =>
      _service.setNotificationPreference(channel, type, enabled);

  @override
  Future<SeasonCurrent?> getCurrentSeason() async {
    final r = await _service.getCurrentSeason();
    return r.data;
  }

  @override
  Future<ReferralInfo> getMyReferralInfo() async {
    final r = await _service.getMyReferralInfo();
    return r.data;
  }
}
