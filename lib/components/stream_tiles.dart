import 'package:dadtv/components/big_buttons.dart';
import 'package:dadtv/models/stream_source.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SteamTile extends StatelessWidget {
  final StreamSource source;
  const SteamTile({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      width: isLandscape
          ? MediaQuery.of(context).size.width / 5
          : MediaQuery.of(context).size.width / 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RawKeyboardListener(
          onKey: (key) {
            if (key.runtimeType == RawKeyUpEvent) {
              if (key.logicalKey == LogicalKeyboardKey.select) {
                GoRouter.of(context).push('/play', extra: {'url': source.url});
              }
            }
          },
          focusNode: FocusNode(skipTraversal: true),
          child: BigButton(
            url: source.url,
            text: source.title,
            imgUrl: source.imgUrl,
          ),
        ),
      ),
    );
  }
}

List<Widget> streamTiles(List<StreamSource> playlist) {
  return playlist.map((e) => SteamTile(source: e)).toList();
}
