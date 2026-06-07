import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/ui/home/widgets/home_screen.dart';
import 'package:level_up/ui/achievements/widgets/achievements_screen.dart';
import 'package:level_up/ui/clans/widgets/clan_detail_screen.dart';
import 'package:level_up/ui/clans/widgets/clans_list_screen.dart';
import 'package:level_up/ui/clans/widgets/create_clan_screen.dart';
import 'package:level_up/ui/notifications/widgets/notification_prefs_screen.dart';
import 'package:level_up/ui/notifications/widgets/notifications_screen.dart';
import 'package:level_up/ui/profile/widgets/profile_screen.dart';
import 'package:level_up/ui/profile_preferences/widgets/profile_preferences_screen.dart';
import 'package:level_up/ui/rating/widgets/rating_screen.dart';
import 'package:level_up/ui/referrals/widgets/referrals_screen.dart';
import 'package:level_up/ui/season/widgets/season_screen.dart';
import 'package:level_up/ui/shop/widgets/battle_pass_screen.dart';
import 'package:level_up/ui/shop/widgets/frames_screen.dart';
import 'package:level_up/ui/shop/widgets/shop_screen.dart';
import 'package:level_up/ui/signin/widgets/signin_screen.dart';
import 'package:level_up/ui/splash/widgets/splash_screen.dart';
import 'package:level_up/ui/text_editing_screen/text_editing_screen.dart';
import 'package:level_up/ui/workout/screens/video_player_screen.dart';
import 'package:level_up/ui/workout/screens/workout_base_screen.dart';
import '../ui/profile_preferences/view_model/profile_preferences_view_model.dart';
import 'package:level_up/ui/register/widgets/register_screen.dart';

class LevelUpRouter {
  static final LevelUpRouter _instance = LevelUpRouter._internal();

  static LevelUpRouter get instance => _instance;

  static late final GoRouter router;

  static const String splashPath = '/';
  static const String signInPath = '/signin';
  static const String profilePath = '/profile';
  static const String profilePreferencesPath = '/profile_preferences';
  static const String homePath = '/home';
  static const String workoutPath = '/workout';
  static const String ratingPath = '/rating';
  static const String textEditingPath = '/text_editing';
  static const String videoPlayerPath = '/video_player';
  static const String registerPath = '/register';
  static const String achievementsPath = '/achievements';
  static const String notificationsPath = '/notifications';
  static const String notificationPrefsPath = '/notification_prefs';
  static const String clansPath = '/clans';
  static const String clanDetailPath = '/clan_detail';
  static const String createClanPath = '/create_clan';
  static const String shopPath = '/shop';
  static const String framesPath = '/frames';
  static const String battlePassPath = '/battle_pass';
  static const String referralsPath = '/referrals';
  static const String seasonPath = '/season';

  late GlobalKey<NavigatorState> navigatorKey;

  BuildContext get context => router.routerDelegate.navigatorKey.currentContext!;

  GoRouterDelegate get routerDelegate => router.routerDelegate;

  GoRouteInformationParser get routeInformationParser => router.routeInformationParser;

  static final GlobalKey<NavigatorState> parentNavigatorKey = GlobalKey<NavigatorState>();

  void initGlobalKey() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  LevelUpRouter._internal() {
    final routes = [
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: splashPath,
        pageBuilder: (context, state) {
          return getPage(
            child: const SplashScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
          parentNavigatorKey: parentNavigatorKey,
          path: signInPath,
          pageBuilder: (context, state) {
            return getPage(
              child: const SignInScreen(),
              state: state,
            );
          },
          routes: [
            GoRoute(
              path: profilePreferencesPath,
              pageBuilder: (context, state) {
                final params = state.extra as ProfilePreferencesParams;
                return getPage(
                  child: ProfilePreferencesScreen(
                    hasWorkoutPlan: params.hasWorkoutPlan,
                    isFirstLogin: params.isFirstLogin,
                    isAfterLogin: params.isAfterLogin,
                  ),
                  state: state,
                );
              },
            ),
            GoRoute(
              path: 'register',
              pageBuilder: (context, state) {
                return getPage(
                  child: RegisterScreen(),
                  state: state,
                );
              },
            ),
          ]),
      GoRoute(
          parentNavigatorKey: parentNavigatorKey,
          path: homePath,
          pageBuilder: (context, state) {
            return getPage(
              child: const HomeScreen(),
              state: state,
            );
          },
          routes: [
            GoRoute(
              path: profilePreferencesPath,
              pageBuilder: (context, state) {
                final params = state.extra as ProfilePreferencesParams;
                return getPage(
                  child: ProfilePreferencesScreen(
                    hasWorkoutPlan: params.hasWorkoutPlan,
                    isFirstLogin: params.isFirstLogin,
                    isAfterLogin: params.isAfterLogin,
                  ),
                  state: state,
                );
              },
            ),
            GoRoute(
              path: ratingPath,
              pageBuilder: (context, state) {
                return getPage(
                  child: const RatingScreen(),
                  state: state,
                );
              },
            ),
            GoRoute(
              path: profilePath,
              pageBuilder: (context, state) {
                final hasWorkoutPlan = (state.extra as bool?) ?? false;
                return getPage(
                  child: ProfileScreen(hasWorkoutPlan: hasWorkoutPlan),
                  state: state,
                );
              },
            ),
            GoRoute(
              path: achievementsPath,
              pageBuilder: (context, state) => getPage(
                child: const AchievementsScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: notificationsPath,
              pageBuilder: (context, state) => getPage(
                child: const NotificationsScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: notificationPrefsPath,
              pageBuilder: (context, state) => getPage(
                child: const NotificationPrefsScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: clansPath,
              pageBuilder: (context, state) => getPage(
                child: const ClansListScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: clanDetailPath,
              pageBuilder: (context, state) {
                final clanId = state.extra as int;
                return getPage(
                  child: ClanDetailScreen(clanId: clanId),
                  state: state,
                );
              },
            ),
            GoRoute(
              path: createClanPath,
              pageBuilder: (context, state) => getPage(
                child: const CreateClanScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: shopPath,
              pageBuilder: (context, state) => getPage(
                child: const ShopScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: framesPath,
              pageBuilder: (context, state) => getPage(
                child: const FramesScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: battlePassPath,
              pageBuilder: (context, state) => getPage(
                child: const BattlePassScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: referralsPath,
              pageBuilder: (context, state) => getPage(
                child: const ReferralsScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: seasonPath,
              pageBuilder: (context, state) => getPage(
                child: const SeasonScreen(),
                state: state,
              ),
            ),
            GoRoute(
              path: workoutPath,
              pageBuilder: (context, state) {
                return getPage(
                  child: const WorkoutBaseScreen(),
                  state: state,
                );
              },
            ),
          ]),
      GoRoute(
        path: textEditingPath,
        pageBuilder: (context, state) {
          return getPage(
            child: TextEditingScreen(params: state.extra as TextEditingScreenParams),
            state: state,
          );
        },
      ),
      GoRoute(
        path: videoPlayerPath,
        pageBuilder: (context, state) {
          return getPage(
            child: VideoPlayerScreen(params: state.extra as VideoPlayerScreenParams),
            state: state,
          );
        },
      ),
    ];

    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: splashPath,
      routes: routes,
      debugLogDiagnostics: false,
    );
  }

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}
