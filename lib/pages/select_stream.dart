import 'package:dadtv/components/big_buttons.dart';
import 'package:dadtv/components/stream_tiles.dart';
import 'package:dadtv/helpers/size_helper.dart';
import 'package:dadtv/models/stream_source.dart';
import 'package:dadtv/updater/updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ChannelSelection extends StatelessWidget {
  final ValueNotifier<List<StreamSource>> playlistTest;
  final bool showExtras;

  const ChannelSelection({
    super.key,
    required this.playlistTest,
    required this.showExtras,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    var playlist = playlistTest.value;
    const tileColor = Color.fromARGB(255, 219, 179, 176);
    var isLandscape =
        MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
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

              UiNavButton(
                text: "IPTv",
                url: "/iptv",
                color: const Color.fromARGB(255, 241, 204, 202),
              ),
              UiNavButton(
                text: "IPTv all ",
                url: "/iptv/all",
                color: const Color.fromARGB(255, 241, 204, 202),
              ),
               UiNavButton(
                text: "home ",
                url: "/home",
                color: const Color.fromARGB(255, 241, 204, 202),
              ),
              // ActionButton(
              //   onPressed: () => GoRouter.of(context).push('/iptv'),
              //   btnText: "iptv",
              // ),
              if (showExtras)
                SizedBox(
                  height: buttonHeight(context, isLandscape),
                  width: buttonHeight(context, isLandscape),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActionButton(
                      onPressed: () => GoRouter.of(
                        context,
                      ).push('/onevod', extra: {'day': DateTime.now()}),
                      btnText: 'Video on Demand',
                    ),
                  ),
                ),
              if (showExtras)
                UiNavButton(
                  text: "Other Smash Channels",
                  url: "/smashchannels",
                  color: const Color.fromARGB(255, 219, 179, 176),
                ),

              if (!showExtras)
                UiNavButton(
                  text: "Back",
                  url: "/smashchannels",
                  color: const Color.fromARGB(255, 219, 179, 176),
                ),

              if (showExtras)
                ActionButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Updater()),
                  ),
                  btnText: "Update",
                ),
            ],
          ),
        ),
      ),
    );
  }
}
