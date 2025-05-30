import 'dart:io';
import 'dart:ui';

import 'package:alarm/alarm.dart';

AlarmSettings createNotification(int id, DateTime alarmTime) {
  return AlarmSettings(
    id: 42,
    dateTime: alarmTime,
    assetAudioPath: 'assets/sounds/gong.mp3',
    loopAudio: true,
    vibrate: true,
    warningNotificationOnKill: Platform.isIOS,
    androidFullScreenIntent: true,
    volumeSettings: VolumeSettings.fade(
      volume: 0.8,
      fadeDuration: Duration(seconds: 5),
      volumeEnforced: true,
    ),
    notificationSettings: const NotificationSettings(
      title: 'This is the title',
      body: 'This is the body',
      stopButton: 'Stop the alarm',
      icon: 'notification_icon',
      iconColor: Color(0xff862778),
    ),
  );
}

Future<void> scheduleSquareNotification(DateTime alarmTime) async {
  await Alarm.set(alarmSettings: createNotification(1, alarmTime));
}

void cancelSquareNotification() async {
  await Alarm.stop(1);
}
