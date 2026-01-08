import 'package:get/get.dart';
import 'package:hijabiswap/data/models/profile_model.dart';
import 'package:hijabiswap/data/services/auth_service.dart';
import 'package:hijabiswap/data/services/profile_service.dart';
import 'package:hijabiswap/modules/auth/controllers/auth_controller.dart';
import 'package:hijabiswap/modules/home/home_controller.dart';
import 'package:hijabiswap/theme/app_colors.dart';

class ProfileController extends GetxController {
  final _profileService = ProfileService();
  final RxList<ProfileData> profileData = <ProfileData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdatingShippingAddress = false.obs;

  Future<void> loadUserProfile() async {
    try {
      final response = await _profileService.fetchUserProfile();
      profileData.value = [response.data];
      print('User Profile Data: ${response.data}');
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> logout() async {
    // Implement logout logic here
    try {
      isLoading.value = true;
      // For example, clear user session, tokens, etc.
      await AuthService().logout();
      print('User logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      isLoading.value = false;
    }
    // e.g., clear tokens, navigate to login screen, etc.
  }

  Future<void> updateShippingAddress({
    required String street,
    required String city,
    required String postalCode,
    required String country,
  }) async {
    isUpdatingShippingAddress.value = true;
    try {
      await _profileService.updateShippingAddress(
        street: street,
        city: city,
        postalCode: postalCode,
        country: country,
      );
      Get.back();
      Get.snackbar(
        'Success',
        'Shipping address updated successfully',
        colorText: AppColors.white,
        backgroundColor: AppColors.green,
        snackPosition: SnackPosition.TOP,
      );
      await loadUserProfile();
      Get.find<HomeController>().haveShippingAddress.value = true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update shipping address',
        colorText: AppColors.white,
        backgroundColor: AppColors.primary,
        snackPosition: SnackPosition.BOTTOM,
      );

      print('Error updating shipping address: $e');
    } finally {
      isUpdatingShippingAddress.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    // Initialize profile data here
  }
}
