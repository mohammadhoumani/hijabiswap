import 'package:get_storage/get_storage.dart';

class TokenStorage {
  static final _box = GetStorage();
  static const _refreshTokenKey = 'refresh_token';

  /// Get refresh token from persistent storage
  static String? get refreshToken => _box.read(_refreshTokenKey);

  /// Store refresh token in persistent storage
  static set refreshToken(String? v) => _box.write(_refreshTokenKey, v);

  /// Clear all tokens
  static Future<void> clearTokens() async {
    await _box.erase();
  }
}
