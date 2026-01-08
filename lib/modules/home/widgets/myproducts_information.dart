import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/data/models/products_model.dart';
import 'package:hijabiswap/modules/home/home_controller.dart';
import 'package:hijabiswap/modules/home/widgets/edit_item_view.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';
// GetX import removed: no actions/dialogs used here

class MyProductsInformation extends StatefulWidget {
  final MyProduct product;

  const MyProductsInformation({super.key, required this.product});

  @override
  State<MyProductsInformation> createState() => _MyProductsInformationState();
}

class _MyProductsInformationState extends State<MyProductsInformation> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = SizeUtils.scaleX(20);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
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
                        SizedBox(height: SizeUtils.scaleY(16)),

                        // Image carousel
                        _buildImageCarousel(),

                        SizedBox(height: SizeUtils.scaleY(20)),

                        // Product details
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeUtils.scaleX(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and availability
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.product.namePk,
                                      style: GoogleFonts.poppins(
                                        fontSize: SizeUtils.scaleY(22),
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  _buildAvailabilityBadge(),
                                ],
                              ),
                              SizedBox(height: SizeUtils.scaleY(12)),

                              // Stats row
                              Row(
                                children: [
                                  _buildStatItem(
                                    icon: FontAwesomeIcons.heart,
                                    value: widget.product.likesCount.toString(),
                                    label: 'Likes',
                                  ),
                                  SizedBox(width: SizeUtils.scaleX(20)),
                                  _buildStatItem(
                                    icon: FontAwesomeIcons.calendar,
                                    value: _formatDate(
                                      widget.product.createdAt,
                                    ),
                                    label: 'Added',
                                  ),
                                ],
                              ),

                              SizedBox(height: SizeUtils.scaleY(20)),
                              Divider(
                                color: AppColors.darkGrey.withOpacity(0.1),
                              ),
                              SizedBox(height: SizeUtils.scaleY(20)),

                              // Product information section
                              Text(
                                'Product Information',
                                style: GoogleFonts.poppins(
                                  fontSize: SizeUtils.scaleY(16),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: SizeUtils.scaleY(16)),

                              _buildInfoRow(
                                icon: FontAwesomeIcons.tag,
                                label: 'Type',
                                value: widget.product.type,
                              ),
                              SizedBox(height: SizeUtils.scaleY(12)),
                              _buildInfoRow(
                                icon: FontAwesomeIcons.ruler,
                                label: 'Size',
                                value: widget.product.size,
                              ),
                              SizedBox(height: SizeUtils.scaleY(12)),
                              _buildInfoRow(
                                icon: FontAwesomeIcons.layerGroup,
                                label: 'Category',
                                value: widget.product.category,
                              ),
                              SizedBox(height: SizeUtils.scaleY(12)),
                              _buildInfoRow(
                                icon: FontAwesomeIcons.starHalfStroke,
                                label: 'Condition',
                                value: _formatCondition(
                                  widget.product.condition,
                                ),
                              ),

                              if (widget.product.color.isNotEmpty) ...[
                                SizedBox(height: SizeUtils.scaleY(12)),
                                _buildColorRow(),
                              ],

                              SizedBox(height: SizeUtils.scaleY(20)),
                              Divider(
                                color: AppColors.darkGrey.withOpacity(0.1),
                              ),
                              SizedBox(height: SizeUtils.scaleY(20)),

                              // Description section
                              Text(
                                'Description',
                                style: GoogleFonts.poppins(
                                  fontSize: SizeUtils.scaleY(16),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: SizeUtils.scaleY(12)),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(SizeUtils.scaleY(16)),
                                decoration: BoxDecoration(
                                  color: AppColors.peach.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    SizeUtils.scaleY(12),
                                  ),
                                  border: Border.all(
                                    color: AppColors.peach.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  widget.product.description.isNotEmpty
                                      ? widget.product.description
                                      : 'No description provided',
                                  style: GoogleFonts.inter(
                                    fontSize: SizeUtils.scaleY(14),
                                    color:
                                        widget.product.description.isNotEmpty
                                            ? AppColors.secondary
                                            : AppColors.darkGrey.withOpacity(
                                              0.6,
                                            ),
                                    height: 1.5,
                                  ),
                                ),
                              ),

                              SizedBox(height: SizeUtils.scaleY(32)),

                              // Edit and Delete buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Get.to(
                                          () => EditItemView(
                                            product: widget.product,
                                          ),
                                        );
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.pen,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Edit',
                                        style: GoogleFonts.poppins(
                                          fontSize: SizeUtils.scaleY(16),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          vertical: SizeUtils.scaleY(14),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            SizeUtils.scaleY(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: SizeUtils.scaleX(12)),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Get.find<HomeController>()
                                            .deleteProduct(
                                              productId: widget.product.id,
                                            );
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.trash,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Delete',
                                        style: GoogleFonts.poppins(
                                          fontSize: SizeUtils.scaleY(16),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade500,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          vertical: SizeUtils.scaleY(14),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            SizeUtils.scaleY(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: SizeUtils.scaleY(24)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageCarousel() {
    final hasImages = widget.product.images.isNotEmpty;

    return Column(
      children: [
        SizedBox(
          height: SizeUtils.scaleY(300),
          child:
              hasImages
                  ? Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemCount: widget.product.images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeUtils.scaleX(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                SizeUtils.scaleY(16),
                              ),
                              child: Image.network(
                                widget.product.images[index].url,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: AppColors.primary,
                                    ),
                                  );
                                },
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      color: AppColors.peach.withOpacity(0.2),
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.image,
                                          size: SizeUtils.scaleY(60),
                                          color: AppColors.darkGrey.withOpacity(
                                            0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (widget.product.images.length > 1)
                        Positioned(
                          bottom: SizeUtils.scaleY(16),
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.product.images.length,
                              (index) => Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: SizeUtils.scaleX(4),
                                ),
                                width: SizeUtils.scaleX(8),
                                height: SizeUtils.scaleY(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _currentImageIndex == index
                                          ? AppColors.primary
                                          : Colors.white.withOpacity(0.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                  : Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeUtils.scaleX(20),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.peach.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(SizeUtils.scaleY(16)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.image,
                            size: SizeUtils.scaleY(60),
                            color: AppColors.darkGrey.withOpacity(0.3),
                          ),
                          SizedBox(height: SizeUtils.scaleY(12)),
                          Text(
                            'No images',
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(14),
                              color: AppColors.darkGrey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
        if (widget.product.images.length > 1) ...[
          SizedBox(height: SizeUtils.scaleY(12)),
          Text(
            '${_currentImageIndex + 1} / ${widget.product.images.length}',
            style: GoogleFonts.inter(
              fontSize: SizeUtils.scaleY(12),
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAvailabilityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtils.scaleX(12),
        vertical: SizeUtils.scaleY(8),
      ),
      decoration: BoxDecoration(
        color:
            widget.product.isAvailable
                ? AppColors.green.withOpacity(0.15)
                : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(SizeUtils.scaleY(20)),
        border: Border.all(
          color:
              widget.product.isAvailable
                  ? AppColors.green
                  : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.product.isAvailable ? Icons.check_circle : Icons.cancel,
            size: SizeUtils.scaleY(16),
            color:
                widget.product.isAvailable
                    ? AppColors.green
                    : Colors.grey.shade600,
          ),
          SizedBox(width: SizeUtils.scaleX(6)),
          Text(
            widget.product.isAvailable ? 'Available' : 'Unavailable',
            style: GoogleFonts.inter(
              fontSize: SizeUtils.scaleY(13),
              fontWeight: FontWeight.w600,
              color:
                  widget.product.isAvailable
                      ? AppColors.green
                      : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtils.scaleX(16),
        vertical: SizeUtils.scaleY(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(SizeUtils.scaleY(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: SizeUtils.scaleY(16), color: AppColors.primary),
          SizedBox(width: SizeUtils.scaleX(8)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: SizeUtils.scaleY(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(10),
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(SizeUtils.scaleY(10)),
          decoration: BoxDecoration(
            color: AppColors.peach.withOpacity(0.2),
            borderRadius: BorderRadius.circular(SizeUtils.scaleY(10)),
          ),
          child: FaIcon(
            icon,
            size: SizeUtils.scaleY(18),
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: SizeUtils.scaleX(16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(12),
                  color: AppColors.darkGrey,
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(2)),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: SizeUtils.scaleY(15),
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorRow() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(SizeUtils.scaleY(10)),
          decoration: BoxDecoration(
            color: AppColors.peach.withOpacity(0.2),
            borderRadius: BorderRadius.circular(SizeUtils.scaleY(10)),
          ),
          child: FaIcon(
            FontAwesomeIcons.palette,
            size: SizeUtils.scaleY(18),
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: SizeUtils.scaleX(16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Colors',
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(12),
                  color: AppColors.darkGrey,
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(6)),
              Wrap(
                spacing: SizeUtils.scaleX(8),
                runSpacing: SizeUtils.scaleY(8),
                children:
                    widget.product.color
                        .map(
                          (color) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeUtils.scaleX(12),
                              vertical: SizeUtils.scaleY(6),
                            ),
                            decoration: BoxDecoration(
                              color: _getColorFromName(color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                SizeUtils.scaleY(8),
                              ),
                              border: Border.all(
                                color: _getColorFromName(color),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: SizeUtils.scaleX(16),
                                  height: SizeUtils.scaleY(16),
                                  decoration: BoxDecoration(
                                    color: _getColorFromName(color),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeUtils.scaleX(6)),
                                Text(
                                  color[0].toUpperCase() + color.substring(1),
                                  style: GoogleFonts.inter(
                                    fontSize: SizeUtils.scaleY(12),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColorFromName(String colorName) {
    final name = colorName.toLowerCase();
    switch (name) {
      case 'red':
        return Colors.red;
      case 'white':
        return Colors.grey.shade300;
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
        return Colors.grey.shade400;
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
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Today';
    }
  }
}
