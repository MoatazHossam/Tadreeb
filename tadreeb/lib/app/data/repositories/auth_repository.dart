import '../providers/api_provider.dart';

class AuthRepository {
  AuthRepository(this._apiProvider);

  final ApiProvider _apiProvider;

  Future<AuthResponse> login({required String email, required String password}) async {
    final result = await _apiProvider.post(
      '/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    return AuthResponse.fromJson(result);
  }
}

class AuthResponse {
  AuthResponse({required this.token});

  final String token;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(token: json['token'] as String? ?? '');
  }
}
