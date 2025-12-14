import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/constants.dart';

class TokenService {
  TokenService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await Future.wait([
      if (accessToken.isNotEmpty)
        _storage.write(key: Constants.accessToken ?? '', value: accessToken),
      if (refreshToken.isNotEmpty)
        _storage.write(key: Constants.refreshToken ?? '', value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: Constants.accessToken?? '');
  }

  Future<String?> getRefreshToken() {
    return _storage.read(key: Constants.refreshToken ?? '');
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: Constants.accessToken ?? ''),
      _storage.delete(key: Constants.refreshToken ?? ''),
    ]);
  }
}
