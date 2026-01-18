class Constants {
  const Constants._();

  static const baseUrl = 'https://tadreeb2.jetronix.io/api/v1';
  static const login = '/accounts/auth/login/';
  static const register = '/accounts/auth/register/';
  static const refreshTokenEndpoint = '/accounts/auth/token/refresh/';
  static const profile = '/accounts/profile/';
  static const trainers = '/trainers/';
  static const bookings = '/bookings/';
  static const bookingsList = '/bookings/list/';
  static const packages = '/packages/';

  static String bookingApprove(int bookingId) => '/bookings/$bookingId/approve/';

  static String? accessToken;
  static String? refreshToken;
}
