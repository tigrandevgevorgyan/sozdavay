import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/ui/home/widgets/home_screen.dart';
import 'package:level_up/ui/profile_preferences/widgets/profile_preferences_screen.dart';
import 'package:level_up/ui/rating/widgets/rating_screen.dart';
import 'package:level_up/ui/signin/widgets/signin_screen.dart';
import 'package:level_up/ui/splash/widgets/splash_screen.dart';
import 'package:level_up/ui/text_editing_screen/text_editing_screen.dart';

class LevelUpRouter {
  static final LevelUpRouter _instance = LevelUpRouter._internal();

  static LevelUpRouter get instance => _instance;

  static late final GoRouter router;

  static const String splashPath = '/';
  static const String signInPath = '/signin';
  static const String profilePreferencesPath = '/profile_preferences';
  static const String homePath = '/home';
  static const String ratingPath = '/rating';
  static const String textEditingPath = '/text_editing';

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
                return getPage(
                  child: const ProfilePreferencesScreen(),
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
              path: ratingPath,
              pageBuilder: (context, state) {
                return getPage(
                  child: const RatingScreen(),
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
    ];

    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: splashPath,
      routes: routes,
      debugLogDiagnostics: false,
      // redirect: (context, state) {
      //   return null;
      // }
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
