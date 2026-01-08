import 'package:get/get.dart';
import 'package:hijabiswap/core/network/endpoints.dart';
import 'package:hijabiswap/core/network/token_manager.dart';
import 'package:hijabiswap/data/models/auth_model.dart';
import 'package:hijabiswap/data/services/api_service.dart';
import 'package:hijabiswap/data/services/fcm_service.dart';
import 'package:hijabiswap/routes/app_routes.dart';

class AuthService {
  final TokenManager _tokenManager = TokenManager();

  Future<LoginData> login(String email, String password) async {
    final response = await ApiService.dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    print('[AuthService] Raw API Response: ${response.data}');

    try {
      final loginResponse = LoginResponse.fromJson(response.data);
      print('[AuthService] Parsed LoginResponse: $loginResponse');
      return loginResponse.data;
    } catch (e) {
      print('[AuthService] JSON Parsing Error: $e');
      rethrow;
    }
  }

  Future<RegisterData> register(
    String name,
    String email,
    String password,
    String city,
    double longitude,
    double latitude,
  ) async {
    final startTime = DateTime.now();
    print('[AuthService] Register API call started at: $startTime');

    final response = await ApiService.dio.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'city': city,
        'coordinates': {'longitude': longitude, 'latitude': latitude},
      },
    );

    final endTime = DateTime.now();
    print('[AuthService] Register API call ended at: $endTime');
    print(
      '[AuthService] Register API call duration: ${endTime.difference(startTime).inSeconds} seconds',
    );
    print('[AuthService] Raw Register API Response: ${response.data}');

    try {
      final parsed = RegisterResponse.fromJson(response.data);
      return parsed.data;
    } catch (e) {
      print('[AuthService] Register JSON Parsing Error: $e');
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    final response = await ApiService.dio.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );

    print('[AuthService] Forgot Password API Response: ${response.data}');
  }

  /// Logout - clear all tokens
  Future<void> logout() async {
    print('[AuthController] Logout called');
    try {
      // Optional: Delete FCM token from backend
      await FcmService().deleteFcmToken();
      await _tokenManager.clearTokens();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      print('[AuthController] Error during logout: $e');
    }
  }
}
