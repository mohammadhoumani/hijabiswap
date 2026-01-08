import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:hijabiswap/data/models/products_model.dart';
import 'package:hijabiswap/modules/home/widgets/myproducts_information.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class MyProductsCard extends StatelessWidget {
  final MyProduct product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MyProductsCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    // Compact horizontal card layout
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          MyProductsInformation(product: product),
          isScrollControlled: true,
          ignoreSafeArea: false,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        width: SizeUtils.scaleX(260),
        height: SizeUtils.scaleY(132),
        margin: EdgeInsets.symmetric(
          horizontal: SizeUtils.scaleX(12),
          vertical: SizeUtils.scaleY(6),
        ),
        decoration: BoxDecoration(
          color: themeData.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(SizeUtils.scaleY(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail + overlays
            SizedBox(
              width: SizeUtils.scaleX(110),
              height: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeUtils.scaleY(12)),
                      bottomLeft: Radius.circular(SizeUtils.scaleY(12)),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: AppColors.peach.withOpacity(0.2),
                      child:
                          product.images.isNotEmpty
                              ? Image.network(
                                product.images.first.url,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: SizedBox(
                                      width: SizeUtils.scaleY(16),
                                      height: SizeUtils.scaleY(16),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        _buildPlaceholderImage(),
                              )
                              : _buildPlaceholderImage(),
                    ),
                  ),
                  // Availability badge on image
                  Positioned(
                    top: SizeUtils.scaleY(6),
                    left: SizeUtils.scaleX(6),
                    child: _smallBadge(
                      bgColor:
                          product.isAvailable
                              ? AppColors.green.withOpacity(0.9)
                              : Colors.grey.shade700.withOpacity(0.9),
                      icon:
                          product.isAvailable
                              ? Icons.check_circle
                              : Icons.cancel,
                      label: product.isAvailable ? 'Available' : 'Unavailable',
                    ),
                  ),
                  // Image count
                  if (product.images.length > 1)
                    Positioned(
                      bottom: SizeUtils.scaleY(6),
                      right: SizeUtils.scaleX(6),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeUtils.scaleX(6),
                          vertical: SizeUtils.scaleY(3),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(
                            SizeUtils.scaleY(10),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.images,
                              size: SizeUtils.scaleY(9),
                              color: Colors.white,
                            ),
                            SizedBox(width: SizeUtils.scaleX(4)),
                            Text(
                              '${product.images.length}',
                              style: GoogleFonts.inter(
                                fontSize: SizeUtils.scaleY(10),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Right content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeUtils.scaleX(10),
                  vertical: SizeUtils.scaleY(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Condition badge inline
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              product.namePk,
                              style: GoogleFonts.poppins(
                                fontSize: SizeUtils.scaleY(14),
                                fontWeight: FontWeight.w700,
                                color: themeData.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: SizeUtils.scaleX(6)),
                        _buildConditionBadge(),
                      ],
                    ),
                    SizedBox(height: SizeUtils.scaleY(6)),

                    // Details
                    Wrap(
                      spacing: SizeUtils.scaleX(6),
                      runSpacing: SizeUtils.scaleY(4),
                      children: [
                        _buildDetailChip(
                          icon: FontAwesomeIcons.ruler,
                          label: product.size,
                          themeData: themeData,
                        ),
                        _buildDetailChip(
                          icon: FontAwesomeIcons.tag,
                          label: product.type,
                          themeData: themeData,
                        ),
                        if (product.color.isNotEmpty)
                          _buildColorChips(themeData),
                      ],
                    ),

                    // Description omitted in compact layout to prevent overflow
                    Spacer(),

                    // Footer
                    Row(
                      children: [
                        // Likes
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: SizeUtils.scaleY(11),
                              color: AppColors.primary,
                            ),
                            SizedBox(width: SizeUtils.scaleX(4)),
                            Text(
                              '${product.likesCount}',
                              style: GoogleFonts.inter(
                                fontSize: SizeUtils.scaleY(11),
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: SizeUtils.scaleX(8)),
                        Expanded(
                          child: Text(
                            _formatDate(product.createdAt),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(10),
                              color: AppColors.darkGrey.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.peach.withOpacity(0.2),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.image,
          size: SizeUtils.scaleY(24),
          color: AppColors.darkGrey.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildConditionBadge() {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (product.condition.toLowerCase()) {
      case 'new':
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        icon = FontAwesomeIcons.starHalfStroke;
        break;
      case 'like-new':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        icon = FontAwesomeIcons.star;
        break;
      case 'good':
        bgColor = Colors.teal.shade100;
        textColor = Colors.teal.shade700;
        icon = FontAwesomeIcons.thumbsUp;
        break;
      case 'fair':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        icon = FontAwesomeIcons.circleCheck;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        icon = FontAwesomeIcons.circleInfo;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtils.scaleX(6),
        vertical: SizeUtils.scaleY(4),
      ),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(SizeUtils.scaleY(14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: SizeUtils.scaleY(7), color: textColor),
          SizedBox(width: SizeUtils.scaleX(4)),
          Text(
            _formatCondition(product.condition),
            style: GoogleFonts.inter(
              fontSize: SizeUtils.scaleY(8),
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required ThemeData themeData,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtils.scaleX(6),
        vertical: SizeUtils.scaleY(4),
      ),
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(SizeUtils.scaleY(6)),
        border: Border.all(
          color: themeData.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: SizeUtils.scaleY(10), color: AppColors.primary),
          SizedBox(width: SizeUtils.scaleX(4)),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: SizeUtils.scaleY(10),
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChips(ThemeData themeData) {
    return Padding(
      padding: EdgeInsets.only(top: SizeUtils.scaleY(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.palette,
            size: SizeUtils.scaleY(11),
            color: AppColors.primary,
          ),
          SizedBox(width: SizeUtils.scaleX(4)),
          ...product.color
              .take(3)
              .map(
                (color) => Container(
                  width: SizeUtils.scaleX(12),
                  height: SizeUtils.scaleY(12),
                  margin: EdgeInsets.only(right: SizeUtils.scaleX(3)),
                  decoration: BoxDecoration(
                    color: _getColorFromName(color),
                    shape: BoxShape.circle,
                    border: Border.all(color: themeData.dividerColor, width: 1),
                  ),
                ),
              ),
          if (product.color.length > 3)
            Text(
              '+${product.color.length - 3}',
              style: GoogleFonts.inter(
                fontSize: SizeUtils.scaleY(9),
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
        ],
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    final name = colorName.toLowerCase();
    switch (name) {
      case 'red':
        return Colors.red;
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'beige':
        return Color(0xFFF5F5DC);
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'brown':
        return Colors.brown;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.grey.shade300;
    }
  }

  String _formatCondition(String condition) {
    return condition
        .split('-')
        .map((word) {
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Added ${months}mo ago';
    } else if (difference.inDays > 0) {
      return 'Added ${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return 'Added ${difference.inHours}h ago';
    } else {
      return 'Added today';
    }
  }
}

Widget _smallBadge({
  required Color bgColor,
  required IconData icon,
  required String label,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: SizeUtils.scaleX(6),
      vertical: SizeUtils.scaleY(3),
    ),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(SizeUtils.scaleY(14)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: SizeUtils.scaleY(10), color: Colors.white),
        SizedBox(width: SizeUtils.scaleX(4)),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: SizeUtils.scaleY(9),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
