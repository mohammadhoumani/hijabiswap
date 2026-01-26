import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:hijabiswap/data/models/favorites_model.dart';
import 'package:hijabiswap/data/models/products_model.dart';
import 'package:hijabiswap/modules/home/widgets/information_bottom_sheet.dart';
import 'package:hijabiswap/modules/home/home_controller.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class FavoriteCard extends StatefulWidget {
  final FavoriteProduct product;
  final VoidCallback? onUnlike;

  const FavoriteCard({super.key, required this.product, this.onUnlike});

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final images = widget.product.images;

    return InkWell(
      onTap: () {
        // Prevent opening sheet if product is unavailable
        if (!widget.product.isAvailable) {
          Get.snackbar(
            'Product Unavailable',
            'This product is no longer available.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: themeData.colorScheme.primary,
            colorText: Colors.white,
          );
          return;
        }

        // Open product information bottom sheet with full functionality
        final home = Get.find<HomeController>();
        final fav = widget.product;
        // Adapt FavoriteProduct to Product for the sheet
        final product = Product(
          id: fav.id,
          userId: fav.userId,
          namePk: fav.namePk,
          size: fav.size,
          type: fav.type,
          color: fav.color,
          category: fav.category,
          description: fav.description,
          images: fav.images,
          isLiked: true, // favorites imply liked
          isRequested: false, // unknown from favorites; default to false
          isAvailable: fav.isAvailable,
          condition: fav.condition,
          likesCount: fav.likesCount,
          createdAt: fav.createdAt,
          updatedAt: fav.updatedAt,
          version: fav.version,
        );

        Get.bottomSheet(
          ProductInfoSheet(
            haveShippingAddress: home.haveShippingAddress,
            onRequest:
                (message) =>
                    home.requestProduct(id: product.id, message: message),
            product: product,
            requestLoading: home.requestLoading,
          ),
          isScrollControlled: true,
          ignoreSafeArea: false,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        padding: EdgeInsets.all(SizeUtils.scaleX(8)),
        height: SizeUtils.scaleY(230),
        width: SizeUtils.scaleX(160),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeData.colorScheme.onPrimary.withOpacity(0.6),
          border: Border.all(color: themeData.colorScheme.primary, width: 0.5),
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                      items:
                          images.isNotEmpty
                              ? images.map((img) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: themeData.colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    img.url,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color:
                                              themeData
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            size: SizeUtils.scaleY(40),
                                            color:
                                                themeData
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                          ),
                                        ),
                                      );
                                    },
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: BoxDecoration(
                                          color:
                                              themeData
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList()
                              : [
                                Container(
                                  decoration: BoxDecoration(
                                    color: themeData.colorScheme.onPrimary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: SizeUtils.scaleY(40),
                                      color:
                                          themeData
                                              .colorScheme
                                              .onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                      options: CarouselOptions(
                        autoPlay: false,
                        height: SizeUtils.scaleY(130),
                        viewportFraction: 1.0,
                        enableInfiniteScroll: images.length > 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                    ),
                    // Carousel indicators
                    if (images.length > 1)
                      Positioned(
                        bottom: SizeUtils.scaleY(8),
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width:
                                  _currentImageIndex == index
                                      ? SizeUtils.scaleX(16)
                                      : SizeUtils.scaleX(6),
                              height: SizeUtils.scaleY(6),
                              margin: EdgeInsets.symmetric(
                                horizontal: SizeUtils.scaleX(3),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  SizeUtils.scaleX(3),
                                ),
                                color:
                                    _currentImageIndex == index
                                        ? themeData.colorScheme.primary
                                        : Colors.white.withOpacity(0.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Like button
                    if (widget.onUnlike != null)
                      Positioned(
                        top: SizeUtils.scaleY(6),
                        right: SizeUtils.scaleX(6),
                        child: InkWell(
                          onTap: widget.onUnlike,
                          child: Container(
                            padding: EdgeInsets.all(SizeUtils.scaleY(6)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite,
                              size: SizeUtils.scaleY(16),
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: SizeUtils.scaleY(6)),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.namePk,
                        style: GoogleFonts.poppins(
                          color: themeData.colorScheme.onSurface,
                          fontSize: SizeUtils.scaleY(13),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeUtils.scaleX(6),
                        vertical: SizeUtils.scaleY(2),
                      ),
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.product.condition,
                        style: GoogleFonts.poppins(
                          color: themeData.colorScheme.onPrimaryContainer,
                          fontSize: SizeUtils.scaleY(10),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeUtils.scaleY(4)),
                Wrap(
                  spacing: SizeUtils.scaleX(6),
                  runSpacing: SizeUtils.scaleY(4),
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeUtils.scaleX(8),
                        vertical: SizeUtils.scaleY(3),
                      ),
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.product.type,
                        style: GoogleFonts.inter(
                          color: themeData.colorScheme.onSecondaryContainer,
                          fontSize: SizeUtils.scaleY(10),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeUtils.scaleX(8),
                        vertical: SizeUtils.scaleY(3),
                      ),
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.product.size,
                        style: GoogleFonts.inter(
                          color: themeData.colorScheme.primary,
                          fontSize: SizeUtils.scaleY(10),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeUtils.scaleY(4)),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: SizeUtils.scaleY(12),
                      color: themeData.colorScheme.primary,
                    ),
                    SizedBox(width: SizeUtils.scaleX(4)),
                    Expanded(
                      child: Text(
                        widget.product.userId?.city ?? 'Unknown',
                        style: GoogleFonts.poppins(
                          color: themeData.colorScheme.primary,
                          fontSize: SizeUtils.scaleY(12),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: SizeUtils.scaleX(8)),
                    Row(
                      children: [
                        Text(
                          widget.product.likesCount.toString(),
                          style: GoogleFonts.inter(
                            color: themeData.colorScheme.onSurfaceVariant,
                            fontSize: SizeUtils.scaleY(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: SizeUtils.scaleX(4)),
                        Icon(
                          Icons.favorite,
                          size: SizeUtils.scaleY(14),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            if (!widget.product.isAvailable)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.surface.withValues(
                          alpha: .5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeUtils.scaleX(16),
                            vertical: SizeUtils.scaleY(8),
                          ),
                          decoration: BoxDecoration(
                            color: themeData.colorScheme.primary.withAlpha(250),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Not Available",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: SizeUtils.scaleY(14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
