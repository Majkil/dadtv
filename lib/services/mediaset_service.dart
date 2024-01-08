import 'package:dadtv/models/stream_source.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class MediasetService {
  Future<List<StreamSource>> getPlaylist() async {
    Dio dio = Dio();
    List<StreamSource> temp = [];
    var response = await dio.get(
        'https://raw.githubusercontent.com/Tundrak/IPTV-Italia/main/iptvitaplus.m3u');
    //.then((value) =>     print(value));
    LineSplitter ls = const LineSplitter();
    List<String> forMap = ls.convert(response.data);
    forMap.asMap().forEach((index, value) {
      if (value.contains('#EXTINF:')) {
        // StreamSource(title: value.)
        var nameReg =
            RegExp(r'tvg-id=\"(.*)\"(?: |  )tvg-chno').firstMatch(value)![1];
        var logoReg = RegExp(r'tvg-logo=\"(.*)\" ').firstMatch(value)![1];
        var soureurl = forMap[index + 1];
        if (!soureurl.contains("http", 0) || soureurl.contains('#EXT')) {
          soureurl = forMap[index + 2];
        }
        if (nameReg!.isNotEmpty && soureurl.isNotEmpty) {
          temp.add(
              StreamSource(title: nameReg, imgUrl: logoReg, url: soureurl));
        }
      }
    });
    return temp;
  }
}
