import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class OneVoDService extends ChangeNotifier {
  ValueNotifier<List<Episode>> episodes = ValueNotifier([]);

  var geturl = 'https://play.one.com.mt/api/getDayEpisodes/2023-05-19/tv';

  OneVoDService() {
    getToday();
  }

  Future<List<Episode>> getDayEpisodes(DateTime date) async {
    var dio = Dio();
    var part1 = 'https://play.one.com.mt/api/getDayEpisodes/';
    var url = '$part1${date.toString().split(' ')[0]}/tv';
    return await dio.get(url).then((value) => List<Episode>.from(
        value.data['episodes'].map((e) => Episode.fromMap(e))));
  }

  getToday() {
    getDayEpisodes(DateTime.now())
        .then((value) => episodes.value.addAll(value));
  }
}

class Episode {
  DateTime? startTime;
  String? duration;
  String title;
  String? imgUrl;
  String? genre;
  String videoUrl;
  bool canPlay = true;
  Episode(
      {required this.title,
      required this.videoUrl,
      this.duration,
      this.imgUrl,
      this.genre,
      this.startTime}) {
    if (videoUrl.isEmpty) {
      canPlay = false;
    } else {
      canPlay = true;
    }
  }
  factory Episode.fromMap(Map<String, dynamic> map) => Episode(
      title: map['series']['name'],
      videoUrl: map['clipMedia'] == null ? '' : map['clipMedia']['url'],
      duration: "${map['durationMin']}",
      imgUrl: map['posterUrl'],
      genre: map['series']['genres']?.map((g) => g['name']).toString(),
      startTime: DateTime.tryParse(map['startDateTime']));
}
