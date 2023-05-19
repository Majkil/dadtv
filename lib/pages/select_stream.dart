import 'dart:math';

import 'package:dadtv/services/stream_url_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChannelSelection extends StatefulWidget {
  const ChannelSelection({super.key});

  @override
  State<ChannelSelection> createState() => _ChannelSelectionState();
}

class _ChannelSelectionState extends State<ChannelSelection> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    var playlist = context.watch<StreamUrlService>().playlist;
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          children: [
            for (var x in playlist.value.keys)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  clipBehavior: Clip.hardEdge,
                  onPressed: () =>
                      context.go('/play', extra: {'url': playlist.value[x]!}),
                  child: Stack(
                      fit: StackFit.loose,
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Center(child: Text(x)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Transform.rotate(
                            angle: -pi / 4,
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
                              child: Text(
                                'Live',
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                focusColor: Colors.amber,
                color: Colors.red.shade100,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () => GoRouter.of(context).push('/vod'),
                child: const Text("Video on Demand"),
              ),
            )
          ],
        ));
  }
}
