import 'dart:convert';

import 'package:dadtv/models/stream_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SmashTvService extends ChangeNotifier {
  ValueNotifier<List<StreamSource>> smashPlaylist = ValueNotifier([]);
  SmashTvService() {
    getPlaylist();
  }
  Future<List<StreamSource>> getPlaylist() async {
    Dio dio = Dio();
    List<StreamSource> temp = [];
    var response = await dio.get('http://freetv.pro');
    //.then((value) =>     print(value));
    LineSplitter ls = const LineSplitter();
    List<String> forMap = ls.convert(response.data);
    forMap.asMap().forEach((index, value) {
      if (value.contains('#EXTINF:')) {
        // StreamSource(title: value.)
        var nameReg = RegExp(r'tvg-name=\"(.*)\" tvg').firstMatch(value)![1];
        var logoReg = RegExp(r'tvg-logo=\"(.*)\" ').firstMatch(value)![1];
        var soureurl = forMap[index + 1];

        if (nameReg!.toLowerCase().contains('net') ||
            nameReg.toLowerCase().contains('parliament') ||
            nameReg.toLowerCase().contains('news')) {
          temp.add(
              StreamSource(title: nameReg, imgUrl: logoReg, url: soureurl));
        } else {
          smashPlaylist.value.add(
              StreamSource(title: nameReg, imgUrl: logoReg, url: soureurl));
          notifyListeners();
        }
      }
    });
    return temp;
  }
}
