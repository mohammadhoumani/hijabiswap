import 'package:get/get.dart';
import 'package:hijabiswap/data/services/activity_service.dart';
import 'package:hijabiswap/modules/activity/activity_controller.dart';

class ConfirmOrderController extends GetxController {
  final ActivityService _activityService = ActivityService();

  final RxBool isLoading = false.obs;

  Future<bool> confirmOrder({
    required String requestId,
    required Map<String, dynamic> data,
  }) async {
    var success = false;
    try {
      isLoading.value = true;
      await _activityService.confirmRequest(requestId, data);
      print('Confirmed order with Request ID: $requestId');
      Get.find<ActivityController>().fetchSentRequests();
      Get.back();
      await Future.delayed(const Duration(milliseconds: 100));
      Get.snackbar(
        'Success',
        'Order confirmed successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
      success = true;
    } catch (e) {
      print('Error confirming order: $e');
      Get.snackbar(
        'Error',
        'Failed to confirm order',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
    } finally {
      isLoading.value = false;
    }

    return success;
  }
}
