import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hijabiswap/core/network/endpoints.dart';
import 'package:hijabiswap/data/models/favorites_model.dart';
import 'package:hijabiswap/data/models/products_model.dart';
import 'package:hijabiswap/data/services/api_service.dart';
import 'package:path/path.dart' as p;

class ProductService {
  Future<ProductsResponse> fetchProducts({int page = 1, int limit = 20}) async {
    final response = await ApiService.dio.get(
      ApiEndpoints.products,
      queryParameters: {'page': page, 'limit': limit},
    );

    print('Raw Products API Response: ${response.data}');

    try {
      final productsResponse = ProductsResponse.fromJson(response.data);
      return productsResponse;
    } catch (e) {
      print('Products JSON Parsing Error: $e');
      rethrow;
    }
  }

  Future<void> requestProduct({
    required String id,
    required String message,
  }) async {
    final response = await ApiService.dio.post(
      ApiEndpoints.requestProduct,
      data: {'itemId': id, 'message': message},
    );

    print('Raw Request Product API Response: ${response.data}');

    final code = response.statusCode ?? 0;
    final is2xx = code >= 200 && code < 300;

    // Optional: also check API success flag if present
    final successFlag =
        response.data is Map<String, dynamic>
            ? (response.data['success'] == true)
            : true;

    if (!is2xx || !successFlag) {
      throw Exception('Failed to request product');
    }
  }

  Future<MyProductsResponse> fetchMyProducts() async {
    final response = await ApiService.dio.get(ApiEndpoints.myProducts);

    print('Raw My Products API Response: ${response.data}');

    try {
      final myProductsResponse = MyProductsResponse.fromJson(response.data);
      return myProductsResponse;
    } catch (e) {
      print('My Products JSON Parsing Error: $e');
      rethrow;
    }
  }

  Future<void> likeProduct(String productId) async {
    final response = await ApiService.dio.post(
      ApiEndpoints.likeProduct(productId),
    );

    print('Raw Like Product API Response: ${response.data}');

    final code = response.statusCode ?? 0;
    final is2xx = code >= 200 && code < 300;

    // Optional: also check API success flag if present
    final successFlag =
        response.data is Map<String, dynamic>
            ? (response.data['success'] == true)
            : true;

    if (!is2xx || !successFlag) {
      throw Exception('Failed to like product');
    }
  }

