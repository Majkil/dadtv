import 'package:dadtv/models/stream_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' show parse;

class StreamUrlService extends ChangeNotifier {
  late String tvmHtml;

  ValueNotifier<Map<String, String>> playlist =
      ValueNotifier(<String, String>{});
  ValueNotifier<List<StreamSource>> streams = ValueNotifier([]);
  StreamUrlService() {
    getTVM();
    getOne();
    //getNet();
  }
  getTVM() {
    var dio = Dio();

    dio.get('https://tvmi.mt/live/3').then((value) {
      var temp = value.data as String;
      var tempdoc = parse(temp);
      var tempVide = tempdoc.body?.getElementsByTagName('video');
      String? jwt = tempVide![0].attributes['data-jwt']!;
      // playlist.value.putIfAbsent(
      //     "Tvmi", () => "https://dist7.tvmi.mt/$jwt/live/1/0/index.m3u8");
      streams.value.add(StreamSource(
          title: "TVM2",
          url: "https://dist7.tvmi.mt/$jwt/live/2/0/index.m3u8",
          imgUrl: "https://cdn1.tvmi.mt/images/tvmi-logo-website.svg"));
      streams.value.add(StreamSource(
          title: "Tvm News+",
          url: "https://dist7.tvmi.mt/$jwt/live/3/0/index.m3u8"));
      streams.value.add(StreamSource(
          title: "Tvm Sport+",
          url: "https://dist7.tvmi.mt/$jwt/live/4/0/index.m3u8"));

      playlist.value.putIfAbsent(
          "Tvm 2", () => "https://dist7.tvmi.mt/$jwt/live/2/0/index.m3u8");
      playlist.value.putIfAbsent(
          "Tvm News+", () => "https://dist7.tvmi.mt/$jwt/live/3/0/index.m3u8");
      playlist.value.putIfAbsent(
          "Tvm Sport+", () => "https://dist7.tvmi.mt/$jwt/live/4/0/index.m3u8");
      playlist.value.putIfAbsent("Magic 91.7 radio",
          () => "https://dist7.tvmi.mt/$jwt/live/5/0/index.m3u8");
      playlist.value.putIfAbsent("Radju Malta",
          () => "https://dist7.tvmi.mt/$jwt/live/6/0/index.m3u8");
      notifyListeners();
    });
  }

  getOne() {
    streams.value.add(StreamSource(
        title: "one",
        url:
            "https://2-fss-1.streamhoster.com/pl_148/amlst:201830-1293592/playlist.m3u8",
        imgUrl:
            "https://one.com.mt/wp-content/themes/soledad-child/images/one-logo-white.svg"));
    playlist.value.putIfAbsent(
        "One",
        () =>
            "https://2-fss-1.streamhoster.com/pl_148/amlst:201830-1293592/playlist.m3u8");
    // or https://2-fss-1.streamhoster.com/pl_148/201830-1293592-1/playlist.m3u8
    notifyListeners();
  }

  getNet() {
    var dio = Dio();
    dio.get('https://netondemand.mt/?autoPlay=1').then((value) {
      var temp = value.data as String;
      var tempdoc = parse(temp);
      var tempVideo = tempdoc.body?.getElementsByTagName('source')[0];
      var source = tempVideo?.attributes['src'];
      playlist.value.putIfAbsent("Net", () => source!);

      streams.value.add(StreamSource(title: "Net", url: source!));
      notifyListeners();
    });
  }
}
