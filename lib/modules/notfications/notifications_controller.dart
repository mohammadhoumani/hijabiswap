import 'package:get/get.dart';
import 'package:hijabiswap/data/models/notification_model.dart';
import 'package:hijabiswap/data/services/notfication_service.dart';
import 'package:hijabiswap/modules/home/home_controller.dart';

class NotificationsController extends GetxController {
  final NotficationService notificationService = NotficationService();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<NotificationModel?> notificationModel = Rx<NotificationModel?>(null);
  final RxString filterStatus = 'all'.obs; // 'all', 'read', 'unread'

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final notifications = await notificationService.fetchNotifications();
      notificationModel.value = notifications;
    } catch (e) {
      errorMessage.value = 'Failed to load notifications: $e';
      print('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      await notificationService.markAllAsRead();
      loadNotifications();
      Get.find<HomeController>().unreadNotificationsCount.value = 0;
      // Update local state
      print('All notifications marked as read');
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await notificationService.markAsRead(notificationId);
      loadNotifications();
      Get.find<HomeController>().unreadNotificationsCount.value--;
      // Update local state
      print('Notification $notificationId marked as read');
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }
}
