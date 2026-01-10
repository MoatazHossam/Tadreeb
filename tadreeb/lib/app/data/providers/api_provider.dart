import 'dart:convert';
import 'dart:developer';

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
    final response = await _sendWithAuth(
      () => _client.post(
        uri,
        headers: _buildHeaders(includeContentType: true),
        body: jsonEncode(body ?? <String, dynamic>{}),
      ),
    );

    log(response.body);

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

    final response = await _sendWithAuth(
      () => _client.get(
        uri,
        headers: _buildHeaders(),
      ),
    );
    log(response.body);

    return _handleResponse(response);
  }

  Map<String, String> _buildHeaders({bool includeContentType = false}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      if (includeContentType) 'Content-Type': 'application/json',
    };

    final accessToken = Constants.accessToken;
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  Future<http.Response> _sendWithAuth(
    Future<http.Response> Function() request,
  ) async {
    http.Response response = await request();

    if (response.statusCode == 401 &&
        Constants.refreshToken != null &&
        Constants.refreshToken!.isNotEmpty) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        response = await request();
      }
    }

    return response;
  }

  Future<bool> _refreshAccessToken() async {
    if (Constants.refreshToken == null || Constants.refreshToken!.isEmpty) {
      return false;
    }

    final uri = Uri.parse('$baseUrl${Constants.refreshTokenEndpoint}');
    try {
      final response = await _client.post(
        uri,
        headers: _buildHeaders(includeContentType: true),
        body: jsonEncode({'refresh': Constants.refreshToken}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decodedBody = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : const <String, dynamic>{};

        if (decodedBody is Map<String, dynamic>) {
          final newAccessToken = (decodedBody['access'] ??
                  decodedBody['access_token'] ??
                  decodedBody['token']) as String?;
          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            Constants.accessToken = newAccessToken;
            return true;
          }
        }
      }
    } catch (_) {}

    return false;
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
