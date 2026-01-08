import 'package:dio/dio.dart';

class DioExceptions {
  static String getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timed out. Please try again.";
      case DioExceptionType.sendTimeout:
        return "Request timed out. Please try again.";
      case DioExceptionType.receiveTimeout:
        return "Server took too long to respond.";
      case DioExceptionType.badResponse:
        // Backend returned an error code (400, 401, 500...)
        if (error.response != null && error.response!.data != null) {
          return error.response!.data['message'] ?? "Server error occurred.";
        }
        return "Server error occurred.";
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      case DioExceptionType.unknown:
      default:
        return "Something went wrong. Check your connection.";
    }
  }
}
