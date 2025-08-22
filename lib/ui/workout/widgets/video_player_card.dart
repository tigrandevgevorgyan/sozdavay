import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/assets/assets.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/workout/screens/video_player_screen.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCard extends StatefulWidget {
  const VideoPlayerCard({super.key, required this.videoUrl, this.isUIVisible = true});

  final String videoUrl;
  final bool isUIVisible;

  @override
  State<VideoPlayerCard> createState() => _VideoPlayerCardState();
}

class _VideoPlayerCardState extends State<VideoPlayerCard> {
  VideoPlayerController? _controller;
  VoidCallback? _listener;
  String currentVideoUrl = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initController();

  }

  Future<void> _initController() async {
    final url = widget.videoUrl;

    if (url.trim().isEmpty) return;

    final oldController = _controller;

    _isInitialized = false;
    _controller = null;
    _listener = null;

    setState(() {});

    try {
      File? file;

      try {
        file = await DefaultCacheManager().getSingleFile(url);
      } catch (_) {
        file = null;
      }

      final newController = file != null
          ? VideoPlayerController.file(file, videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
        allowBackgroundPlayback: false,
      ))
          : VideoPlayerController.networkUrl(Uri.parse(url), videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
        allowBackgroundPlayback: false,
      ));

      await newController.initialize();

      if (!mounted) {
        await newController.dispose();
        return;
      }

      newController.setLooping(false);
      newController.setVolume(0);

      listener() {
        if (mounted) setState(() {});
      }

      newController.addListener(listener);

      setState(() {
        _controller = newController;
        _listener = listener;
        _isInitialized = true;
        currentVideoUrl = url;
      });
      oldController?.removeListener(_listener ?? () {});
      oldController?.dispose();
    } catch (e) {
      debugPrint('Ошибка инициализации видео: $e');
      oldController?.removeListener(_listener ?? () {});
      oldController?.dispose();
    }
  }


  @override
  void didUpdateWidget(VideoPlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (currentVideoUrl != widget.videoUrl) {
      _initController();
    }

  }

  @override
  Widget build(BuildContext context) {
    final isReady = _controller?.value.isInitialized ?? false;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: Container(
        height: 259,
        color: Colors.white24,
        child: Stack(
          children: [
            isReady
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _controller?.value.aspectRatio ?? 16 / 9,
                      child: _controller != null ? VideoPlayer(_controller!) : const SizedBox(),
                    ),
                  )
                : SizedBox.shrink(),
            if (widget.isUIVisible)
              Positioned.fill(
                child: InkWell(
                  onTap: () {
                    final playing = _controller?.value.isPlaying ?? false;
                    if (isReady) {
                      playing ? _controller?.pause() : _controller?.play();
                      setState(() {});
                    }
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset((_controller?.value.isPlaying ?? false) ? Assets.pauseIcon : Assets.playIcon),
                  ),
                ),
              ),
            if (widget.isUIVisible)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: goToPlayerScreen,
                  child: SvgPicture.asset(Assets.enlargeIcon),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void goToPlayerScreen() {
    final isReady = _controller?.value.isInitialized ?? false;
    if (isReady) {
      _controller?.pause();
    }
    GoRouter.of(context).push(LevelUpRouter.videoPlayerPath, extra: VideoPlayerScreenParams(url: widget.videoUrl, time: 0));
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener ?? () {});
    _controller?.dispose();
    super.dispose();
  }
}
