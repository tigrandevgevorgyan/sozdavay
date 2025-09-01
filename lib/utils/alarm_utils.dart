import 'dart:io';

import 'package:alarm/alarm.dart';

import 'notifications.dart';
AlarmSettings createNotification(int id, DateTime alarmTime) {
  return AlarmSettings(
    id: id,
    dateTime: alarmTime,
    assetAudioPath: 'assets/sounds/htc_basic.mp3',
    loopAudio: false,
    vibrate: true,
    warningNotificationOnKill: Platform.isIOS,
    androidFullScreenIntent: true,
    volumeSettings: VolumeSettings.fade(
      volume: null,
      fadeDuration: Duration(seconds: 6),
      volumeEnforced: false,
    ),
    notificationSettings: Platform.isIOS
        ? const NotificationSettings(
      title: '',
      body: '',
    )
        : const NotificationSettings(
      title: 'Время отдыха вышло',
      body: 'Продолжить тренировку',
    ),

  );

}

Future<void> scheduleHorizontalNotification(DateTime alarmTime) async {
  await Alarm.set(alarmSettings: createNotification(2, alarmTime));
  await scheduleFinishPushIOS(flutterLocalNotificationsPlugin, alarmTime, 2);
}

void cancelHorizontalNotification() async {
  await Alarm.stop(2);
  await cancelFinishPushIOS(flutterLocalNotificationsPlugin, 2);
}

Future<void> scheduleSquareNotification(DateTime alarmTime) async {
  await Alarm.set(alarmSettings: createNotification(1, alarmTime));
  await scheduleFinishPushIOS(flutterLocalNotificationsPlugin, alarmTime, 1);
}

void cancelSquareNotification() async {
  await Alarm.stop(1);
  await cancelFinishPushIOS(flutterLocalNotificationsPlugin, 1);
}
