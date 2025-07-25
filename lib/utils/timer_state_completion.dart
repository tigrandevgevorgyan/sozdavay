import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:level_up/utils/timer_state_storage.dart';

class TimerCompletionService {

  final AudioPlayer _audioPlayer = AudioPlayer();
  final Set<int> _playedTimers = {};
  bool _hasCompleted = false;

  void initialize() {
  }

  Future<void> onTimerCompleted(String timerKey, int timerId) async {
    if (_playedTimers.contains(timerId) || _hasCompleted) return;

    final isAppInBackground = SchedulerBinding.instance.lifecycleState != AppLifecycleState.resumed;

    final wasOnBackground = await TimerStateStorage.wasTriggered(timerId);
    if (!wasOnBackground && !isAppInBackground) {
      await _audioPlayer.setAudioContext(AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
      ));
      await _audioPlayer.setVolume(0.6);
      await _audioPlayer.play(AssetSource('sounds/htc_basic.mp3'));
      await Future.delayed(Duration(seconds: 8));
      await _audioPlayer.stop();
      await _audioPlayer.release();
    }
    _playedTimers.add(timerId);
    _hasCompleted = true;
    await TimerStateStorage.clear(timerId);
  }

  void reset() {
    _playedTimers.clear();
    _audioPlayer.stop();
  }

  Future<void> onStartNewTimer() async {
    _hasCompleted = false;
    _playedTimers.clear();
  }

  Future<void> dispose() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.release();
      await _audioPlayer.dispose();
    } catch (e) {
    }
  }
}