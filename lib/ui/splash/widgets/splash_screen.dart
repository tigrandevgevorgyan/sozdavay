import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/splash/view_model/splash_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
    print('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      print('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      print('Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
    }
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      // Permission granted
      print("Notification Permission Granted!");
    } else {
      // Permission denied
      print("Notification Permission Denied!");
    }
  }
}
