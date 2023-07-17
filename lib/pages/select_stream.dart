import 'package:dadtv/components/big_buttons.dart';
import 'package:dadtv/components/stream_tiles.dart';
import 'package:dadtv/models/stream_source.dart';
import 'package:dadtv/updater/updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ChannelSelection extends StatelessWidget {
  final ValueNotifier<List<StreamSource>> playlistTest;
  final bool showExtras;
  const ChannelSelection(
      {super.key, required this.playlistTest, required this.showExtras});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    var playlist = playlistTest.value;
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              direction: Axis.horizontal,
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 4),
              children: [
                // const Updater(),
                ...streamTiles(playlist),
                if (showExtras)
                  ActionButton(
                    onPressed: () => GoRouter.of(context)
                        .push('/onevod', extra: {'day': DateTime.now()}),
                    btnText: 'Video on Demand',
                  ),
                if (showExtras)
                  ActionButton(
                      onPressed: () =>
                          GoRouter.of(context).push('/smashchannels'),
                      btnText: "Other Smash Channels"),
                if (!showExtras)
                  ActionButton(
                      onPressed: () => GoRouter.of(context).push('/'),
                      btnText: "Back"),
                if (showExtras)
                  ActionButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const Updater())),
                      btnText: "Update"),
              ],
            ),
          ),
        ));
  }
}
