// File: lib/services/iptv_git_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:dadtv/models/iptv_model.dart';
import 'package:dadtv/models/iptv_streams_model.dart';
import 'package:http/http.dart' as http;

/// Service to fetch the list of channels from iptv-org channels.json.
class IptvGitService {
  static const String _endpoint =
      'https://iptv-org.github.io/api/channels.json';

  final http.Client _client;

  IptvGitService({http.Client? client}) : _client = client ?? http.Client();
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

  /// Fetches the channels list and returns a list of IptvModel.
  /// Throws an [Exception] on HTTP or parsing errors.
  Future<List<IptvModel>> fetchChannels({
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
        .map((e) => IptvModel.fromJson(jsonEncode(e)))
        .toList();
  }

  /// Dispose the internal http client if you created it in this service.
  void dispose() {
    try {
      _client.close();
    } catch (_) {}
  }
}
