import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/brand/brand_config.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/gamification/models/achievement.dart';
import 'package:level_up/data/services/gamification/models/rating_level_summary.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/data/services/profile/models/user_profile.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/profile_preferences/view_model/profile_preferences_view_model.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';
import 'package:url_launcher/url_launcher.dart';

/// Drives the new Profile view screen (the gamification hub introduced in
/// mobile-ui(3)). Pulls cached profile data via [IProfileRepository] — does
/// not issue its own /profile call, since HomeViewModel has already loaded it.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required this.profileRepository, required this.hasWorkoutPlan}) {
    _load();
  }

  final IProfileRepository profileRepository;
  final bool hasWorkoutPlan;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  UserProfile? _profile;
  UserProfile? get profile => _profile;

  RatingLevelSummary? get ratingLevel => _profile?.ratingLevel;

  String get displayName => _profile?.displayName ?? '';

  String? get avatarUrl => _profile?.avatarUrl;

  int get creatorPoints => _profile?.creatorPoints ?? 0;

  /// Top-3 most-recently granted achievements — used for the preview row
  /// on Profile (Figma 42:1369). Loaded in parallel with the profile body.
  List<CustomerAchievement> _topAchievements = [];
  List<CustomerAchievement> get topAchievements => _topAchievements;

  Future<void> _load() async {
    // Profile (cached) + my achievements run in parallel — both are cheap
    // and the screen doesn't depend on the order they resolve.
    final results = await Future.wait([
      profileRepository.getProfile(),
      _safeLoadAchievements(),
    ]);
    final profileResult = results[0] as Result<UserProfileExtendedResponse>;
    switch (profileResult) {
      case Ok<UserProfileExtendedResponse>():
        _profile = profileResult.value.data;
      case Error<UserProfileExtendedResponse>():
        break;
    }
    _topAchievements = results[1] as List<CustomerAchievement>;
    _isLoading = false;
    notifyListeners();
  }

  Future<List<CustomerAchievement>> _safeLoadAchievements() async {
    try {
      final list = await GetIt.I<IGamificationRepository>().getMyAchievements();
      return list.take(3).toList();
    } catch (_) {
      return [];
    }
  }

  void onEditProfileTap(BuildContext context) {
    GoRouter.of(context).push(
      LevelUpRouter.homePath + LevelUpRouter.profilePreferencesPath,
      extra: ProfilePreferencesParams(
        hasWorkoutPlan: hasWorkoutPlan,
        isFirstLogin: false,
        isAfterLogin: false,
      ),
    ).then((_) => _load());
  }

  void onAchievementsTap(BuildContext context) =>
      GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.achievementsPath);

  void onClansTap(BuildContext context) =>
      GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.clansPath);

  void onShopTap(BuildContext context) =>
      GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.shopPath);

  void onFramesTap(BuildContext context) =>
      GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.framesPath);

  void onBattlePassTap(BuildContext context) =>
      GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.battlePassPath);

  void onReferralsTap(BuildContext context) =>
      GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.referralsPath);

  void onSeasonTap(BuildContext context) =>
      GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.seasonPath);

  void onNotificationsInboxTap(BuildContext context) =>
      GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.notificationsPath);

  void onNotificationPrefsTap(BuildContext context) =>
      GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.notificationPrefsPath);

  Future<void> onSupportTap() async {
    final uri = GetIt.I<BrandConfig>().coachChatUrl;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Logs the customer out and returns to the sign-in screen.
  ///
  /// Logout was originally in the Home AppBar (logout icon) but moved here
  /// when that slot was repurposed for the notification bell. Same cleanup as
  /// the old path: clear local storage, drop cached profile, cancel pending
  /// local notifications, then route to /signin.
  Future<void> onLogoutTap(BuildContext context) async {
    final result = await GetIt.I<IAuthRepository>().logout();
    switch (result) {
      case Ok<void>():
        GetIt.I<IProfileRepository>().onLogout();
        try {
          await GetIt.I<ILocalStorage>().clearSharedPreferences();
          await FlutterLocalNotificationsPlugin().cancelAll();
        } catch (_) {}
        if (context.mounted) {
          GoRouter.of(context).go(LevelUpRouter.signInPath);
        }
      case Error<void>():
        if (context.mounted) {
          ErrorUtils.showError(context, 'Не удаётся выйти из профиля');
        }
    }
  }
}
