import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/utils/alarm_utils.dart';

class SquareTimer extends StatefulWidget {
  const SquareTimer({super.key, required this.title, required this.secondsDuration});

  final String title;
  final int secondsDuration;

  @override
  State<SquareTimer> createState() => _SquareTimerState();
}

class _SquareTimerState extends State<SquareTimer> with TickerProviderStateMixin {
  final AudioPlayer audioPlayer = AudioPlayer();
  AnimationController? _controller;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.secondsDuration),
    )..addListener(() {
        print('timer test!');
        if (context.mounted) {
          setState(() {});
        }
      });
    _controller!.addStatusListener(
      (status) {
        if (status.isCompleted) {
          setState(() {
            _isRunning = false;
            audioPlayer.play(AssetSource('sounds/gong.mp3'));
          });
        }
      },
    );
    _controller?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3, right: 2, top: 2, bottom: 2),
            child: CustomPaint(
              painter: TimerPainter(_controller?.value ?? 0, _controller?.isCompleted ?? false),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(onTap: _onPlayTap, child: SvgPicture.asset(_isRunning ? Assets.stopIcon : Assets.playIcon)),
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
    if (_controller?.isAnimating ?? false) {
      _controller?.stop();
      setState(() {
        _isRunning = false;
      });
    } else {
      _controller?.reset();
      _controller?.forward();
      setState(() {
        _isRunning = true;
      });
      DateTime time = DateTime.now();
      time.add(Duration(seconds: 7));
      scheduleSquareNotification(time);
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    _controller?.reset();
    _controller?.dispose();
  }
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
