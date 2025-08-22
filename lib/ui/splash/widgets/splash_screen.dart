import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/assets/assets.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/splash/view_model/splash_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../utils/notifications.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashViewModel(context, GetIt.I<ILocalStorage>()),
      child: Consumer<SplashViewModel>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Image(image: AssetImage(Assets.logo)),
            ),
          );
        },
      ),
    );
  }

  void _requestPermissions() async {
    await _requestNotificationPermission();
    await _checkAndroidScheduleExactAlarmPermission();
  }

  Future<void> _checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      final res = await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();

  }
}
