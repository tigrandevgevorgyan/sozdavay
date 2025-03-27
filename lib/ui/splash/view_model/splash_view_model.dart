import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/utils/result.dart';

class SplashViewModel extends ChangeNotifier {
  final BuildContext context;
  final ILocalStorage localStorage;
  SplashViewModel(this.context, this.localStorage) {
    goToNextScreen();
  }

  void goToNextScreen() async {
    await Future.delayed(Duration(milliseconds: 500));
    final tokenResult = await localStorage.getAccessToken();
    switch (tokenResult) {
      case Ok<String?>():
        _navigate(tokenResult.value);
        return;
      case Error<String?>():
    }
  }

  void _navigate(String? token) {
    if (token != null) {
      GoRouter.of(context).go(LevelUpRouter.homePath);
    } else {
      GoRouter.of(context).go(LevelUpRouter.signInPath);
    }
  }
}
