import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final Map<int, Timer> _countdownTimers = {};
final Map<int, bool> _isTimerActive = {};

Future<void> initNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  if (Platform.isIOS) {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}

void showCountdownNotification(Duration duration, int id) {

  if (Platform.isIOS) {
    final endTime = DateTime.now().add(duration);
    scheduleFinishPushIOS(flutterLocalNotificationsPlugin, endTime, id);
    return;
  }

  cancelCountdownNotification(id);

  Future.delayed(Duration(milliseconds: 100), () {

    _isTimerActive[id] = true;

    final endTime = DateTime.now().add(duration);
    _updateCountdownNotification(endTime, id);

    _countdownTimers[id] = Timer.periodic(const Duration(seconds: 1), (timer) async {

      if (!(_isTimerActive[id] ?? false)) {
        timer.cancel();
        _countdownTimers.remove(id);
        return;
      }

      final now = DateTime.now();
      if (now.isAfter(endTime)) {
        timer.cancel();
        _countdownTimers.remove(id);
        _isTimerActive.remove(id);
        await flutterLocalNotificationsPlugin.cancel(id);
        return;
      }
      await _updateCountdownNotification(endTime, id);
    });
  });
}

Future<void> cancelCountdownNotification(int id) async {

  _isTimerActive[id] = false;

  _countdownTimers[id]?.cancel();
  _countdownTimers.remove(id);
  _isTimerActive.remove(id);

  await flutterLocalNotificationsPlugin.cancel(id);
}

Future<void> cancelAllNotifications() async {

  for (var timer in _countdownTimers.values) {
    timer.cancel();
  }
  _countdownTimers.clear();
  _isTimerActive.clear();

  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> _updateCountdownNotification(DateTime endTime, int id) async {
  final now = DateTime.now();
  final remaining = endTime.difference(now);
  final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
  final body = 'Осталось $minutes:$seconds';

  final androidDetails = AndroidNotificationDetails(
    'countdown_channel',
    'Countdown Notifications',
    importance: Importance.max,
    priority: Priority.high,
    onlyAlertOnce: true,
    showWhen: false,
  );

  final platformDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    id,
    'Таймер отдыха',
    body,
    platformDetails,
  );
}

Future<void> scheduleFinishPushIOS(
    FlutterLocalNotificationsPlugin fln,
    DateTime when,
    int id,
    ) async {
  if (!Platform.isIOS) return;

  final scheduled = tz.TZDateTime.from(when, tz.local);

  final ios = DarwinNotificationDetails(
    presentAlert: true,
    presentSound: false,
    presentBadge: false,
    interruptionLevel: InterruptionLevel.timeSensitive,
  );

  await fln.zonedSchedule(
    id,
    'Время отдыха вышло',
    'Продолжить тренировку',
    scheduled,
    NotificationDetails(iOS: ios),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}

Future<void> cancelFinishPushIOS(
    FlutterLocalNotificationsPlugin fln,
    int id,
    ) async {
  if (!Platform.isIOS) return;
  await fln.cancel(id);
}
