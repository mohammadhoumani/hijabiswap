import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijabiswap/core/network/dio_exception.dart';
import 'package:hijabiswap/core/network/token_manager.dart';
import 'package:hijabiswap/data/services/auth_service.dart';
import 'package:hijabiswap/data/services/fcm_service.dart';
import 'package:hijabiswap/routes/app_routes.dart';
import 'package:geolocator/geolocator.dart';

class AuthController extends GetxController {
  final AuthService _auth = AuthService();
  final TokenManager _tokenManager = TokenManager();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cityController = TextEditingController();

  RxBool loading = false.obs;

  Future<void> login(String email, String password) async {
    print('[AuthController] Login called');

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password cannot be empty',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    loading.value = true;
    try {
      final loginData = await _auth.login(email, password);

      // Store tokens via TokenManager (access in memory, refresh in storage)
      _tokenManager.setTokens(loginData.accessToken, loginData.refreshToken);

      // Send FCM token but don't block on failure
      FcmService().sendFcmToken().catchError((e) {
        print('[AuthController] FCM token send failed: $e');
      });

      print('[AuthController] Login successful');

      Get.snackbar(
        'Success',
        'Logged in successfully',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      Get.offAllNamed(AppRoutes.navbar);
    } on DioException catch (e) {
      print('[AuthController] DioException: $e');
      final message = DioExceptions.getErrorMessage(e);

      Get.snackbar(
        'Error',
        message,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      print('[AuthController] Exception: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String city,
    double longitude,
    double latitude,
  ) async {
    print('[AuthController] Register called');

    if (name.isEmpty || email.isEmpty || password.isEmpty || city.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    loading.value = true;
    try {
      await _auth.register(name, email, password, city, longitude, latitude);

      print('[AuthController] Registration successful');

      Get.snackbar(
        'Success',
        'Registered successfully, check your email to confirm your account',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      Get.offAllNamed(AppRoutes.login);
    } on DioException catch (e) {
      print('[AuthController] DioException: $e');
      final message = DioExceptions.getErrorMessage(e);

      Get.snackbar(
        'Error',
        message,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      print('[AuthController] Exception: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> registerWithLocation(
    String name,
    String email,
    String password,
    String city,
  ) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || city.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    loading.value = true;

    try {
      // Check if location service is enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location',
          'Please enable location services',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      // Check/request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location',
          'Location permission is required to sign up',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Call existing register method with location data
      await register(
        name,
        email,
        password,
        city,
        position.longitude,
        position.latitude,
      );
    } catch (e) {
      print('[AuthController] Location error: $e');
      Get.snackbar(
        'Error',
        'Unable to get location: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> forgotPassword(String email) async {
    print('[AuthController] Forgot Password called');

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email cannot be empty',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    loading.value = true;
    try {
      await _auth.forgotPassword(email);

      print('[AuthController] Forgot Password request successful');

      Get.snackbar(
        'Success',
        'Password reset instructions sent to your email',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } on DioException catch (e) {
      print('[AuthController] DioException: $e');
      final message = DioExceptions.getErrorMessage(e);

      Get.snackbar(
        'Error',
        message,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      print('[AuthController] Exception: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      loading.value = false;
    }
  }

  /// Logout - clear all tokens and navigate to login
}
