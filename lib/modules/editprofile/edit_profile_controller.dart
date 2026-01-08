import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hijabiswap/data/services/profile_service.dart';
import 'package:hijabiswap/modules/profile/profile_controller.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  late ProfileController profileController;
  final ProfileService _profileService = ProfileService();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    profileController = Get.find<ProfileController>();

    // Initialize text controllers with profile data
    if (profileController.profileData.isNotEmpty) {
      nameController.text = profileController.profileData[0].name;
      cityController.text = profileController.profileData[0].city;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    cityController.dispose();
    super.onClose();
  }

  void setProfileImage(XFile image) {
    selectedImage.value = File(image.path);
  }

  Future<void> pickProfileImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setProfileImage(image);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> updateProfile(String name, String city, String imageUrl) async {
    if (name.isEmpty || city.isEmpty) {
      Get.snackbar(
        'Error',
        'Name and City cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final updatedProfile = await _profileService.updateUserProfile(
        name: name,
        city: city,
        imageUrl: selectedImage.value?.path ?? imageUrl,
        hasNewImage: selectedImage.value != null,
      );

      await Future.delayed(const Duration(milliseconds: 100));
      Get.find<ProfileController>().profileData.value = [updatedProfile];
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
      print('Profile updated successfully: $updatedProfile');
    } catch (e) {
      print('Error updating profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
