// File: lib/services/iptv_git_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:dadtv/models/iptv_category.dart';
import 'package:dadtv/models/iptv_channel_model.dart';
import 'package:dadtv/models/iptv_countries.dart';
import 'package:dadtv/models/iptv_streams_model.dart';
import 'package:dadtv/services/db_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Top-level functions for compute
List<dynamic> _decodeJsonList(String body) {
  final decoded = jsonDecode(body);
  if (decoded is! List) {
    throw Exception('Unexpected JSON format: expected a list');
  }
  return decoded;
}

Map<String, dynamic> _jsonObject(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  throw Exception('Unexpected JSON item format: expected an object');
}

List<IptvStreamModel> _parseStreams(String body) {
  return _decodeJsonList(body)
      .map<IptvStreamModel>((e) => IptvStreamModel.fromJson(_jsonObject(e)))
      .toList();
}

List<IptvChannelModel> _parseChannels(String body) {
  return _decodeJsonList(body)
      .map<IptvChannelModel>((e) => IptvChannelModel.fromMap(_jsonObject(e)))
      .toList();
}

List<IptvCategoryModel> _parseCategories(String body) {
  return _decodeJsonList(body)
      .map<IptvCategoryModel>((e) => IptvCategoryModel.fromMap(_jsonObject(e)))
      .toList();
}

List<IptvCountry> _parseCountries(String body) {
  return _decodeJsonList(body)
      .map<IptvCountry>((e) => IptvCountry.fromMap(_jsonObject(e)))
      .toList();
}

/// Service to fetch the list of channels from iptv-org channels.json.
class IptvGitService {
  static const String _endpoint =
      'https://iptv-org.github.io/api/channels.json';

  final http.Client _client;

  IptvGitService({http.Client? client}) : _client = client ?? http.Client();

  Future<void> refreshData() async {
    final db = await DbService.instance;

    var categories = await fetchCategories();
    db.addAllCategories(categories);

    var countries = await fetchCountries();
    db.addAllCountries(countries);

    var streams = await fetchStreams();

    db.addAllStreams(streams);

    var channels = await fetchChannels();

    db.addAllChannels(channels);

  }

  Future<List<IptvStreamModel>> fetchStreams({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final uri = Uri.parse("https://iptv-org.github.io/api/streams.json");
    final response = await _client.get(uri).timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to load streams: ${response.statusCode}');
    }

    return compute(_parseStreams, response.body);
  }

  Future<List<IptvCategoryModel>> fetchCategories({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final uri = Uri.parse("https://iptv-org.github.io/api/categories.json");
    final response = await _client.get(uri).timeout(timeout);
    if (response.statusCode != 200) {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
    return compute(_parseCategories, response.body);
  }

  Future<List<IptvCountry>> fetchCountries({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final uri = Uri.parse("https://iptv-org.github.io/api/countries.json");
    final response = await _client.get(uri).timeout(timeout);
    if (response.statusCode != 200) {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
    return compute(_parseCountries, response.body);
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

    return compute(_parseChannels, response.body);
  }

  /// Dispose the internal http client if you created it in this service.
  void dispose() {
    try {
      _client.close();
    } catch (_) {}
  }
}
