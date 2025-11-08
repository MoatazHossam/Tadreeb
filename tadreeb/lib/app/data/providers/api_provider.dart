import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiProvider {
  ApiProvider({http.Client? client, this.baseUrl = 'https://reqres.in/api'})
      : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body ?? <String, dynamic>{}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: 'Request failed with status: ${response.statusCode}',
      body: response.body,
    );
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  ApiException({required this.statusCode, required this.message, this.body});

  final int statusCode;
  final String message;
  final String? body;

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message, body: $body)';
  }
}
