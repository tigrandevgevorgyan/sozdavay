import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/utils/alarm_utils.dart';
import 'package:level_up/utils/timer_state_storage.dart';
import '../../../utils/notifications.dart';
import '../../../utils/timer_state_completion.dart';
import '../../../utils/timer_state_manager.dart';

class SquareTimer extends StatefulWidget {
  const SquareTimer({super.key, required this.title, required this.secondsToCount, required this.timerKey});

  final String title;
  final int secondsToCount;
  final String timerKey;

  @override
  State<SquareTimer> createState() => _SquareTimerState();
}

class _SquareTimerState extends State<SquareTimer> with TickerProviderStateMixin {
  AnimationController? _controller;
  Timer? _updateTimer;

  bool _isRunning = false;
  bool _isCompleted = false;
  double _currentProgress = 0.0;
  bool _isAppPaused = false;

  AppLifecycleListener? _lifecycleListener;

  @override
  void initState() {
    super.initState();
    if (widget.secondsToCount <= 0) {
      _isRunning = false;
      _isCompleted = false;
      _currentProgress = 0.0;
      return;
    }
    // TimerStateManager.registerLifecycleDisposer(widget.timerKey, () {
    //   _lifecycleListener?.dispose();
    //   _lifecycleListener = null;
    // });
    cancelSquareNotification();
    cancelCountdownNotification(1);
    TimerStateStorage.clear(1);
    _initializeTimer();
    _restoreTimerState();

    TimerStateManager.setCompletionCallback(widget.timerKey, () {
      TimerCompletionService().onTimerCompleted(widget.timerKey, 1);
      if (mounted) {
        _setCompletedState();
      }
    });
  }

