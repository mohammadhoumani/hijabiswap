import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijabiswap/data/models/products_model.dart';
import 'package:hijabiswap/data/services/product_service.dart';
import 'package:hijabiswap/data/services/profile_service.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class HomeController extends GetxController {
  final ProductService _productService = ProductService();
  final ProfileService _profileService = ProfileService();

  final RxList<Product> products = <Product>[].obs;
  final RxList<MyProduct> myProducts = <MyProduct>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool requestLoading = false.obs;
  final Rx<Pagination?> pagination = Rx<Pagination?>(null);
  final RxInt unreadNotificationsCount = 0.obs;
  final RxBool haveShippingAddress = false.obs;

  final List<String> conditions = const ['new', 'like-new', 'good', 'fair'];

  final List<String> types = const [
    "pant",
    "accessories",
    "jackets",
    "shirt",
    "dress",
    "abaya",
    "skirt",
    "top",
    "hijab",
    "jilbab",
    "khimar",
    "set",
    "other",
  ];

  // Discover filters state (affects Discover grid only)
  final RxSet<String> selectedTypes = <String>{}.obs;
  final RxnString selectedCondition = RxnString(null);
  final RxList<Product> filteredProducts = <Product>[].obs;

  // Helpers to update filter state
  void toggleType(String t) {
    if (selectedTypes.contains(t)) {
      selectedTypes.remove(t);
    } else {
      selectedTypes.add(t);
    }
  }

  void setCondition(String? c) {
    selectedCondition.value = c;
  }

  void clearFilters() {
    selectedTypes.clear();
    selectedCondition.value = null;
  }

  void _recomputeFiltered() {
    final types = selectedTypes.toSet();
    final cond = selectedCondition.value;
    final all = products.toList();
    filteredProducts.value =
        all.where((p) {
          final dynamicType = (p as dynamic).type;
          final dynamicCond = (p as dynamic).condition;
          final typeOk =
              types.isEmpty ||
              (dynamicType != null && types.contains(dynamicType as String));
          final condOk =
              cond == null || (dynamicCond != null && dynamicCond == cond);
          return typeOk && condOk;
        }).toList();
  }

  Future<void> fetchProducts({int page = 1}) async {
    try {
      isLoading.value = true;
      final response = await _productService.fetchProducts(page: page);

      products.value = response.data;
      pagination.value = response.pagination;
      _recomputeFiltered();

      print('Fetched ${products.length} products');
      print(
        'Pagination: Page ${pagination.value?.page} of ${pagination.value?.pages}',
      );
    } catch (e) {
      print('Error fetching products: $e');
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likeProduct({required String productId}) async {
    try {
      await _productService.likeProduct(productId);
      fetchProducts();

      print('Liked product with ID: $productId');
    } catch (e) {
      print('Error liking product: $e');
      Get.snackbar('Error', 'Failed to like product');
    }
  }

  Future<void> deleteProduct({required String productId}) async {
    try {
      await _productService.deleteProduct(productId);

      print('Deleted product with ID: $productId');
      Get.back();
      fetchMyProducts();
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        backgroundColor: AppColors.green,
        colorText: AppColors.white,
      );
    } catch (e) {
      print('Error deleting product: $e');
      Get.snackbar(
        'Error',
        'Failed to delete product',
        margin: EdgeInsets.all(SizeUtils.scaleY(16)),
        backgroundColor: AppColors.primary,
        colorText: AppColors.white,
      );
    }
  }

  Future<void> unlikeProduct({required String productId}) async {
    try {
      await _productService.unlikeProduct(productId);
      fetchProducts();

      print('Unliked product with ID: $productId');
    } catch (e) {
      print('Error unliking product: $e');
      Get.snackbar('Error', 'Failed to unlike product');
    }
  }

  Future<void> fetchMyProducts() async {
    try {
      isLoading.value = true;
      final response = await _productService.fetchMyProducts();

      myProducts.value = response.data;

      print('Fetched ${products.length} of my products');
      print(
        'Pagination: Page ${pagination.value?.page} of ${pagination.value?.pages}',
      );
    } catch (e) {
      print('Error fetching my products: $e');
      Get.snackbar('Error', 'Failed to load my products');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProfileNotifications() async {
    try {
      final response = await _profileService.fetchUserProfile();
      unreadNotificationsCount.value = response.data.unreadNotificationsCount;
      haveShippingAddress.value =
          response.data.defaultShippingAddress != null &&
          response.data.defaultShippingAddress!.isNotEmpty;
      print('Unread notifications: ${unreadNotificationsCount.value}');
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  Future<void> requestProduct({
    required String id,
    required String message,
  }) async {
    try {
      requestLoading.value = true;
      await _productService.requestProduct(id: id, message: message);
      Get.back();
      fetchProducts();
      Get.snackbar(
        'Success',
        'Product request sent successfully',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        backgroundColor: AppColors.green,
        colorText: AppColors.white,
      );
    } catch (e) {
      print('Error requesting product: $e');
      Get.snackbar(
        'Error',
        'Failed to send product request',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        backgroundColor: AppColors.primary,
        colorText: AppColors.white,
      );
    } finally {
      requestLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Recompute discover filtered list whenever source/products or filters change
    everAll([
      products,
      selectedTypes,
      selectedCondition,
    ], (_) => _recomputeFiltered());
    fetchProducts();
    fetchMyProducts();
    fetchProfileNotifications();
  }
}
