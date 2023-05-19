import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  final String streamUrl;
  const Player({super.key, required this.streamUrl});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late VideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    loadVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: VideoPlayer(videoController))),
    );
  }

  loadVideoPlayer() {
    videoController = VideoPlayerController.network(widget.streamUrl);
    videoController.addListener(() {
      setState(() {});
    });
    videoController.initialize().then((v) {
      setState(() {});
    });
    videoController.play();
  }
}
