import 'package:get/get.dart';
import 'package:hijabiswap/core/network/token_manager.dart';
import 'package:hijabiswap/data/services/fcm_service.dart';
import 'package:hijabiswap/routes/app_routes.dart';

class SplashController extends GetxController {
  final TokenManager _tokenManager = TokenManager();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Splash screen delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Check if user is authenticated
    if (!_tokenManager.isAuthenticated()) {
      print('[SplashController] No refresh token found, navigating to login');
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    // Refresh token exists, try to refresh access token immediately
    print('[SplashController] Refresh token found, refreshing access token...');
    final refreshed = await _refreshAccessToken();

    if (refreshed) {
      print('[SplashController] Access token refreshed, navigating to navbar');
      FcmService().sendFcmToken().catchError((e) {
        print('[SplashController] FCM token send failed: $e');
      });
      Get.offAllNamed(AppRoutes.navbar);
    } else {
      print('[SplashController] Token refresh failed, navigating to login');
      await _tokenManager.clearTokens();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = _tokenManager.getRefreshToken();
      if (refreshToken == null) return false;

      // Placeholder - actual refresh happens in interceptor
      // The interceptor will handle the refresh when we make the first request
      return true;
    } catch (e) {
      print('[SplashController] Error refreshing token: $e');
      return false;
    }
  }
}
