import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient(this._client, {required this.baseUrl, required this.apiKey});

  final http.Client _client;
  final String baseUrl;
  final String apiKey;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: {'key': apiKey, ...?query});

    final response = await _client.get(uri);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw ApiException(statusCode: response.statusCode, body: response.body);
    }
  }

  Future<List<dynamic>> getList(
    String path, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: {'key': apiKey, ...?query});

    final response = await _client.get(uri);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw ApiException(statusCode: response.statusCode, body: response.body);
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String body;

  ApiException({required this.statusCode, required this.body});

  @override
  String toString() => 'ApiException(statusCode: $statusCode, body: $body)';
}
