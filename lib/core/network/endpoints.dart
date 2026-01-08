class ApiEndpoints {
  static const String baseUrl =
      "https://hijabi-api-70d0973ee2e7.herokuapp.com//api/v1";
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String forgotPassword = "/auth/forgot-password";
  static const String refreshToken = "/auth/refresh";
  static const String products = "/items";
  static const String myProducts = "/items/my/items";
  static const String requestProduct = "/requests";
  static const String addProduct = "/items";
  static const String getLikedProducts = "/items/my/likes";
  static const String userProfile = "/users/me";
  static const String updateProfile = "/users/me";
  static const String sentRequests = "/requests/sent";
  static const String receivedRequests = "/requests/received";
  static const String notifications = "/notifications";
  static const String sendFcmToken = "/auth/device-token";
  static const String deleteFcmToken = "/auth/device-token";
  static const String markAllNotificationsAsRead = "/notifications/read-all";
  static const String updateShippingAddress = "/users/me/shipping-address";
  static const String rateUser = "/ratings";

  static String confirmRequest(String requestId) =>
      "/requests/$requestId/confirm";

  static String markNotificationAsRead(String notificationId) =>
      "/notifications/$notificationId/read";

  static String editProduct(String productId) => "/items/$productId";

  static String deleteProduct(String productId) => "/items/$productId";

  static String likeProduct(String productId) => "/items/$productId/like";

  static String acceptRequest(String requestId) =>
      "/requests/$requestId/accept";

  static String rejectRequest(String requestId) =>
      "/requests/$requestId/reject";

  static String cancelRequest(String requestId) =>
      "/requests/$requestId/cancel";
}
