import 'package:dadtv/pages/vod_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/one_vod.dart';

class OneVodDayPicker extends StatefulWidget {
  final DateTime day;
  const OneVodDayPicker({super.key, required this.day});

  @override
  State<OneVodDayPicker> createState() => _OneVodDayPickerState();
}

class _OneVodDayPickerState extends State<OneVodDayPicker> {
  OneVoDService service = OneVoDService();
  List<Episode> playlist = [];
  bool panning = false;
  bool panLeft = true;
  @override
  void initState() {
    super.initState();
    currentDay = widget.day;
    getEpisodes();
  }

  late DateTime currentDay;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (v) {
        setState(() {
          panning = true;
        });
      },
      onPanUpdate: (event) {
        if (event.delta.dx > 0) {
          panLeft = false;
        }
        if (event.delta.dx < 0) {
          panLeft = true;
        }
        // print(event.delta);
        print(event.delta.direction);
      },
      onPanEnd: (v) {
        setState(() {
          panning = false;
          if (panLeft) {
            yesterday();
          } else {
            tomorrow();
          }
        });
      },
      child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (value) => handleKeyEvent(value),
          child: Scaffold(
              appBar: AppBar(
                elevation: 4,
                title: Text(currentDay.toString().split(' ')[0]),
              ),
              body: VoDSelector(
                vodDay: currentDay,
                playlist: playlist,
              ))),
    );
  }

  yesterday() {
    setState(() {
      currentDay = currentDay.subtract(const Duration(days: 1));
      getEpisodes();
    });
  }

  tomorrow() {
    setState(() {
      currentDay = currentDay.add(const Duration(days: 1));
      getEpisodes();
    });
  }

  handleKeyEvent(RawKeyEvent event) {
    if (event.runtimeType == RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        yesterday();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        tomorrow();
      }
    }
  }

  getEpisodes() {
    service.getDayEpisodes(currentDay).then((value) => {
          setState(
            () {
              playlist = value;
            },
          )
        });
  }
}
