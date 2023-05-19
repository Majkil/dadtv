import 'package:dadtv/services/stream_url_service.dart';
import 'package:flutter/material.dart';
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
    var playlist = context.watch<StreamUrlService>().playlist;
    return Scaffold(
        body: GridView(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      children: [
        for (var x in playlist.value.keys)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  // color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 3)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  focusColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 5,
                  onPressed: () =>
                      context.go('/play', extra: {'url': playlist.value[x]!}),
                  child: Center(child: Text(x)),
                ),
              ),
            ),
          )
      ],
    ));
  }
}
