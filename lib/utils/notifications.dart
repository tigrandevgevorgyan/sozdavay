import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

void showCountdownNotification(Duration duration, int id) {
  final endTime = DateTime.now().add(duration);
  _updateCountdownNotification(endTime, id);

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    final now = DateTime.now();
    if (now.isAfter(endTime)) {
      timer.cancel();
      await flutterLocalNotificationsPlugin.cancel(id);
      return;
    }
    await _updateCountdownNotification(endTime, id);
  });
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
