import 'dart:io';

import 'package:alarm/alarm.dart';

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
