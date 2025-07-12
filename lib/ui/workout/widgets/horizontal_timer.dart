import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/common_widgets/level_up_container.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/utils/alarm_utils.dart';
import '../../../utils/notifications.dart';
import '../../../utils/timer_state_manager.dart';
import '../../../utils/timer_state_storage.dart';

class HorizontalTimer extends StatefulWidget {
  const HorizontalTimer({super.key, required this.title, required this.secondsToCount, required this.timerKey});

  final String title;
  final int secondsToCount;
  final String timerKey;

  @override
  State<HorizontalTimer> createState() => _HorizontalTimerState();
}

class _HorizontalTimerState extends State<HorizontalTimer> with TickerProviderStateMixin {
  final AudioPlayer audioPlayer = AudioPlayer();
  AnimationController? _controller;
  Timer? _updateTimer;

  bool _isRunning = false;
  bool _isCompleted = false;
  double _currentProgress = 0.0;

  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    cancelSquareNotification();
    cancelCountdownNotification(2);
    TimerStateStorage.clear(2);
    _initializeTimer();
    _restoreTimerState();
  }

  @override
  void didUpdateWidget(HorizontalTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timerKey != widget.timerKey) {
      _saveCurrentState(oldWidget.timerKey);
      _restoreTimerState();
    }
  }

  void _initializeTimer() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.secondsToCount),
    )..addListener(() {
      if (!mounted) return;

      final value = _controller!.value;

      if (!_isCompleted) {
        if (value >= 0.98) {
          _controller!.stop();
          _onTimerCompleted();
        } else {
          setState(() {
            _currentProgress = value;
          });
        }
      }
    });

    _controller!.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _onTimerCompleted();
      }
    });

    _lifecycleListener = AppLifecycleListener(
      onResume: () async {
        cancelHorizontalNotification();
        await cancelCountdownNotification(2);
        if (_isRunning) {
          await TimerStateStorage.clear(2);
        }
      },
      onPause: () {
        if (_isRunning) {
          final savedState = TimerStateManager.getTimerState(widget.timerKey);
          if (savedState != null && !savedState.isCompleted) {
            final remainingSeconds = savedState.remainingSeconds;
            final time = Duration(seconds: remainingSeconds);
            final triggerTime = DateTime.now().add(time);
            TimerStateStorage.save(2, triggerTime);
            scheduleHorizontalNotification(triggerTime);
            showCountdownNotification(time, 2);
          }
        }
      },
    );
  }

  void _restoreTimerState() {
    final savedState = TimerStateManager.getTimerState(widget.timerKey);

    if (savedState != null && savedState.isRunning && !savedState.isCompleted) {
      setState(() {
        _isRunning = true;
        _isCompleted = false;
        _currentProgress = savedState.progress;
      });

      _startPeriodicUpdate();

      _controller?.reset();
      _controller?.forward(from: savedState.progress);
    } else {
      setState(() {
        _isRunning = false;
        _isCompleted = false;
        _currentProgress = 0.0;
      });
      _controller?.reset();
    }
  }

  void _saveCurrentState(String? timerKey) {
    final key = timerKey ?? widget.timerKey;

    if (_isRunning && !_isCompleted) {
      final elapsedSeconds = (widget.secondsToCount * _currentProgress).round();
      final startTime = DateTime.now().subtract(Duration(seconds: elapsedSeconds));

      TimerStateManager.saveTimerState(
        key,
        TimerState(
          startTime: startTime,
          totalSeconds: widget.secondsToCount,
          isRunning: true,
        ),
      );
    } else if (_isCompleted || !_isRunning) {
      TimerStateManager.removeTimer(key);
    }
  }

  void _startPeriodicUpdate() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      final savedState = TimerStateManager.getTimerState(widget.timerKey);
      if (savedState != null && savedState.isRunning && !savedState.isCompleted) {
        setState(() {
          _currentProgress = savedState.progress;
        });

        _controller?.value = _currentProgress;

        if (savedState.isCompleted) {
          _onTimerCompleted();
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _onTimerCompleted() async{
    setState(() {
      _isRunning = false;
      _isCompleted = true;
      _currentProgress = 1.0;
    });

    TimerStateManager.removeTimer(widget.timerKey);

    final wasOnBackground = await TimerStateStorage.wasTriggered(2);
    if (!wasOnBackground) {
      await audioPlayer.setAudioContext(AudioContext(
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
      await audioPlayer.play(AssetSource('sounds/htc_basic.mp3'));
      Timer(Duration(seconds: 8), () {
        audioPlayer.stop();
      });
    }
    await TimerStateStorage.clear(2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 40,
          child: LevelUpContainer(color: AppColors.backgroundContentColor),
        ),
        SizedBox(
          height: 40,
          child: FractionallySizedBox(
            widthFactor: _currentProgress,
            child: LevelUpContainer(
                color: _isCompleted ? AppColors.timerDoneOrangeColor : AppColors.activeButtonColor
            ),
          ),
        ),
        Positioned.fill(
          child: Row(
            children: [
              SizedBox(width: 12),
              Expanded(
                child: Text(widget.title, style: Style.ablation14w800),
              ),
              GestureDetector(
                onTap: _onPlayTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset(_isRunning ? Assets.stopIcon : Assets.playIcon),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onPlayTap() {
    if (_isRunning) {
      _controller?.stop();
      _updateTimer?.cancel();

      setState(() {
        _isRunning = false;
      });

      TimerStateManager.removeTimer(widget.timerKey);
      cancelSquareNotification();
      cancelCountdownNotification(2);
      TimerStateStorage.clear(2);
    } else {
      _startNewTimer();
    }
  }

  void _startNewTimer() {
    cancelSquareNotification();
    cancelCountdownNotification(2);
    TimerStateStorage.clear(2);

    TimerStateManager.stopAllExcept(widget.timerKey);

    setState(() {
      _isRunning = true;
      _isCompleted = false;
      _currentProgress = 0.0;
    });

    TimerStateManager.saveTimerState(
      widget.timerKey,
      TimerState(
        startTime: DateTime.now(),
        totalSeconds: widget.secondsToCount,
        isRunning: true,
      ),
    );

    _controller?.reset();
    _controller?.forward();
    _startPeriodicUpdate();
  }

  @override
  void dispose() {
    _saveCurrentState(null);
    _controller?.dispose();
    _updateTimer?.cancel();
    audioPlayer.dispose();
    _lifecycleListener.dispose();
    super.dispose();
  }
}
