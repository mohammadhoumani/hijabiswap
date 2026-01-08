import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hijabiswap/core/network/endpoints.dart';
import 'package:hijabiswap/core/network/token_manager.dart';
import 'package:hijabiswap/routes/app_routes.dart';

class AuthInterceptor extends Interceptor {
  static final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // Completer to ensure only one refresh happens at a time
  static Future<bool>? _refreshFuture;

  final TokenManager _tokenManager = TokenManager();

  // Public endpoints that don't require authentication
  static const List<String> _publicEndpoints = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
    '/auth/forgot-password',
  ];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('[AuthInterceptor] onRequest: ${options.path}');

    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // 1. Check if access token exists
    if (_tokenManager.getAccessToken() == null) {
      print('[AuthInterceptor] No access token, attempting refresh...');
      final refreshed = await _ensureAccessToken();
      if (!refreshed) {
        return _handleRefreshFailure(handler);
      }
    }

    // 2. Check if access token is expired
    if (_tokenManager.isAccessTokenExpired()) {
      print('[AuthInterceptor] Access token expired, attempting refresh...');
      final refreshed = await _ensureAccessToken();
      if (!refreshed) {
        return _handleRefreshFailure(handler);
      }
    }

    // 3. Attach access token to request
    final token = _tokenManager.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      print('[AuthInterceptor] Authorization header added');
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    print('[AuthInterceptor] onError: ${err.response?.statusCode}');

    // Safety net: if 401 and we haven't already retried
    if (err.response?.statusCode == 401 &&
        err.requestOptions.extra['_retry'] != true) {
      print('[AuthInterceptor] 401 detected, attempting refresh...');

      final refreshed = await _ensureAccessToken();
      if (refreshed) {
        // Retry original request with new token
        return _retry(err.requestOptions, handler);
      }
    }

    return handler.next(err);
  }

  /// Ensure access token is valid, refresh if needed
  /// Returns true if successful, false if refresh failed
  Future<bool> _ensureAccessToken() async {
    // Use existing refresh future if one is in progress
    if (_refreshFuture != null) {
      print('[AuthInterceptor] Waiting for ongoing refresh...');
      return await _refreshFuture!;
    }

    // Create new refresh future
    _refreshFuture = _performRefresh();

    try {
      final result = await _refreshFuture!;
      return result;
    } finally {
      _refreshFuture = null;
    }
  }

  /// Perform the actual token refresh
  Future<bool> _performRefresh() async {
    try {
      final refreshToken = _tokenManager.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        print('[AuthInterceptor] No refresh token available');
        return false;
      }

      print('[AuthInterceptor] Calling refresh endpoint...');

      final response = await _refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['data']['accessToken'];
        final newRefreshToken = response.data['data']['refreshToken'];

        if (newAccessToken == null) {
          print('[AuthInterceptor] No access token in refresh response');
          return false;
        }

        _tokenManager.updateAccessToken(newAccessToken);

        if (newRefreshToken != null) {
          _tokenManager.updateRefreshToken(newRefreshToken);
        }

        print('[AuthInterceptor] Token refresh successful');
        return true;
      }

      print(
        '[AuthInterceptor] Refresh failed with status ${response.statusCode}',
      );
      return false;
    } on DioException catch (e) {
      print('[AuthInterceptor] Refresh request failed: ${e.message}');

      // Check if refresh token is invalid/expired (401, 403)
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        print('[AuthInterceptor] Refresh token invalid/expired, logging out');
        return false;
      }

      return false;
    } catch (e) {
      print('[AuthInterceptor] Unexpected error during refresh: $e');
      return false;
    }
  }

  /// Handle refresh failure - logout and clear state
  Future<void> _handleRefreshFailure(RequestInterceptorHandler handler) async {
    print('[AuthInterceptor] Refresh failed, logging out...');

    // Clear tokens
    await _tokenManager.clearTokens();

    // Cancel pending requests
    handler.reject(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
        error: 'Authentication failed',
      ),
    );

    // Navigate to login
    if (Get.context != null) {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  /// Retry the original request with new token
  Future<void> _retry(
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) async {
    print('[AuthInterceptor] Retrying request...');

    try {
      final token = _tokenManager.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      // Mark as retried to prevent infinite loops
      options.extra['_retry'] = true;

      final response = await _refreshDio.request<dynamic>(
        options.path,
        options: Options(
          method: options.method,
          headers: options.headers,
          contentType: options.contentType,
        ),
        data: options.data,
        queryParameters: options.queryParameters,
      );

      return handler.resolve(response);
    } catch (e) {
      return handler.next(DioException(requestOptions: options, error: e));
    }
  }

  /// Check if endpoint is public (doesn't require auth)
  bool _isPublicEndpoint(String path) {
    return _publicEndpoints.any((endpoint) => path.contains(endpoint));
  }
}