  @override
  void didUpdateWidget(SquareTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timerKey != widget.timerKey) {
      _saveCurrentState(oldWidget.timerKey);
      TimerStateManager.setCompletionCallback(widget.timerKey, () {
        TimerCompletionService().onTimerCompleted(widget.timerKey, 1);
        if (mounted) {
          _setCompletedState();
        }
      });
      _restoreTimerState();
    }
  }

  void _setCompletedState() {
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isCompleted = true;
      _currentProgress = 1.0;
    });
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
        _isAppPaused = false;
        cancelSquareNotification();
        await cancelCountdownNotification(1);
        if (_isRunning) {
          await TimerStateStorage.clear(1);
        }
      },
      onPause: () {
        _isAppPaused = true;
        if (_isRunning) {
          final savedState = TimerStateManager.getTimerState(widget.timerKey);
          if (savedState != null && !savedState.isCompletedByTime) {
            final remainingSeconds = savedState.remainingSeconds;
            final time = Duration(seconds: remainingSeconds);
            final triggerTime = DateTime.now().add(time);
            TimerStateStorage.save(1, triggerTime);
            scheduleSquareNotification(triggerTime);
            showCountdownNotification(time, 1);
          }
        }
      },
    );
  }

  void _restoreTimerState() {
    if (widget.secondsToCount <= 0) return;
    final savedState = TimerStateManager.getTimerState(widget.timerKey);

    if (savedState != null && savedState.totalSeconds > 0) {
      setState(() {
        _isRunning = savedState.isRunning;
        _isCompleted = savedState.isCompleted;
        _currentProgress = savedState.progress;
      });

      if (savedState.isRunning && !savedState.isCompleted) {
        _startPeriodicUpdate();
        _controller?.reset();
        _controller?.forward(from: savedState.progress);
      } else if (savedState.isCompleted) {
        _controller?.reset();
        _controller?.forward(from: 1.0);
      } else {
        _controller?.reset();
      }
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
    if (widget.secondsToCount <= 0) return;

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
          isCompleted: false,
        ),
      );
    } else if (_isCompleted) {
      TimerStateManager.saveTimerState(
        key,
        TimerState(
          startTime: DateTime.now(),
          totalSeconds: widget.secondsToCount,
          isRunning: false,
          isCompleted: true,
        ),
      );
    } else {
      TimerStateManager.removeTimer(key);
    }
  }

  void _startPeriodicUpdate() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      final savedState = TimerStateManager.getTimerState(widget.timerKey);
      if (savedState != null && savedState.isRunning && !savedState.isCompletedByTime) {
      if (mounted) {
        setState(() {
          _currentProgress = savedState.progress;
        });
        _controller?.value = _currentProgress;
      }

        if (savedState.isCompletedByTime) {
          _onTimerCompleted();
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _onTimerCompleted() async {
    if (!mounted) return;

    setState(() {
      _isRunning = false;
      _isCompleted = true;
      _currentProgress = 1.0;
    });

    TimerStateManager.saveTimerState(
      widget.timerKey,
      TimerState(
        startTime: DateTime.now(),
        totalSeconds: widget.secondsToCount,
        isRunning: false,
        isCompleted: true,
      ),
    );

    await TimerCompletionService().onTimerCompleted(widget.timerKey, 1);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.secondsToCount <= 0) {
      return Expanded(
        child: Center(
          child: Text("Без отдыха", style: Style.ablation14w800.copyWith(color: AppColors.primaryTextColor)),
        ),
      );
    }
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3, right: 2, top: 2, bottom: 2),
            child: CustomPaint(
              painter: TimerPainter(_currentProgress, _isCompleted),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                      onTap: _onPlayTap,
                      child: SvgPicture.asset(_isRunning ? Assets.stopIcon : Assets.playIcon)
                  ),
                  SizedBox(height: 18),
                  Text(widget.title, style: Style.ablation14w800.copyWith(color: AppColors.primaryTextColor)),
                ],
              ),
            ),
          ),
        ],
      ),
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
      cancelCountdownNotification(1);
      TimerStateStorage.clear(1);
    } else if (_isCompleted) {
      _resetTimer();
    } else {
      _startNewTimer();
    }
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _isCompleted = false;
      _currentProgress = 0.0;
    });

    _controller?.reset();
    TimerStateManager.removeTimer(widget.timerKey);
  }

  void _startNewTimer() {
    cancelSquareNotification();
    cancelCountdownNotification(1);
    TimerStateStorage.clear(1);

    TimerCompletionService().onStartNewTimer();

    TimerStateManager.stopAllExcept(widget.timerKey);
    TimerStateManager.setCompletionCallback(widget.timerKey, () {
      TimerCompletionService().onTimerCompleted(widget.timerKey, 1);
      if (mounted) {
        _setCompletedState();
      }
    });

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
        isCompleted: false,
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
    if (_isAppPaused && _isRunning && !_isCompleted) {
      final savedState = TimerStateManager.getTimerState(widget.timerKey);
      if (savedState != null && !savedState.isCompletedByTime) {
        final remainingSeconds = savedState.remainingSeconds;
        final triggerTime = DateTime.now().add(Duration(seconds: remainingSeconds));
        TimerStateStorage.save(1, triggerTime);
        scheduleSquareNotification(triggerTime);
      }
    }
    super.dispose();
  }
//   void disposeLifecycleListener() {
//     _lifecycleListener?.dispose();
//     _lifecycleListener = null;
//   }
}

class TimerPainter extends CustomPainter {
  Paint defaultPaint = Paint();

  final double value;
  final bool isCompleted;

  TimerPainter(this.value, this.isCompleted) {
    defaultPaint.color = isCompleted ? AppColors.timerDoneOrangeColor : AppColors.activeButtonColor;
    defaultPaint.style = PaintingStyle.stroke;
    defaultPaint.strokeCap = StrokeCap.round;
    defaultPaint.strokeWidth = 4;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (value == 0) {
      return;
    }
    canvas.drawLine(Offset(0, size.height), Offset(0, max(0, size.height - size.height * value * 4)), defaultPaint);
    if (value > 0.25) {
      canvas.drawLine(Offset(0, 0), Offset(min(size.width - 2, size.width * (value - 0.25) * 4), 0), defaultPaint);
    }
    if (value >= 0.5) {
      canvas.drawLine(Offset(size.width - 2, 0), Offset(size.width - 2, min(size.height, size.height * (value - 0.5) * 4)), defaultPaint);
    }
    if (value >= 0.75) {
      canvas.drawLine(Offset(size.width - 2, size.height), Offset(max(0, size.width - 2 - size.width * (value - 0.75) * 4), size.height), defaultPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TimerPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.isCompleted != isCompleted;
  }
}
