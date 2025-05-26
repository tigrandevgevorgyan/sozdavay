import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.params});

  final VideoPlayerScreenParams params;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  bool _isControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.params.url))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundContentColor,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              _isControlsVisible = !_isControlsVisible;
            });
          },
          child: Stack(
            children: [
              _controller.value.isInitialized
                  ? SizedBox.expand(
                child: VideoPlayer(_controller),
              )
                  : SizedBox.shrink(),
              if (_isControlsVisible)
                VideoControls(
                  isPlaying: _controller.value.isPlaying,
                  videoDuration: _controller.value.duration,
                  currentPlayTime: _controller.value.position,
                  onCloseClicked: () => GoRouter.of(context).pop(),
                  onPlayToggleClicked: () {
                    setState(() {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    });
                  },
                  onRewindClicked: () => _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds - 10)),
                  onForwardClicked: () => _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds + 10)),
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class VideoControls extends StatelessWidget {
  const VideoControls(
      {super.key,
      required this.isPlaying,
      required this.videoDuration,
      required this.currentPlayTime,
      required this.onCloseClicked,
      required this.onPlayToggleClicked,
      required this.onRewindClicked,
      required this.onForwardClicked});

  final bool isPlaying;
  final Duration videoDuration;
  final Duration currentPlayTime;
  final Function() onCloseClicked;
  final Function() onPlayToggleClicked;
  final Function() onRewindClicked;
  final Function() onForwardClicked;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
          child: Row(
            children: [
              GestureDetector(
                onTap: onCloseClicked,
                child: SvgPicture.asset(Assets.closeIcon),
              ),
            ],
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onRewindClicked,
                child: SvgPicture.asset(Assets.rewindIcon),
              ),
              SizedBox(width: 52),
              GestureDetector(
                onTap: onPlayToggleClicked,
                child: SvgPicture.asset(
                  isPlaying ? Assets.pauseIcon : Assets.playIcon,
                  width: 28,
                ),
              ),
              SizedBox(width: 52),
              GestureDetector(
                onTap: onForwardClicked,
                child: SvgPicture.asset(Assets.forwardIcon),
              ),
            ],
          ),
        ),
        if (videoDuration.inSeconds > 0)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                    backgroundColor: Color(0x5CFFFFFF),
                    color: Color(0x59FFFFFF),
                    value: currentPlayTime.inMilliseconds.toDouble() / videoDuration.inMilliseconds,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text("${currentPlayTime.inMinutes}:${(currentPlayTime.inSeconds - currentPlayTime.inMinutes * 60).toString().padLeft(2, '0')}"),
                      ),
                      Text("${videoDuration.inMinutes}:${(videoDuration.inSeconds - videoDuration.inMinutes * 60).toString().padLeft(2, '0')}"),
                    ],
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class VideoPlayerScreenParams {
  final String url;
  final int time;

  VideoPlayerScreenParams({required this.url, required this.time});
}
