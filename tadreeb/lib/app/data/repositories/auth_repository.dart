import '../../core/constants/constants.dart';
import '../providers/api_provider.dart';

class AuthRepository {
  AuthRepository(this._apiProvider);

  final ApiProvider _apiProvider;

  Future<AuthResponse> login({required String email, required String password}) async {
    final result = await _apiProvider.post(
      Constants.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    return AuthResponse.fromJson(result);
  }

  Future<AuthResponse> register({
    required String email,
    required String username,
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String passwordConfirmation,
    String userType = 'trainee',
  }) async {
    final result = await _apiProvider.post(
      Constants.register,
      body: {
        'email': email,
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'user_type': userType,
        'phone': phone,
        'password': password,
        'password_confirm': passwordConfirmation,
      },
    );

    return AuthResponse.fromJson(result);
  }
}

class AuthResponse {
  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    this.user,
    this.message,
  });

  final String accessToken;
  final String refreshToken;
  final AuthUser? user;
  final String? message;

  bool get isAuthenticated => accessToken.isNotEmpty;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: (json['access'] ?? json['access_token'] ?? json['token']) as String? ?? '',
      refreshToken: (json['refresh'] ?? json['refresh_token']) as String? ?? '',
      user: json['user'] is Map<String, dynamic>
          ? AuthUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }
}

class AuthUser {
  AuthUser({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
  });

  final int id;
  final String email;
  final String? fullName;
  final String? phoneNumber;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      fullName: (json['full_name'] ?? json['name']) as String?,
      phoneNumber: (json['phone_number'] ?? json['phone']) as String?,
    );
  }
}
