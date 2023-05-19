import 'package:dadtv/pages/vod_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/one_vod.dart';

class VoDDayPage extends StatefulWidget {
  final DateTime? day;
  const VoDDayPage({super.key, this.day});

  @override
  State<VoDDayPage> createState() => _VoDDayPageState();
}

class _VoDDayPageState extends State<VoDDayPage> {
  DateTime? currentDay;
  @override
  Widget build(BuildContext context) {
    currentDay ??= widget.day ?? DateTime.now();
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (value) {
          if (value.logicalKey == LogicalKeyboardKey.arrowLeft) {
            yesterday();
          }
          if (value.logicalKey == LogicalKeyboardKey.arrowRight) {
            tomorrow();
          }
        },
        child: VoDSelector(vodDay: currentDay!));
  }

  yesterday() {
    setState(() {
      currentDay = currentDay!.subtract(const Duration(days: 1));
    });
    context.watch<OneVoDService>().getDayEpisodes(currentDay!);
  }

  tomorrow() {
    setState(() {
      currentDay = currentDay!.add(const Duration(days: 1));
    });
    context.watch<OneVoDService>().getDayEpisodes(currentDay!);
  }
}
