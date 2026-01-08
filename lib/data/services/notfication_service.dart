import 'package:hijabiswap/core/network/endpoints.dart';
import 'package:hijabiswap/data/models/notification_model.dart';
import 'package:hijabiswap/data/services/api_service.dart';

class NotficationService {
  Future<NotificationModel> fetchNotifications() async {
    try {
      final reponse = await ApiService.dio.get(ApiEndpoints.notifications);
      print(reponse.data);
      return NotificationModel.fromJson(reponse.data);
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await ApiService.dio.put(
        ApiEndpoints.markNotificationAsRead(notificationId),
      );
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await ApiService.dio.put(ApiEndpoints.markAllNotificationsAsRead);
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }
}
