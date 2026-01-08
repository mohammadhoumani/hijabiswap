import 'package:get/get.dart';
import 'package:hijabiswap/data/models/favorites_model.dart';
import 'package:hijabiswap/data/services/product_service.dart';

class FavoritesController extends GetxController {
  final ProductService _productService = ProductService();

  final RxList<FavoriteProduct> likedProducts = <FavoriteProduct>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchLikedProducts() async {
    try {
      isLoading.value = true;
      final response = await _productService.fetchLikedProducts();

      likedProducts.value = response.data;

      print('Fetched ${likedProducts.length} liked products');
    } catch (e) {
      print('Error fetching liked products: $e');
      Get.snackbar('Error', 'Failed to load liked products');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unlikeProduct({required String productId}) async {
    try {
      await _productService.unlikeProduct(productId);
      print('Unliked product with ID: $productId');

      fetchLikedProducts();
    } catch (e) {
      print('Error unliking product: $e');
      Get.snackbar('Error', 'Failed to remove from favorites');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchLikedProducts();
  }
}
