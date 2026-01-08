import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/modules/favorites/favorites_controller.dart';
import 'package:hijabiswap/modules/favorites/widgets/favorite_card.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is registered so `GetView` can find it
    if (!Get.isRegistered<FavoritesController>()) {
      Get.put(FavoritesController());
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'My Favorites',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: SizeUtils.scaleY(18),
            color: theme.colorScheme.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: SizeUtils.scaleX(16)),
            child: Center(
              child: Obx(
                () => Text(
                  '${controller.likedProducts.length}',
                  style: GoogleFonts.inter(
                    fontSize: SizeUtils.scaleY(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.likedProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: SizeUtils.scaleY(80),
                  color: AppColors.primary.withOpacity(0.3),
                ),
                SizedBox(height: SizeUtils.scaleY(24)),
                Text(
                  'No Favorites Yet',
                  style: GoogleFonts.poppins(
                    fontSize: SizeUtils.scaleY(20),
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: SizeUtils.scaleY(12)),
                Text(
                  'Start liking products to add them here',
                  style: GoogleFonts.inter(
                    fontSize: SizeUtils.scaleY(14),
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: SizeUtils.scaleY(20)),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchLikedProducts(),
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    'Refresh',
                    style: GoogleFonts.poppins(
                      fontSize: SizeUtils.scaleY(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeUtils.scaleX(20),
                      vertical: SizeUtils.scaleY(10),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeUtils.scaleY(10)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => controller.fetchLikedProducts(),
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: SizeUtils.scaleX(8),
              vertical: SizeUtils.scaleY(12),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.likedProducts.length,
            itemBuilder: (context, index) {
              final product = controller.likedProducts[index];
              return FavoriteCard(
                product: product,
                onUnlike: () => controller.unlikeProduct(productId: product.id),
              );
            },
          ),
        );
      }),
    );
  }
}
