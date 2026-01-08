import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/modules/notfications/notifications_controller.dart';
import 'package:hijabiswap/modules/notfications/widgets/notfications_skeleton_loader.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/routes/app_routes.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.checkDouble, size: 20),
            color: AppColors.primary,
            onPressed: () {
              controller.markAllNotificationsAsRead();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const NotificationsSkeletonLoader();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: AppColors.primary, size: 48),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.primary),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.loadNotifications(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final notifications = controller.notificationModel.value?.data ?? [];

        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  color: AppColors.darkGrey,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No notifications yet',
                  style: TextStyle(fontSize: 16, color: AppColors.darkGrey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', 'all'),
                    const SizedBox(width: 12),
                    _buildFilterChip('Unread', 'unread'),
                    const SizedBox(width: 12),
                    _buildFilterChip('Read', 'read'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final filteredNotifications = _getFilteredNotifications(
                  notifications,
                  controller.filterStatus.value,
                );

                if (filteredNotifications.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${controller.filterStatus.value == 'all' ? '' : controller.filterStatus.value} notifications',
                      style: const TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filteredNotifications.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final notification = filteredNotifications[index];
                    return _buildNotificationCard(notification);
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Obx(() {
      final isSelected = controller.filterStatus.value == value;
      return GestureDetector(
        onTap: () => controller.filterStatus.value = value,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.darkGrey,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.darkGrey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNotificationCard(dynamic notification) {
    return GestureDetector(
      onTap: () async {
        if (!notification.isRead) {
          await controller.markNotificationAsRead(notification.id);
        }
        _navigateForNotification(notification);
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              notification.isRead
                  ? AppColors.white
                  : AppColors.peach.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                notification.isRead
                    ? Colors.grey.withOpacity(0.2)
                    : AppColors.peach,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          notification.isRead
                              ? AppColors.darkGrey.withOpacity(0.1)
                              : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      notification.isRead
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color:
                          notification.isRead
                              ? AppColors.darkGrey
                              : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                            color:
                                notification.isRead
                                    ? AppColors.secondary
                                    : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(notification.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                notification.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.secondary.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateForNotification(dynamic n) {
    final String type = (n.type as String?) ?? 'GENERAL';
    final dynamic meta = n.metadata;
    final String? requestId = meta?.requestId as String?;
    final String? itemId = meta?.itemId as String?;

    switch (type) {
      case 'REQUEST_ACCEPTED':
        if (requestId != null && requestId.isNotEmpty) {
          Get.toNamed(
            AppRoutes.confirmOrder,
            arguments: {'requestId': requestId},
          );
        } else {
          Get.toNamed(AppRoutes.activity);
        }
        break;
      case 'NEW_REQUEST':
      case 'REQUEST_REJECTED':
      case 'REQUEST_CANCELLED':
      case 'ORDER_CONFIRMED':
      case 'ORDER_SHIPPED':
      case 'ORDER_COMPLETED':
      case 'AUTO_CANCEL_WARNING':
      case 'AUTO_CANCEL':
        Get.toNamed(AppRoutes.activity);
        break;
      case 'NEW_RATING':
        Get.toNamed(AppRoutes.profile);
        break;
      case 'ITEM_LIKED':
        // If product details route exists, prefer that with itemId
        Get.back();
        break;
      case 'GENERAL':
      default:
        // Stay in notifications or go to home/activity
        Get.toNamed(AppRoutes.notifications);
        break;
    }
  }

  List _getFilteredNotifications(List notifications, String filterStatus) {
    if (filterStatus == 'read') {
      return notifications.where((n) => n.isRead).toList();
    } else if (filterStatus == 'unread') {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications;
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
