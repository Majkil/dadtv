import 'dart:io';

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
  bool isLandscape = false;
  bool isPlaying = true;
  bool playerError = false;
  String errorMessage = '';
  @override
  void initState() {
    super.initState();
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    loadVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.restoreSystemUIOverlays();
  }

  String keybaordinput = '';
  @override
  Widget build(BuildContext context) {
    // var testConf = BetterPlayerConfiguration(autoPlay: true);
    // var testCont = BetterPlayerController(testConf,
    //     betterPlayerDataSource:
    //         BetterPlayerDataSource.network(widget.streamUrl));
    // var test = BetterPlayer(controller: testCont);

    Size outputSize = getOptimalRatio(MediaQuery.of(context).size);

    Widget player = playerError
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Something went wrong"),
              Text(errorMessage),
              //test,
            ],
          ))
        :
        //      test;
        // var bla =
        RawKeyboardListener(
            autofocus: true,
            focusNode: FocusNode(),
            onKey: (event) {
              if (event is RawKeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                  scanForward();
                } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                  scanBack();
                }
              } else if (event.logicalKey == LogicalKeyboardKey.select) {
                togglePlayPause();
              }
            },
            child: GestureDetector(
                onTap: togglePlayPause,
                child: Center(child: VideoPlayer(videoController))),
          );

    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SizedBox(
              width: outputSize.width,
              height: outputSize.height,
              child: isLandscape
                  ? Stack(
                      children: [
                        player,
                      ],
                    )
                  : Center(
                      child: player,
                    )),
        ));
  }

  Size getOptimalRatio(Size size) {
    if (size.width > size.height) {
      setState(() {
        isLandscape = true;
      });
      return Size((size.height / 9) * 16, size.height);
    } else {
      setState(() {
        isLandscape = false;
      });
      return Size(size.width, (size.width / 16) * 9);
    }
  }

  void loadVideoPlayer() {
    videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.streamUrl));
    // videoController = VideoPlayerController.network(widget.streamUrl);
    if (widget.streamUrl.contains('.mpd')) {
      videoController =
          VideoPlayerController.contentUri(Uri(path: widget.streamUrl));
    }
    videoController.addListener(() {
      if (videoController.value.hasError) {
        setState(() {
          playerError = true;
          print(widget.streamUrl);
          errorMessage = widget.streamUrl;
          errorMessage += Platform.lineTerminator;
          errorMessage += videoController.value.errorDescription.toString();
        });
      }
      setState(() {});
    });

    videoController.initialize().then((v) {
      setState(() {});
    });

    videoController.play();
  }

  void togglePlayPause() {
    if (isPlaying) {
      isPlaying = !isPlaying;
      videoController.pause();
    } else {
      isPlaying = !isPlaying;
      videoController.play();
    }
  }

  void scanBack() {
    videoController.position.then((value) => setState(() {
          keybaordinput = value!.inSeconds.toString();
          videoController.seekTo(Duration(seconds: value.inSeconds - 15));
        }));
  }

  void scanForward() {
    videoController.position.then((value) => setState(() {
          keybaordinput = value!.inSeconds.toString();
          videoController.seekTo(Duration(seconds: value.inSeconds + 15));
        }));
  }
}
