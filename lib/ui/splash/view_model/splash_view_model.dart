import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/routing/levelup_router.dart';

class SplashViewModel extends ChangeNotifier {
  final BuildContext context;
  SplashViewModel(this.context) {
    goToNextScreen();
  }

  void goToNextScreen() async {
    await Future.delayed(Duration(milliseconds: 500));
    GoRouter.of(context).go(LevelUpRouter.signInPath);
  }
}
