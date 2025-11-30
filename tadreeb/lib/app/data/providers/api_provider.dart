import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/constants.dart';

class ApiProvider {
  ApiProvider({http.Client? client, this.baseUrl = Constants.baseUrl})
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
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body ?? <String, dynamic>{}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    final response = await _client.get(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decodedBody = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : const <String, dynamic>{};
    final isSuccessful = response.statusCode >= 200 && response.statusCode < 300;

    if (isSuccessful && decodedBody is Map<String, dynamic>) {
      return decodedBody;
    }

    String? message;
    if (decodedBody is Map<String, dynamic>) {
      message = decodedBody['detail'] as String? ??
          decodedBody['message'] as String? ??
          decodedBody['error'] as String?;
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: message ?? 'Request failed with status: ${response.statusCode}',
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
