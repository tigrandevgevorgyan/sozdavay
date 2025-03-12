import 'package:flutter/material.dart';
import 'package:level_up/config/dependencies.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/core/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Dependencies.registerDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LevelUpRouter.instance.initGlobalKey();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.appTheme,
      routerConfig: LevelUpRouter.router,
    );
  }
}
