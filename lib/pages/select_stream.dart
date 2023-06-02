import 'package:dadtv/components/big_buttons.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    var playlist = context.watch<StreamUrlService>().streams;
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            children: [
              for (var x in playlist.value)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RawKeyboardListener(
                    onKey: (key) {
                      if (key.runtimeType == RawKeyUpEvent) {
                        if (key.logicalKey == LogicalKeyboardKey.select) {
                          context.go('/play', extra: {'url': x.url});
                        }
                      }
                    },
                    focusNode: FocusNode(),
                    child: BigButton(
                      url: x.url,
                      text: x.title,
                      imgUrl: x.imgUrl,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (key) {
                    if (key.runtimeType == RawKeyUpEvent) {
                      if (key.logicalKey == LogicalKeyboardKey.select) {
                        context.go('/onevod', extra: {'day': DateTime.now()});
                      }
                    }
                  },
                  child: MaterialButton(
                    focusColor: Colors.amber,
                    color: Colors.red.shade100,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () => GoRouter.of(context)
                        .push('/onevod', extra: {'day': DateTime.now()}),
                    child: const Text("Video on Demand"),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
