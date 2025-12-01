// File: lib/services/iptv_git_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:dadtv/models/iptv_category.dart';
import 'package:dadtv/models/iptv_channel_model.dart';
import 'package:dadtv/models/iptv_countries.dart';
import 'package:dadtv/models/iptv_streams_model.dart';
import 'package:dadtv/services/db_service.dart';
import 'package:http/http.dart' as http;

/// Service to fetch the list of channels from iptv-org channels.json.
class IptvGitService {
  static const String _endpoint =
      'https://iptv-org.github.io/api/channels.json';

  final http.Client _client;

  IptvGitService({http.Client? client}) : _client = client ?? http.Client();

  Stream<int> refreshData() async* {
    var streams = await fetchStreams();
    yield 1;
    DbService.instance.addAllStreams(streams);
    yield 2;

    var channels = await fetchChannels();
    yield 3;
    DbService.instance.addAllChannels(channels);
    yield 4;

    DbService.instance.addAllCategories(await fetchCategories());
    yield 5;
    DbService.instance.addAllCountries(await fetchCountries());
    yield 6;
    yield 0;
  }

  Future<List<IptvStreamModel>> fetchStreams({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final uri = Uri.parse("https://iptv-org.github.io/api/streams.json");
    final response = await _client.get(uri).timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to load channels: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Unexpected JSON format: expected a list');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => IptvStreamModel.fromJson(e))
        .toList();
  }

  Future<List<IptvCategoryModel>> fetchCategories({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final uri = Uri.parse("https://iptv-org.github.io/api/categories.json");
    final response = await _client.get(uri).timeout(timeout);
    return jsonDecode(response.body).map((e) => IptvCategoryModel.fromJson(e));
  }

  Future<List<IptvCountry>> fetchCountries({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final uri = Uri.parse("https://iptv-org.github.io/api/countries.json");
    final response = await _client.get(uri).timeout(timeout);
    return jsonDecode(response.body).map((e) => IptvCountry.fromJson(e));
  }

  /// Fetches the channels list and returns a list of IptvModel.
  /// Throws an [Exception] on HTTP or parsing errors.
  Future<List<IptvChannelModel>> fetchChannels({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final uri = Uri.parse(_endpoint);
    final response = await _client.get(uri).timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to load channels: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Unexpected JSON format: expected a list');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => IptvChannelModel.fromJson(jsonEncode(e)))
        .toList();
  }

  /// Dispose the internal http client if you created it in this service.
  void dispose() {
    try {
      _client.close();
    } catch (_) {}
  }
}
