import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:level_up/utils/timer_state_storage.dart';

class TimerCompletionService {
  static final TimerCompletionService _instance = TimerCompletionService._internal();
  factory TimerCompletionService() => _instance;
  TimerCompletionService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  void initialize() {
  }

  Future<void> onTimerCompleted(String timerKey, int timerId) async {
    final wasOnBackground = await TimerStateStorage.wasTriggered(timerId);
    if (!wasOnBackground) {
      await _audioPlayer.setAudioContext(AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.assistanceSonification,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
      ));
      await _audioPlayer.play(AssetSource('sounds/htc_basic.mp3'));
      Timer(Duration(seconds: 8), () {
        _audioPlayer.stop();
      });
    }
    await TimerStateStorage.clear(timerId);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}