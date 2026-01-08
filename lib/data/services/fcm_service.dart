import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hijabiswap/core/network/endpoints.dart';
import 'package:hijabiswap/data/services/api_service.dart';

// TOP-LEVEL FUNCTION (REQUIRED for background/terminated messages)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('[FCM-BG] Background message received: ${message.messageId}');
  print('[FCM-BG] Title: ${message.notification?.title}');
  print('[FCM-BG] Body: ${message.notification?.body}');
  print('[FCM-BG] Data: ${message.data}');
}

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Initialize FCM and notification handlers
  Future<void> initialize() async {
    // Request permissions (iOS)
    await _requestPermission();

    // Setup local notifications
    await _setupLocalNotifications();

    // Setup listeners
    _setupForegroundHandler();
    _setupBackgroundHandler();
    _setupTerminatedHandler();

    // Setup token refresh
    setupTokenRefreshListener();
  }

  // Request notification permissions (iOS)
  Future<void> _requestPermission() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    print('[FCM] Permission status: ${settings.authorizationStatus}');
  }

  // Setup local notifications for foreground display
  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Handle notification tap (when app is opened from notification)
  void _onNotificationTapped(NotificationResponse response) {
    print('[FCM] Notification tapped: ${response.payload}');
    // TODO: Navigate to specific screen based on notification data
    // Example: Get.toNamed(AppRoutes.activity);
  }

  // FOREGROUND: Handle messages when app is open
  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('[FCM-FG] Foreground message received: ${message.messageId}');
      print('[FCM-FG] Title: ${message.notification?.title}');
      print('[FCM-FG] Body: ${message.notification?.body}');
      print('[FCM-FG] Data: ${message.data}');

      // Show local notification when app is in foreground
      if (message.notification != null) {
        _showLocalNotification(message);
      }

      // Handle data payload
      _handleNotificationData(message.data);
    });
  }

  // BACKGROUND: Handle messages when app is in background
  void _setupBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // TERMINATED: Handle messages when app is terminated and opened via notification
  Future<void> _setupTerminatedHandler() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('[FCM-TERMINATED] App opened from terminated state');
      print('[FCM-TERMINATED] Title: ${initialMessage.notification?.title}');
      print('[FCM-TERMINATED] Body: ${initialMessage.notification?.body}');
      print('[FCM-TERMINATED] Data: ${initialMessage.data}');

      // Handle navigation after app is ready
      _handleNotificationData(initialMessage.data);
    }

    // Listen for when user taps notification while app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('[FCM-OPENED] App opened from background notification');
      print('[FCM-OPENED] Title: ${message.notification?.title}');
      print('[FCM-OPENED] Body: ${message.notification?.body}');
      print('[FCM-OPENED] Data: ${message.data}');

      _handleNotificationData(message.data);
    });
  }

  // Show local notification (for foreground)
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: message.data.toString(),
    );
  }

  // Handle notification data and navigation
  void _handleNotificationData(Map<String, dynamic> data) {
    print('[FCM] Handling notification data: $data');

    // TODO: Add your navigation logic based on notification type
    // Example:
    // if (data['type'] == 'request') {
    //   Get.toNamed(AppRoutes.activity);
    // } else if (data['type'] == 'message') {
    //   Get.toNamed(AppRoutes.chat, arguments: data['chatId']);
    // }
  }

  Future<void> sendFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        print('[FCM] Token is null, cannot send to server');
        return;
      }

      final response = await ApiService.dio.post(
        ApiEndpoints.sendFcmToken,
        data: {'deviceToken': token},
      );
      print('[FCM] Token sent successfully: $token');
      print('[FCM] Response: ${response.data}');
    } catch (e) {
      print('[FCM] Error sending token: $e');
    }
  }

  Future<void> setupTokenRefreshListener() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('[FCM] Token refreshed: $newToken');
      sendFcmToken();
    });
  }

  Future<void> deleteFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      print('[FCM] Deleting token: $token');

      if (token != null) {
        print('[FCM] Sending delete request to server');
        try {
          final response = await ApiService.dio.delete(
            ApiEndpoints.deleteFcmToken,
            data: {'deviceToken': token},
          );
          print('[FCM] Token deletion response: ${response.data}');
        } catch (e) {
          print('[FCM] Error sending delete request to server: $e');
        }
        print('[FCM] Token deletion request sent to server');
        await FirebaseMessaging.instance.deleteToken();
        print('[FCM] Token deleted successfully');
      }
    } catch (e) {
      print('[FCM] Error deleting token: $e');
    }
  }
}