  Future<void> unlikeProduct(String productId) async {
    final response = await ApiService.dio.delete(
      ApiEndpoints.likeProduct(productId),
    );

    print('Raw Unlike Product API Response: ${response.data}');

    final code = response.statusCode ?? 0;
    final is2xx = code >= 200 && code < 300;

    // Optional: also check API success flag if present
    final successFlag =
        response.data is Map<String, dynamic>
            ? (response.data['success'] == true)
            : true;

    if (!is2xx || !successFlag) {
      throw Exception('Failed to unlike product');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final response = await ApiService.dio.delete(
      ApiEndpoints.deleteProduct(productId),
    );

    print('Raw Delete Product API Response: ${response.data}');

    final code = response.statusCode ?? 0;
    final is2xx = code >= 200 && code < 300;

    // Optional: also check API success flag if present
    final successFlag =
        response.data is Map<String, dynamic>
            ? (response.data['success'] == true)
            : true;

    if (!is2xx || !successFlag) {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> editProduct(
    String productId, {
    required String namePk,
    required String size,
    required String type,
    required List<String> color,
    required String category,
    required String description,
    required List<String> images,
    required bool isAvailable,
    required String condition,
  }) async {
    print('[editProduct] ════════════════════════════════════════════════════════');
    print('[editProduct] 🛠️  Starting editProduct for productId: $productId');
    print('[editProduct] Received ${images.length} image path(s)');

    // Separate URLs vs local files
    final existingUrls = <String>[];
    final List<MultipartFile> newFiles = [];
    for (final path in images) {
      if (path.trim().isEmpty) {
        print('[editProduct] ⏭️  Skipping empty path');
        continue;
      }
      final isUrl = path.startsWith('http://') || path.startsWith('https://');
      if (isUrl) {
        print('[editProduct] 🔗 Found existing URL: $path');
        existingUrls.add(path);
        continue;
      }
      try {
        final file = File(path);
        if (await file.exists()) {
          print('[editProduct] 📁 Found local file: $path (${file.lengthSync()} bytes)');
          newFiles.add(
            await MultipartFile.fromFile(
              file.path,
              filename: p.basename(file.path),
            ),
          );
        } else {
          print('[editProduct] ❌ Skipped missing file: $path');
        }
      } catch (e) {
        print('[editProduct] ❌ Error attaching file $path → $e');
      }
    }

    print('[editProduct] Summary after image processing:');
    print('[editProduct]   • Existing URLs: ${existingUrls.length}');
    print('[editProduct]   • New files: ${newFiles.length}');
    if (existingUrls.isNotEmpty) {
      for (int i = 0; i < existingUrls.length; i++) {
        print('[editProduct]     [$i] ${existingUrls[i]}');
      }
    }

    // Common scalar fields
    print('[editProduct] Building common payload fields...');
    final payloadFields = <String, dynamic>{
      'name_pk': namePk,
      'size': size,
      'type': type,
      'category': category,
      'description': description,
      'isAvailable': isAvailable,
      'condition': condition,
      'color': color, // backend should accept array
    };
    print('[editProduct] Payload: name=$namePk, size=$size, type=$type, condition=$condition');
    print('[editProduct] Colors: ${color.join(", ")}');

    // Decide request type
    final bool useMultipart = newFiles.isNotEmpty;

    if (!useMultipart) {
      // JSON path (no new files)
      print('[editProduct][JSON] ℹ️  Using JSON request (no new files)');
      final body = {...payloadFields, 'images': existingUrls};

      print('[editProduct][JSON] 📤 Sending ${existingUrls.length} existing image URLs');
      print('[editProduct][JSON] Payload: $body');

      try {
        print('[editProduct][JSON] 📋 Body being sent:');
        body.forEach((key, value) {
          if (value is List) {
            print('[editProduct][JSON]   $key: [${value.length} items] ${value.join(", ")}');
          } else {
            print('[editProduct][JSON]   $key: $value');
          }
        });

        final response = await ApiService.dio.put(
          ApiEndpoints.editProduct(productId),
          data: body,
        );

        print('[editProduct][JSON] ✅ Response status: ${response.statusCode}');
        print('[editProduct][JSON] Response data: ${response.data}');

        if ((response.statusCode ?? 0) < 200 ||
            (response.statusCode ?? 0) >= 300) {
          throw Exception('Failed to edit product (JSON path)');
        }
        print('[editProduct][JSON] ✅ Successfully updated product (JSON path)');
        return;
      } catch (e) {
        print('[editProduct][JSON] ❌ Error: $e');
        rethrow;
      }
    }

    // Multipart path (when new files exist)
    print('[editProduct][MULTIPART] ℹ️  Using MULTIPART request (has new files)');
    final formData = FormData();

    // Scalars (excluding color, we'll add it separately)
    print('[editProduct][MULTIPART] Adding scalar fields...');
    payloadFields.forEach((k, v) {
      if (k == 'color') return; // Skip color, we'll add it as array below
      if (v is bool) {
        formData.fields.add(MapEntry(k, v.toString()));
      } else {
        formData.fields.add(MapEntry(k, v.toString()));
      }
    });
    print('[editProduct][MULTIPART] ✓ Added ${formData.fields.length} scalar fields');

    // Colors as array
    print('[editProduct][MULTIPART] Adding colors as array...');
    for (final c in color) {
      if (c.trim().isEmpty) continue;
      formData.fields.add(MapEntry('color[]', c.trim()));
    }
    print('[editProduct][MULTIPART] ✓ Added ${color.length} color(s)');

    // New files and existing URLs (all as images array)
    print('[editProduct][MULTIPART] Adding new file(s) to images...');
    for (final f in newFiles) {
      formData.files.add(MapEntry('images', f));
      print('[editProduct][MULTIPART]   • File: ${f.filename}');
    }
    print('[editProduct][MULTIPART] ✓ Added ${newFiles.length} new image file(s)');

    // Existing URLs to keep - send as a JSON string field for backend to parse
    if (existingUrls.isNotEmpty) {
      print('[editProduct][MULTIPART] Adding existing image URLs...');
      final urlsString = existingUrls.join(',');
      formData.fields.add(
        MapEntry('existingImageUrls', urlsString),
      );
      print('[editProduct][MULTIPART] ✓ Added ${existingUrls.length} existing image URL(s)');
      for (int i = 0; i < existingUrls.length; i++) {
        print('[editProduct][MULTIPART]   [$i] ${existingUrls[i]}');
      }
    } else {
      print('[editProduct][MULTIPART] ℹ️  No existing URLs to keep');
    }

    print('[editProduct][MULTIPART] 📤 Summary:');
    print('[editProduct][MULTIPART]   • New files: ${newFiles.length}');
    print('[editProduct][MULTIPART]   • Existing URLs: ${existingUrls.length}');
    print('[editProduct][MULTIPART]   • Total form fields: ${formData.fields.length}');
    print('[editProduct][MULTIPART]   • Total files: ${formData.files.length}');

    try {
      print('[editProduct][MULTIPART] 🔄 Sending request to server...');
      print('[editProduct][MULTIPART] 📋 Form data being sent:');
      print('[editProduct][MULTIPART] Fields:');
      for (final field in formData.fields) {
        print('[editProduct][MULTIPART]   ${field.key}: ${field.value}');
      }
      print('[editProduct][MULTIPART] Files:');
      for (final file in formData.files) {
        print('[editProduct][MULTIPART]   ${file.key}: ${file.value.filename} (${file.value.contentType})');
      }

      final response = await ApiService.dio.put(
        ApiEndpoints.editProduct(productId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
        // Let Dio set the correct boundary; don't override contentType
      );

      print('[editProduct][MULTIPART] ✅ Response status: ${response.statusCode}');
      print('[editProduct][MULTIPART] Response data: ${response.data}');

      // Check if backend actually updated images
      final responseData = response.data;
      if (responseData is Map && responseData['data'] is Map) {
        final itemData = responseData['data'];
        final returnedImages = itemData['images'] ?? [];
        print('[editProduct][MULTIPART] Backend returned ${returnedImages.length} image(s)');
        if (returnedImages.length != (existingUrls.length + newFiles.length)) {
          print('[editProduct][MULTIPART] ⚠️  Expected ${existingUrls.length + newFiles.length} images but got ${returnedImages.length}');
          print('[editProduct][MULTIPART] ⚠️  This may be a BACKEND issue');
        } else {
          print('[editProduct][MULTIPART] ✓ Image count matches expected total');
        }
      }

      if ((response.statusCode ?? 0) < 200 || (response.statusCode ?? 0) >= 300) {
        throw Exception('Failed to edit product (multipart path)');
      }
      print('[editProduct][MULTIPART] ✅ Successfully updated product (MULTIPART path)');
    } catch (e) {
      print('[editProduct][MULTIPART] ❌ Error: $e');
      rethrow;
    }
  }

  Future<FavoritesResponse> fetchLikedProducts() async {
    final response = await ApiService.dio.get(ApiEndpoints.getLikedProducts);

    print('Raw Liked Products API Response: ${response.data}');

    try {
      final likedProductsResponse = FavoritesResponse.fromJson(response.data);
      return likedProductsResponse;
    } catch (e) {
      print('Liked Products JSON Parsing Error: $e');
      rethrow;
    }
  }

  Future<void> addProduct({
    required String namePk,
    required String size,
    required String type,
    required List<String> color,
    required String category,
    required String description,
    required List<String> images,
    required bool isAvailable,
    required String condition,
  }) async {
    // Convert local file paths to multipart files
    final List<MultipartFile> imageFiles = [];
    for (final path in images) {
      try {
        if (path.isEmpty) continue;
        final file = File(path);
        if (await file.exists()) {
          imageFiles.add(
            await MultipartFile.fromFile(
              file.path,
              filename: p.basename(file.path),
            ),
          );
        }
      } catch (_) {
        // Skip invalid file
      }
    }

    // Build FormData manually to ensure arrays are sent correctly
    final formData = FormData();
    formData.fields
      ..add(MapEntry('name_pk', namePk))
      ..add(MapEntry('size', size))
      ..add(MapEntry('type', type))
      ..add(MapEntry('category', category))
      ..add(MapEntry('description', description))
      ..add(MapEntry('isAvailable', isAvailable.toString()))
      ..add(MapEntry('condition', condition));

    // Send colors as array via `color[]` to satisfy backend validation
    for (final c in color) {
      if (c.trim().isEmpty) continue;
      formData.fields.add(MapEntry('color[]', c.trim()));
    }

    // Attach image files (multiple)
    for (final f in imageFiles) {
      formData.files.add(MapEntry('images', f));
    }

    List<String> dataEntered =
        formData.fields.map((e) => e.value.toString()).toList();
    print('Submitting Add Product with data: $dataEntered');

    final response = await ApiService.dio.post(
      ApiEndpoints.addProduct,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    print('Raw Add Product API Response: ${response.data}');

    if (response.statusCode != 201) {
      throw Exception('Failed to add product');
    }
  }
}
