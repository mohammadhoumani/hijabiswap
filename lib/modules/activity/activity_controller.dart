import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijabiswap/data/models/activity_model.dart';
import 'package:hijabiswap/data/services/activity_service.dart';
import 'package:hijabiswap/data/services/profile_service.dart';

class ActivityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ActivityService _activityService = ActivityService();

  late final TabController tabController;

  final RxBool isLoadingReceived = false.obs;
  final RxString receivedError = ''.obs;
  final RxList<ActivityRequest> receivedRequests = <ActivityRequest>[].obs;

  final RxBool isLoadingSent = false.obs;
  final RxString sentError = ''.obs;
  final RxList<ActivityRequest> sentRequests = <ActivityRequest>[].obs;
  final RxString sentStatusFilter = 'all'.obs;
  final RxString receivedStatusFilter = 'all'.obs;
  final RxMap<String, bool> acceptLoading = <String, bool>{}.obs;
  final RxMap<String, bool> rejectLoading = <String, bool>{}.obs;
  final RxMap<String, bool> cancelLoading = <String, bool>{}.obs;

  Future<void> fetchSentRequests() async {
    isLoadingSent.value = true;
    sentError.value = '';
    try {
      final response = await _activityService.getSentRequests();
      sentRequests.assignAll(response.data);
    } catch (e) {
      print('Error fetching sent requests: $e');
      sentError.value = 'Could not load sent requests';
    } finally {
      isLoadingSent.value = false;
    }
  }

  Future<void> fetchReceivedRequests() async {
    isLoadingReceived.value = true;
    receivedError.value = '';
    try {
      final response = await _activityService.getReceivedRequests();
      receivedRequests.assignAll(response.data);
    } catch (e) {
      print('Error fetching received requests: $e');
      receivedError.value = 'Could not load received requests';
    } finally {
      isLoadingReceived.value = false;
    }
  }

  void setSentStatusFilter(String value) => sentStatusFilter.value = value;
  void setReceivedStatusFilter(String value) =>
      receivedStatusFilter.value = value;

  List<ActivityRequest> filterByStatus(
    List<ActivityRequest> source,
    String filter,
  ) {
    final target = _normalizeStatus(filter);
    if (target == 'all') return List<ActivityRequest>.from(source);
    return source
        .where((r) => _normalizeStatus(r.status) == target)
        .toList(growable: false);
  }

  String _normalizeStatus(String status) {
    final s = status.toLowerCase();
    if (s.startsWith('pend')) return 'pending';
    if (s.startsWith('accept')) return 'accepted';
    if (s.startsWith('confirm')) return 'confirmed';
    if (s.startsWith('complete')) return 'completed';
    if (s.startsWith('reject')) return 'rejected';
    if (s.startsWith('cancel')) return 'cancelled';
    return s;
  }

  Future<void> acceptRequest(String requestId) async {
    if (acceptLoading[requestId] == true) return;
    acceptLoading[requestId] = true;
    try {
      await _activityService.acceptRequest(requestId);
      Get.snackbar(
        'Success',
        'Request accepted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchReceivedRequests();
    } catch (e) {
      print('Error accepting request: $e');
      Get.snackbar(
        'Error',
        'Failed to accept request',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    acceptLoading[requestId] = false;
  }

  Future<void> rejectRequest(String requestId) async {
    if (rejectLoading[requestId] == true) return;
    rejectLoading[requestId] = true;
    try {
      await _activityService.rejectRequest(requestId);
      Get.snackbar(
        'Success',
        'Request rejected successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchReceivedRequests();
    } catch (e) {
      print('Error rejecting request: $e');
      Get.snackbar(
        'Error',
        'Failed to reject request',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    rejectLoading[requestId] = false;
  }

  Future<void> cancelRequest(String requestId) async {
    if (cancelLoading[requestId] == true) return;
    cancelLoading[requestId] = true;
    try {
      await _activityService.cancelRequest(requestId);
      fetchSentRequests();
      Get.snackbar(
        'Success',
        'Request cancelled successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error cancelling request: $e');
      Get.snackbar(
        'Error',
        'Failed to cancel request',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    cancelLoading[requestId] = false;
  }

  Future<void> rateUser({
    required String requestId,
    required int rating,
    String? comment,
  }) async {
    try {
      await ProfileService().rateUser(
        requestId: requestId,
        rating: rating,
        comment: comment,
      );
      Get.snackbar(
        'Success',
        'User rated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchSentRequests();
    } catch (e) {
      print('Error rating user: $e');
      Get.snackbar(
        'Error',
        'Failed to rate user',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchSentRequests();
    fetchReceivedRequests();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
