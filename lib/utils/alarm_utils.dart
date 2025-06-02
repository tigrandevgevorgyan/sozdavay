import 'dart:io';

import 'package:alarm/alarm.dart';

AlarmSettings createNotification(int id, DateTime alarmTime) {
  return AlarmSettings(
    id: id,
    dateTime: alarmTime,
    assetAudioPath: 'assets/sounds/notification_sound.wav',
    loopAudio: false,
    vibrate: true,
    warningNotificationOnKill: Platform.isIOS,
    androidFullScreenIntent: true,
    volumeSettings: VolumeSettings.fade(
      volume: 0.8,
      fadeDuration: Duration(seconds: 5),
      volumeEnforced: true,
    ),
    notificationSettings: const NotificationSettings(
      title: 'Время отдыха вышло',
      body: 'Продолжить тренировку',
      //iconColor: Colors.red,
    ),
  );
}

Future<void> scheduleHorizontalNotification(DateTime alarmTime) async {
  await Alarm.set(alarmSettings: createNotification(2, alarmTime));
}

void cancelHorizontalNotification() async {
  await Alarm.stop(2);
}

Future<void> scheduleSquareNotification(DateTime alarmTime) async {
  await Alarm.set(alarmSettings: createNotification(1, alarmTime));
}

void cancelSquareNotification() async {
  await Alarm.stop(1);
}
