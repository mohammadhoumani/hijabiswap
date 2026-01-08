import 'package:dio/dio.dart';
import 'package:hijabiswap/core/network/auth_interceptor.dart';
import 'package:hijabiswap/core/network/endpoints.dart';
import 'package:hijabiswap/core/network/logging_interceptor.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      contentType: 'application/json',
    ),
  )..interceptors.addAll([LoggingInterceptor(), AuthInterceptor()]);
}
