import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  static const String _refreshTokenKey = 'refresh_token';

  final GetStorage _storage = GetStorage();

  // In-memory access token (never persisted)
  String? _accessToken;

  // In-memory access token expiry timestamp (milliseconds since epoch)
  int? _accessTokenExpiry;

  // Safety buffer: refresh if expiring within 60 seconds
  static const int _expiryBufferSeconds = 60;

  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  /// Stores both tokens after successful authentication
  void setTokens(String accessToken, String refreshToken) {
    _accessToken = accessToken;
    _decodeAndSetExpiry(accessToken);
    _storage.write(_refreshTokenKey, refreshToken);

    print(
      '[TokenManager] Tokens stored - Access token expiry: $_accessTokenExpiry',
    );
  }

  /// Extracts exp claim from JWT without signature validation
  void _decodeAndSetExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('[TokenManager] Invalid JWT format');
        _accessTokenExpiry = null;
        return;
      }

      // Add padding if needed
      var payload = parts[1];
      final padLength = 4 - (payload.length % 4);
      if (padLength != 4) {
        payload += '=' * padLength;
      }

      final decodedBytes = base64.decode(payload);
      final decodedMap =
          jsonDecode(utf8.decode(decodedBytes)) as Map<String, dynamic>;

      final exp = decodedMap['exp'];
      if (exp != null && exp is int) {
        _accessTokenExpiry = exp * 1000; // Convert to milliseconds
        print(
          '[TokenManager] Decoded exp: $exp, expiry time: ${DateTime.fromMillisecondsSinceEpoch(_accessTokenExpiry!)}',
        );
      }
    } catch (e) {
      print('[TokenManager] Error decoding token: $e');
      _accessTokenExpiry = null;
    }
  }

  /// Get current access token
  String? getAccessToken() {
    return _accessToken;
  }

  /// Get refresh token from storage
  String? getRefreshToken() {
    return _storage.read(_refreshTokenKey);
  }

  /// Check if access token is expired or will expire soon
  bool isAccessTokenExpired() {
    if (_accessTokenExpiry == null) return true;

    final now = DateTime.now().millisecondsSinceEpoch;
    final expiryWithBuffer =
        _accessTokenExpiry! - (_expiryBufferSeconds * 1000);

    final expired = now >= expiryWithBuffer;
    print(
      '[TokenManager] Checking expiry: now=$now, expiryWithBuffer=$expiryWithBuffer, expired=$expired',
    );

    return expired;
  }

  /// Update access token after refresh (called by interceptor)
  void updateAccessToken(String newAccessToken) {
    _accessToken = newAccessToken;
    _decodeAndSetExpiry(newAccessToken);
    print('[TokenManager] Access token updated');
  }

  /// Update refresh token if rotated (called by interceptor)
  void updateRefreshToken(String newRefreshToken) {
    _storage.write(_refreshTokenKey, newRefreshToken);
    print('[TokenManager] Refresh token updated');
  }

  /// Clear all tokens (called on logout or refresh failure)
  Future<void> clearTokens() async {
    _accessToken = null;
    _accessTokenExpiry = null;
    await _storage.erase();
    print('[TokenManager] All tokens cleared');
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return getRefreshToken() != null;
  }
}
