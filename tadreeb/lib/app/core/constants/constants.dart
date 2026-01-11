class Constants {
  const Constants._();

  static const baseUrl = 'https://tadreeb2.jetronix.io/api/v1';
  static const login = '/accounts/auth/login/';
  static const register = '/accounts/auth/register/';
  static const refreshTokenEndpoint = '/accounts/auth/token/refresh/';
  static const trainers = '/trainers/';
  static const bookings = '/bookings/';
  static const packages = '/packages/';

  static String? accessToken;
  static String? refreshToken;
}
