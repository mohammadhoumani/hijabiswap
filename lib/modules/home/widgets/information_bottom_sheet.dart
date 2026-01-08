import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/data/models/products_model.dart';
import 'package:hijabiswap/modules/home/home_controller.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';
import 'package:get/get.dart';
import 'package:hijabiswap/routes/app_routes.dart';

class ProductInfoSheet extends StatefulWidget {
  final Product product;
  final Future<void> Function(String message) onRequest;
  final RxBool requestLoading;
  final RxBool haveShippingAddress;
  const ProductInfoSheet({
    super.key,
    required this.product,
    required this.onRequest,
    required this.requestLoading,
    required this.haveShippingAddress,
  });

  @override
  State<ProductInfoSheet> createState() => _ProductInfoSheetState();
}

class _ProductInfoSheetState extends State<ProductInfoSheet> {
  int _currentImageIndex = 0;
  final TextEditingController _messageController =
      TextEditingController(); // Add controller
  late bool _isLiked; // Add local like state

  @override
  void initState() {
    super.initState();
    _isLiked = widget.product.isLiked; // Initialize with product's like status
  }

  @override
  void dispose() {
    _messageController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = SizeUtils.scaleX(20);

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.55,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
            child: Column(
              children: [
                // Handle
                SizedBox(height: SizeUtils.scaleY(12)),
                Container(
                  width: SizeUtils.scaleX(50),
                  height: SizeUtils.scaleY(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(2)),
                  ),
                ),
                SizedBox(height: SizeUtils.scaleY(16)),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Media carousel
                        _buildEnhancedCarousel(theme),
                        SizedBox(height: SizeUtils.scaleY(24)),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeUtils.scaleX(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and actions
                              _buildTitleSection(theme),
                              SizedBox(height: SizeUtils.scaleY(20)),

                              _buildInfoRow(theme),

                              // Product attributes in a clean grid
                              _buildAttributesGrid(theme),
                              SizedBox(height: SizeUtils.scaleY(20)),
                              // Colors
                              if (widget.product.color.isNotEmpty) ...[
                                _buildColorSection(theme),
                              ],
                              SizedBox(height: SizeUtils.scaleY(20)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Fixed bottom actions section
                widget.product.isRequested
                    ? _buildRequestedPlaceholder(theme)
                    : _buildBottomActions(theme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestedPlaceholder(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(SizeUtils.scaleX(16)),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Text(
          'You have already requested this product.',
          style: GoogleFonts.inter(
            color: AppColors.primary,
            fontSize: SizeUtils.scaleY(14),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedCarousel(ThemeData theme) {
    final imageUrls = widget.product.images;
    return SizedBox(
      height: SizeUtils.scaleY(320),
      child: Stack(
        children: [
          CarouselSlider(
            items:
                imageUrls.isNotEmpty
                    ? imageUrls.map((url) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        child: Image.network(
                          url.url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder:
                              (_, __, ___) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image_outlined,
                                      size: SizeUtils.scaleY(60),
                                      color: theme
                                          .colorScheme
                                          .onSecondaryContainer
                                          .withOpacity(0.5),
                                    ),
                                    SizedBox(height: SizeUtils.scaleY(12)),
                                    Text(
                                      'Image not available',
                                      style: GoogleFonts.inter(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                        fontSize: SizeUtils.scaleY(13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      );
                    }).toList()
                    : [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: SizeUtils.scaleX(10),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            SizeUtils.scaleX(8),
                          ),
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: SizeUtils.scaleY(60),
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              SizedBox(height: SizeUtils.scaleY(12)),
                              Text(
                                'No images available',
                                style: GoogleFonts.inter(
                                  color: theme.colorScheme.primary,
                                  fontSize: SizeUtils.scaleY(13),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
            options: CarouselOptions(
              height: SizeUtils.scaleY(320),
              viewportFraction: 1.0,
              autoPlay: imageUrls.length > 1,
              enableInfiniteScroll: imageUrls.length > 1,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (index, _) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
            ),
          ),

          // Sleek carousel indicators
          if (imageUrls.length > 1)
            Positioned(
              bottom: SizeUtils.scaleY(20),
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageUrls.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width:
                        i == _currentImageIndex
                            ? SizeUtils.scaleX(24)
                            : SizeUtils.scaleX(8),
                    height: SizeUtils.scaleY(8),
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeUtils.scaleX(4),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(4)),
                      color:
                          i == _currentImageIndex
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.namePk,
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(21),
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(5)),
              Text(
                widget.product.description,
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(14),
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: SizeUtils.scaleX(8)),
        _isLiked
            ? _buildIconButton(
              icon: Icons.favorite_rounded,
              onTap: () {
                setState(() {
                  _isLiked = false; // Update UI immediately
                });
                Get.find<HomeController>().unlikeProduct(
                  productId: widget.product.id,
                );
              },
              color: Colors.redAccent,
            )
            : _buildIconButton(
              icon: Icons.favorite_border_rounded,
              onTap: () {
                setState(() {
                  _isLiked = true; // Update UI immediately
                });
                Get.find<HomeController>().likeProduct(
                  productId: widget.product.id,
                );
              },
              color: Colors.redAccent,
            ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    Color? color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: SizeUtils.scaleX(48),
          height: SizeUtils.scaleX(48),
          decoration: BoxDecoration(
            color: (color ?? AppColors.primary).withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: SizeUtils.scaleY(22),
            color: color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildAttributesGrid(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: SizeUtils.scaleX(8),
      mainAxisSpacing: SizeUtils.scaleY(8),
      childAspectRatio: 2.5,
      children: [
        _buildAttributeItem(
          icon: FaIcon(
            FontAwesomeIcons.ruler,
            size: SizeUtils.scaleY(18),
            color: AppColors.primary,
          ),
          label: 'Size',
          value: widget.product.size,
        ),
        _buildAttributeItem(
          icon: FaIcon(
            FontAwesomeIcons.boxOpen,
            size: SizeUtils.scaleY(18),
            color: AppColors.primary,
          ),
          label: 'Condition',
          value: widget.product.condition,
        ),
        _buildAttributeItem(
          icon: FaIcon(
            FontAwesomeIcons.weightHanging,
            size: SizeUtils.scaleY(18),
            color: AppColors.primary,
          ),
          label: 'Type',
          value: widget.product.type,
        ),
        _buildAttributeItem(
          icon: FaIcon(
            FontAwesomeIcons.tags,
            size: SizeUtils.scaleY(18),
            color: AppColors.primary,
          ),
          label: 'Category',
          value: widget.product.category,
        ),
      ],
    );
  }

  Widget _buildAttributeItem({
    required FaIcon icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(SizeUtils.scaleX(12)),
      decoration: BoxDecoration(
        color: AppColors.peach.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
      ),
      child: Row(
        children: [
          icon,
          SizedBox(width: SizeUtils.scaleX(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: AppColors.secondary.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: SizeUtils.scaleY(11),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: SizeUtils.scaleY(14),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors',
          style: GoogleFonts.inter(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: SizeUtils.scaleY(16),
          ),
        ),
        SizedBox(height: SizeUtils.scaleY(10)),
        Wrap(
          spacing: SizeUtils.scaleX(10),
          runSpacing: SizeUtils.scaleY(10),
          children:
              widget.product.color.map((colorName) {
                final c = _colorFromString(colorName);
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeUtils.scaleX(14),
                    vertical: SizeUtils.scaleY(8),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.peach.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(20)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: SizeUtils.scaleX(20),
                        height: SizeUtils.scaleX(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c,
                          border: Border.all(
                            color: Colors.black.withOpacity(0.15),
                            width: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtils.scaleX(16),
        vertical: SizeUtils.scaleY(14),
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(SizeUtils.scaleX(14)),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          /// Owner
          _inlineInfo(
            icon: Icons.person_outline,
            text: widget.product.userId.name,
          ),

          /// Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeUtils.scaleX(12)),
            child: Container(
              height: SizeUtils.scaleY(18),
              width: 1,
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),

          /// Location
          _inlineInfo(
            icon: Icons.location_on_outlined,
            text: widget.product.userId.city,
          ),

          /// Divider
          if (widget.product.userId.averageRating != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeUtils.scaleX(12)),
              child: Container(
                height: SizeUtils.scaleY(18),
                width: 1,
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),

          /// Average Rating
          if (widget.product.userId.averageRating != null)
            _inlineInfo(
              icon: Icons.star_rounded,
              text: widget.product.userId.averageRating!.toStringAsFixed(1),
            ),
        ],
      ),
    );
  }

  Widget _inlineInfo({required IconData icon, required String text}) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeUtils.scaleX(6)),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(SizeUtils.scaleX(8)),
            ),
            child: Icon(
              icon,
              size: SizeUtils.scaleY(16),
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: SizeUtils.scaleX(8)),
          Expanded(
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: SizeUtils.scaleY(14.5),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        SizeUtils.scaleX(20),
        SizeUtils.scaleY(16),
        SizeUtils.scaleX(20),
        SizeUtils.scaleY(20),
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: SizeUtils.scaleY(52)),
              child: TextField(
                controller: _messageController, // Add controller
                readOnly: false, // Make it editable
                decoration: InputDecoration(
                  hintText: 'enter your message',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.secondary.withOpacity(0.6),
                    fontSize: SizeUtils.scaleY(14),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.secondary.withOpacity(0.1),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: SizeUtils.scaleY(14),
                    horizontal: SizeUtils.scaleX(16),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(14)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: SizeUtils.scaleX(10)),
          Expanded(
            flex: 1,
            child: Obx(
              () => _buildPrimaryButton(
                label: 'Request',
                icon: Icons.shopping_bag_outlined,
                enabled:
                    widget.product.isAvailable && !widget.requestLoading.value,
                isLoading: widget.requestLoading.value,
                onPressed:
                    widget.product.isAvailable && !widget.requestLoading.value
                        ? () => _handleRequestPressed(context)
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required bool enabled,
    bool isLoading = false,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: SizeUtils.scaleY(52),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.darkGrey.withOpacity(0.4),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: SizeUtils.scaleX(12),
            vertical: SizeUtils.scaleY(12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeUtils.scaleX(14)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: SizeUtils.scaleX(18),
                height: SizeUtils.scaleX(18),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: SizeUtils.scaleX(8)),
            ] else ...[
              Icon(icon, size: SizeUtils.scaleY(18)),
              SizedBox(width: SizeUtils.scaleX(8)),
            ],
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeUtils.scaleY(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRequestPressed(BuildContext context) async {
    if (!widget.haveShippingAddress.value) {
      Get.dialog(
        AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(
            'Add Shipping Address',
            style: GoogleFonts.inter(
              fontSize: SizeUtils.scaleY(16),
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: Text(
            'You need to add a shipping address before requesting items. Please update your profile.',
            style: GoogleFonts.inter(
              fontSize: SizeUtils.scaleY(14),
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                Get.back();
                Get.toNamed(AppRoutes.profile);
              },
              child: Text(
                'Go to Profile',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
      return;
    }

    await widget.onRequest(_messageController.text.trim());
  }

  Color _colorFromString(String name) {
    switch (name.toLowerCase().trim()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'black':
        return Colors.black87;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pinkAccent;
      case 'brown':
        return Colors.brown;
      case 'orange':
        return Colors.orange;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'beige':
        return const Color(0xFFF5F5DC);
      case 'navy':
        return Colors.indigo.shade900;
      default:
        return AppColors.secondary.withOpacity(0.7);
    }
  }
}
