import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/config/assets.dart';
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
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: Container(
        height: 259,
        color: Colors.white24,
        child: Stack(
          children: [
            _controller.value.isInitialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      // child: Container(
                      //   color: Colors.grey,
                      // ),
                      child: VideoPlayer(_controller),
                    ),
                  )
                : SizedBox.shrink(),
            if (widget.isUIVisible)
              Positioned.fill(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    });
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(_controller.value.isPlaying ? Assets.pauseIcon : Assets.playIcon),
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
    if (_controller.value.isInitialized) {
      _controller.pause();
    }
    GoRouter.of(context).push(LevelUpRouter.videoPlayerPath, extra: VideoPlayerScreenParams(url: widget.videoUrl, time: 0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
