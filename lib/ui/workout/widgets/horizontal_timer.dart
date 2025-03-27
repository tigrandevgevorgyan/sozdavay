import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/common_widgets/level_up_container.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class HorizontalTimer extends StatefulWidget {
  const HorizontalTimer({super.key, required this.title, required this.secondsToCount});

  @override
  State<HorizontalTimer> createState() => _HorizontalTimerState();
  final String title;
  final int secondsToCount;
}

class _HorizontalTimerState extends State<HorizontalTimer> with TickerProviderStateMixin {
  AnimationController? _controller;

  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.secondsToCount),
    )..addListener(() {
        setState(() {});
      });
    _controller!.addStatusListener(
      (status) {
        if (status.isCompleted) {
          setState(() {
            _isRunning = false;
          });
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
    } else {
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
    _controller?.reset();
    _controller?.dispose();
  }
}
