import 'package:dadtv/services/one_vod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VoDSelector extends StatefulWidget {
  final DateTime vodDay;
  const VoDSelector({super.key, required this.vodDay});

  @override
  State<VoDSelector> createState() => _VoDSelectorState();
}

class _VoDSelectorState extends State<VoDSelector> {
  List<Episode> playlist = [];
  @override
  void initState() {
    super.initState();
    playlist = context.read<OneVoDService>().episodes.value;
    Provider.of<OneVoDService>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text(widget.vodDay.toString().split(' ')[0]),
      ),
      body: ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) =>
              EpisodeTile(episode: playlist[index])),
    );
  }
}

class EpisodeTile extends StatelessWidget {
  final Episode episode;
  const EpisodeTile({super.key, required this.episode});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (videoUrl!.isNotEmpty) {
            GoRouter.of(context).go('/play', extra: {'url': videoUrl});
          }
        },
        child: Container(
          color: canPlay ? Colors.white : Colors.red.shade200,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                width: 300,
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
                  children: [Text(title), Text('${duration}mins'), Text(genre)],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(startDateTime?.toLocal().toString() ?? '')],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
