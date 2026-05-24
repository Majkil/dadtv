import 'package:dadtv/services/one_vod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TvmVoDService extends ChangeNotifier {
  ValueNotifier<List<Series>> series = ValueNotifier([]);

  Future<Object> getList() async {
    var dio = Dio();
    const url = '';

    return await dio
        .get(url)
        .then(
          (value) => List<TvmEpisode>.from(value.data.map((e) => TvmEpisode())),
        );
  }
  //  Future<Object>getEpisodes(){
  //   var dio= Dio();
  //   const url = '';

  //   // return await dio.get(url).then((value) => List<TvmEpisode> .from(value));
  //  }
}

class Series {
  String? title;
  String? imgUrl;
  List<TvmEpisode> episodes = [];
}

class TvmEpisode {}
