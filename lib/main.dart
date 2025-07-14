import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:level_up/config/dependencies.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/core/themes/themes.dart';
import 'package:level_up/utils/timer_state_complition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  TimerCompletionService().initialize();
  await Dependencies.registerDependencies();
  await initializeDateFormatting('ru_RU', null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
