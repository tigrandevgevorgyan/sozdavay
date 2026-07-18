import 'dart:developer' as developer;

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:level_up/config/dependencies.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/core/themes/themes.dart';

import 'data/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Defensive init for the alarm/timer subsystem.
  //
  // Background: a crash while a rest-timer alarm was scheduled was leaving
  // corrupt state in the alarm package's local storage. On the next launch,
  // `Alarm.init()` would throw before `runApp()` ran — the app would flash
  // the splash screen and immediately close. The only way out was delete +
  // reinstall.
  //
  // Fix: catch any failure from Alarm.init(), wipe persisted alarm state,
  // and try once more. If both attempts fail we still proceed to runApp()
  // — the app stays usable, just without scheduled alarms for this session.
  try {
    await Alarm.init();
  } catch (e, st) {
    developer.log(
      'Alarm.init() failed on first attempt — attempting cleanup',
      name: 'main',
      error: e,
      stackTrace: st,
    );
    try {
      await Alarm.stopAll();
    } catch (_) {
      // Best-effort; intentionally swallow.
    }
    try {
      await Alarm.init();
    } catch (e2, st2) {
      developer.log(
        'Alarm.init() failed again after cleanup — continuing without alarms',
        name: 'main',
        error: e2,
        stackTrace: st2,
      );
    }
  }

  await setupDependencies();
  await Dependencies.registerDependencies();
  await initializeDateFormatting('ru_RU', null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
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
