import 'package:hijabiswap/core/network/endpoints.dart';
import 'package:hijabiswap/data/models/activity_model.dart';
import 'package:hijabiswap/data/services/api_service.dart';

class ActivityService {
  Future<ActivityResponse> getSentRequests() async {
    final response = await ApiService.dio.get(ApiEndpoints.sentRequests);

    print('Raw Sent Requests API Response: ${response.data}');

    final code = response.statusCode ?? 0;
    if (code >= 200 && code < 300) {
      return ActivityResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load sent requests');
    }
  }

  Future<ActivityResponse> getReceivedRequests() async {
    // Implementation for fetching received requests
    try {
      final response = await ApiService.dio.get(ApiEndpoints.receivedRequests);

      print('Raw Received Requests API Response: ${response.data}');

      if (response.statusCode == 200) {
        return ActivityResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load received requests');
      }
    } catch (e) {
      print('Error in getReceivedRequests: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> acceptRequest(String requestId) async {
    final response = await ApiService.dio.put(
      ApiEndpoints.acceptRequest(requestId),
    );

    print('Raw Accept Request API Response: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception('Failed to accept request');
    }

    return response.data;
  }

  Future<Map<String, dynamic>> rejectRequest(String requestId) async {
    final response = await ApiService.dio.put(
      ApiEndpoints.rejectRequest(requestId),
    );

    print('Raw Reject Request API Response: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception('Failed to reject request');
    }

    return response.data;
  }

  Future<Map<String, dynamic>> confirmRequest(
    String requestId,
    Map<String, dynamic> data,
  ) async {
    final response = await ApiService.dio.put(
      ApiEndpoints.confirmRequest(requestId),
      data: data,
    );

    print('Raw Confirm Request API Response: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception('Failed to confirm request');
    }

    return response.data;
  }

  Future<Map<String, dynamic>> cancelRequest(String requestId) async {
    final response = await ApiService.dio.put(
      ApiEndpoints.cancelRequest(requestId),
    );

    print('Raw Cancel Request API Response: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel request');
    }

    return response.data;
  }
}
