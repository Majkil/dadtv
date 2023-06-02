import 'package:dadtv/services/one_vod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class VoDSelector extends StatefulWidget {
  final DateTime vodDay;
  final List<Episode> playlist;
  const VoDSelector({super.key, required this.vodDay, required this.playlist});

  @override
  State<VoDSelector> createState() => _VoDSelectorState();
}

class _VoDSelectorState extends State<VoDSelector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.playlist.length,
        itemBuilder: (context, index) =>
            VoDStreamTile(episode: widget.playlist[index]));
  }
}

class VoDStreamTile extends StatelessWidget {
  final Episode episode;
  const VoDStreamTile({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return VoDPreviewTile(
        imgUrl: episode.imgUrl ?? '',
        title: episode.title,
        duration: episode.duration ?? '0',
        genre: episode.genre!,
        canPlay: episode.canPlay,
        videoUrl: episode.videoUrl,
        startDateTime: episode.startTime);
  }
}

class VoDPreviewTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String duration;
  final String genre;
  final bool canPlay;
  final String? videoUrl;
  final DateTime? startDateTime;
  const VoDPreviewTile(
      {super.key,
      required this.imgUrl,
      required this.title,
      required this.duration,
      this.genre = '',
      this.videoUrl = '',
      required this.canPlay,
      this.startDateTime});

  getOrientationDependantTile(context) {
    var orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      // landscape
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            width: 300,
            child: Image.network(
              imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          //row flexible
          Flexible(
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              direction: Axis.horizontal,
              children: [
                // image
                // title , duration and genre
                // column flexible
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: Flex(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    direction: Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text('$duration mins'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //start time
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Flex(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    direction: Axis.vertical,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('dd MMMM').format(startDateTime!)),
                          Text(DateFormat(DateFormat.HOUR24_MINUTE)
                              .format(startDateTime!)),
                          Text(genre),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width / 4,
            width: MediaQuery.of(context).size.width / 4,
            child: Image.network(
              imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text('${duration}mins'),
                Text(genre),
                Text(
                    DateFormat(DateFormat.HOUR24_MINUTE).format(startDateTime!))
              ],
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (videoUrl!.isNotEmpty) {
          GoRouter.of(context).go('/play', extra: {'url': videoUrl});
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (keyEvent) {
            if (keyEvent.runtimeType == RawKeyUpEvent &&
                keyEvent.logicalKey == LogicalKeyboardKey.select &&
                videoUrl!.isNotEmpty) {
              handlePress(context);
            }
          },
          child: MaterialButton(
              padding: const EdgeInsets.all(0),
              clipBehavior: Clip.hardEdge,
              focusColor: Colors.amber,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: canPlay ? Colors.white : Colors.red.shade200,
              onPressed: () {
                if (videoUrl!.isNotEmpty) {
                  handlePress(context);
                }
              },
              child: getOrientationDependantTile(context)),
        ),
      ),
    );
  }

  handlePress(context) {
    GoRouter.of(context).go('/play', extra: {'url': videoUrl});
  }
}
