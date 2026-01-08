import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/data/models/products_model.dart';
import 'package:hijabiswap/modules/home/widgets/information_bottom_sheet.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class ProductsCard extends StatefulWidget {
  final Product product;
  final Future<void> Function(String message) onRequest;
  final RxBool requestLoading;
  final RxBool haveShippingAddress;
  const ProductsCard({
    super.key,

    required this.product,
    required this.onRequest,
    required this.requestLoading,
    required this.haveShippingAddress,
  });

  @override
  State<ProductsCard> createState() => _ProductsCardState();
}

class _ProductsCardState extends State<ProductsCard> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    List<ProductImage> imagesMap = widget.product.images;
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          ProductInfoSheet(
            haveShippingAddress: widget.haveShippingAddress,
            onRequest: widget.onRequest,
            product: widget.product,
            requestLoading: widget.requestLoading,
          ),
          isScrollControlled: true,
          ignoreSafeArea: false,
          backgroundColor: Colors.transparent,
        );

        // Handle product card tap if needed
      },
      child: Container(
        padding: EdgeInsets.all(SizeUtils.scaleX(8)),
        height: SizeUtils.scaleY(210),
        width: SizeUtils.scaleX(160),
        margin: EdgeInsets.all(6),
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
                          imagesMap.isNotEmpty
                              ? imagesMap.map((img) {
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
                        enableInfiniteScroll: imagesMap.length > 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                    ),
                    // Carousel indicators
                    if (imagesMap.length > 1)
                      Positioned(
                        bottom: SizeUtils.scaleY(8),
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            imagesMap.length,
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
                  ],
                ),
                SizedBox(height: SizeUtils.scaleY(16)),
                Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.product.namePk,
                          style: GoogleFonts.poppins(
                            color: themeData.colorScheme.primary.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: SizeUtils.scaleY(12),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: SizeUtils.scaleX(4)),
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
                SizedBox(height: SizeUtils.scaleY(8)),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: SizeUtils.scaleY(12),
                      color: themeData.colorScheme.primary,
                    ),
                    SizedBox(width: SizeUtils.scaleX(2)),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.product.userId.city,
                          style: GoogleFonts.poppins(
                            color: themeData.colorScheme.primary,
                            fontSize: SizeUtils.scaleY(14),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: SizeUtils.scaleX(4)),
                    Row(
                      children: [
                        Text(
                          widget.product.likesCount.toString(),
                          style: GoogleFonts.poppins(
                            color: themeData.colorScheme.onSurfaceVariant,
                            fontSize: SizeUtils.scaleY(9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: SizeUtils.scaleX(2)),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child:
                              widget.product.isLiked
                                  ? Icon(
                                    Icons.favorite,
                                    size: SizeUtils.scaleY(12),
                                    color: Colors.redAccent,
                                  )
                                  : Icon(
                                    Icons.favorite_border,
                                    size: SizeUtils.scaleY(12),
                                    color:
                                        themeData.colorScheme.onSurfaceVariant,
                                  ),
                        ),
                        SizedBox(width: SizeUtils.scaleX(3)),
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
