import 'package:dio/dio.dart' as dio;
import 'package:hijabiswap/core/network/endpoints.dart';
import 'package:hijabiswap/data/models/profile_model.dart';
import 'package:hijabiswap/data/services/api_service.dart';

class ProfileService {
  Future<ProfileResponse> fetchUserProfile() async {
    final response = await ApiService.dio.get(ApiEndpoints.userProfile);

    print('[ProfileService] Raw API Response: ${response.data}');

    try {
      final profileResponse = ProfileResponse.fromJson(response.data);
      print('[ProfileService] Parsed ProfileResponse: $profileResponse');
      return profileResponse;
    } catch (e) {
      print('[ProfileService] JSON Parsing Error: $e');
      rethrow;
    }
  }

  Future<void> rateUser({
    required String requestId,
    required int rating,
    String? comment,
  }) async {
    final data = {
      'requestId': requestId,
      'rating': rating,
      if (comment != null) 'comment': comment,
    };

    final response = await ApiService.dio.post(
      ApiEndpoints.rateUser,
      data: data,
    );

    print('[ProfileService] Raw Rate User API Response: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('[ProfileService] User rated successfully.');
    } else {
      print('[ProfileService] Failed to rate user.');
      throw Exception('Failed to rate user');
    }
  }
  Future<void> updateShippingAddress({
    required String street,
    required String city,
    required String postalCode,
    required String country,
  }) async {
    final data = {
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    };

    final response = await ApiService.dio.put(
      ApiEndpoints.updateShippingAddress,
      data: data,
    );

    print(
      '[ProfileService] Raw Update Shipping Address API Response: ${response.data}',
    );

    if (response.statusCode == 200) {
      print('[ProfileService] Shipping address updated successfully.');
    } else {
      print('[ProfileService] Failed to update shipping address.');
      throw Exception('Failed to update shipping address');
    }
  }

  Future<ProfileData> updateUserProfile({
    required String name,
    required String city,
    required String imageUrl,
    bool hasNewImage = false,
  }) async {
    final Map<String, dynamic> dataMap = {'name': name, 'city': city};

    // Only add image if a new one is selected
    if (hasNewImage && imageUrl.isNotEmpty) {
      dataMap['image'] = await dio.MultipartFile.fromFile(
        imageUrl,
        filename: imageUrl.split('/').last,
      );
    }

    final formData = dio.FormData.fromMap(dataMap);

    final response = await ApiService.dio.put(
      ApiEndpoints.updateProfile,
      data: formData,
    );

    print('[ProfileService] Raw Update API Response: ${response.data}');

    try {
      final profileResponse = ProfileResponse.fromJson(response.data);
      print(
        '[ProfileService] Parsed Updated ProfileResponse: $profileResponse',
      );
      return profileResponse.data;
    } catch (e) {
      print('[ProfileService] Update JSON Parsing Error: $e');
      rethrow;
    }
  }
}
