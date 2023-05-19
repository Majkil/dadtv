import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' show parse;

class StreamUrlService extends ChangeNotifier {
  late String tvmHtml;

  ValueNotifier<Map<String, String>> playlist =
      ValueNotifier(<String, String>{});

  StreamUrlService() {
    getTVM();
    // getOne();
    // getNet();
  }
  getTVM() {
    var dio = Dio();
    try {
      dio.get('https://tvmi.mt/live/3').then((value) {
        var temp = value.data as String;
        var tempdoc = parse(temp);
        var tempVide = tempdoc.body?.getElementsByTagName('video');
        String? jwt = tempVide![0].attributes['data-jwt']!;
        playlist.value.putIfAbsent(
            "Tvmi", () => "https://dist7.tvmi.mt/$jwt/live/1/0/index.m3u8");
        playlist.value.putIfAbsent(
            "Tvm 2", () => "https://dist7.tvmi.mt/$jwt/live/2/0/index.m3u8");
        playlist.value.putIfAbsent("Tvm News+",
            () => "https://dist7.tvmi.mt/$jwt/live/3/0/index.m3u8");
        playlist.value.putIfAbsent("Tvm Sport+",
            () => "https://dist7.tvmi.mt/$jwt/live/4/0/index.m3u8");
        playlist.value.putIfAbsent("Magic 91.7 radio",
            () => "https://dist7.tvmi.mt/$jwt/live/5/0/index.m3u8");
        playlist.value.putIfAbsent("Radju Malta",
            () => "https://dist7.tvmi.mt/$jwt/live/6/0/index.m3u8");
        notifyListeners();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  getOne() {
    var dio = Dio();
    try {
      dio.get('https://tvmi.mt/live/3').then((value) {
        var temp = value.data as String;
        var tempdoc = parse(temp);
        var tempVide = tempdoc.body?.getElementsByTagName('video');
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  getNet() {
    var dio = Dio();
    try {
      dio.get('https://tvmi.mt/live/3').then((value) {
        var temp = value.data as String;
        var tempdoc = parse(temp);
        var tempVide = tempdoc.body?.getElementsByTagName('video');
      });
    } on Exception catch (e) {
      print(e);
    }
  }
}
