import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/common_widgets/level_up_container.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/utils/alarm_utils.dart';
import '../../../utils/notifications.dart';
import '../../../utils/timer_state_storage.dart';

class HorizontalTimer extends StatefulWidget {
  const HorizontalTimer({super.key, required this.title, required this.secondsToCount});

  @override
  State<HorizontalTimer> createState() => _HorizontalTimerState();
  final String title;
  final int secondsToCount;
}

class _HorizontalTimerState extends State<HorizontalTimer> with TickerProviderStateMixin {
  final AudioPlayer audioPlayer = AudioPlayer();
  AnimationController? _controller;

  bool _isRunning = false;

  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    cancelSquareNotification();
    cancelCountdownNotification(2);
    TimerStateStorage.clear(2);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.secondsToCount),
    )..addListener(() {
        if (context.mounted) {
          setState(() {});
        }
      });
    _controller!.addStatusListener(
          (status) async {
        if (status.isCompleted) {
          setState(() {
            _isRunning = false;
          });
          final wasOnBackground = await TimerStateStorage.wasTriggered(2);
          if (!wasOnBackground) {
            audioPlayer.play(AssetSource('sounds/notification_sound.wav'));
          }
          await TimerStateStorage.clear(2);
        }
      },
    );
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
          final remainingTime = widget.secondsToCount * 1000 - (widget.secondsToCount * 1000 * (_controller?.value ?? 0.0)).toInt();
          final time = Duration(milliseconds: remainingTime);
          final triggerTime = DateTime.now().add(time);
          TimerStateStorage.save(2, triggerTime);
          scheduleHorizontalNotification(triggerTime);
          showCountdownNotification(time, 2);
        }
      },
    );
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
            widthFactor: _controller?.value,
            child: LevelUpContainer(color: _controller?.isCompleted ?? false ? AppColors.timerDoneOrangeColor : AppColors.activeButtonColor),
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
    if (_controller?.isAnimating ?? false) {
      _controller?.stop();
      setState(() {
        _isRunning = false;
      });
      cancelSquareNotification();
      cancelCountdownNotification(2);
      TimerStateStorage.clear(2);
    } else {
      cancelSquareNotification();
      cancelCountdownNotification(2);
      TimerStateStorage.clear(2);
      _controller?.reset();
      _controller?.forward();
      setState(() {
        _isRunning = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    _controller?.reset();
    _controller?.dispose();
    _lifecycleListener.dispose();
  }
}
