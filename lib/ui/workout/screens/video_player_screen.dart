import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  VideoPlayerController? _controller;
  VoidCallback? _listener;

  bool _isControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    try {
      File? file;
      try {
        file = await DefaultCacheManager().getSingleFile(widget.params.url);
      } catch (_) {
        file = null;
      }

      final controller = file != null
          ? VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      )
          : VideoPlayerController.networkUrl(
        Uri.parse(widget.params.url),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      await controller.initialize();
      await controller.setVolume(0.0);
      await controller.seekTo(Duration(seconds: widget.params.time));

      _listener = () {
        if (mounted) setState(() {});
      };
      controller.addListener(_listener!);

      if (!mounted) return;

      setState(() {
        _controller = controller;
      });

      _controller?.play();
    } catch (e) {
      debugPrint('Ошибка при инициализации видео $e');
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener ?? () {});
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final isReady = _controller?.value.isInitialized ?? false;

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
              isReady
                  ? Center(
                child: AspectRatio(
                  aspectRatio: _controller?.value.aspectRatio ?? 16 / 9,
                  child: VideoPlayer(_controller!),
                ),
              )
                  : SizedBox.shrink(),
              if (_isControlsVisible)
                VideoControls(
                  isPlaying: _controller?.value.isPlaying ?? false,
                  videoDuration: _controller?.value.duration ?? Duration.zero,
                  currentPlayTime: _controller?.value.position ?? Duration.zero,
                  onCloseClicked: () => GoRouter.of(context).pop(),
                  onPlayToggleClicked: () {
                  if (_controller != null) {
                    setState(() {
                      _controller!.value.isPlaying
                          ? _controller!.pause()
                          : _controller!.play();
                    });
                  }
                },
                 onRewindClicked: () {
                    final current = _controller?.value.position ?? Duration.zero;
                    _controller?.seekTo(current - Duration(seconds: 10));
                  },
                  onForwardClicked: () {
                    final current = _controller?.value.position ?? Duration.zero;
                    _controller?.seekTo(current + Duration(seconds: 10));
                  }
                )
            ],
          ),
        ),
      ),
    );
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
