import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:hijabiswap/data/models/activity_model.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';
import 'package:hijabiswap/modules/activity/activity_controller.dart';

class RateDialog extends StatefulWidget {
  final ActivityRequest request;

  const RateDialog({super.key, required this.request});

  @override
  State<RateDialog> createState() => _RateDialogState();

  static void show(BuildContext context, ActivityRequest request) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => RateDialog(request: request),
    );
  }
}

class _RateDialogState extends State<RateDialog> {
  late double rating = 0;
  late String review = '';
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeUtils.scaleY(20)),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: themeData.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(SizeUtils.scaleY(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Container(
                padding: EdgeInsets.all(SizeUtils.scaleY(16)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeUtils.scaleY(20)),
                    topRight: Radius.circular(SizeUtils.scaleY(20)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rate Your Swap',
                            style: GoogleFonts.poppins(
                              fontSize: SizeUtils.scaleY(16),
                              fontWeight: FontWeight.bold,
                              color: themeData.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: SizeUtils.scaleY(4)),
                          Text(
                            'Help others know about your experience',
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(12),
                              color: AppColors.darkGrey.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(SizeUtils.scaleY(6)),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.xmark,
                          size: SizeUtils.scaleY(14),
                          color: themeData.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(SizeUtils.scaleY(20)),
                child: Column(
                  children: [
                    // User info
                    Container(
                      padding: EdgeInsets.all(SizeUtils.scaleY(12)),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(
                          SizeUtils.scaleY(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: SizeUtils.scaleY(20),
                            backgroundColor: AppColors.peach,
                            child: Text(
                              widget.request.ownerId.name?.isNotEmpty == true
                                  ? widget.request.ownerId.name![0]
                                      .toUpperCase()
                                  : '?',
                              style: GoogleFonts.poppins(
                                fontSize: SizeUtils.scaleY(14),
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: SizeUtils.scaleX(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rating ${widget.request.ownerId.name ?? 'User'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: SizeUtils.scaleY(13),
                                    fontWeight: FontWeight.w600,
                                    color: themeData.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  widget.request.itemId?.namePk ?? 'No item',
                                  style: GoogleFonts.inter(
                                    fontSize: SizeUtils.scaleY(12),
                                    color: AppColors.darkGrey.withOpacity(0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeUtils.scaleY(20)),

                    // Star rating
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How would you rate this swap?',
                          style: GoogleFonts.poppins(
                            fontSize: SizeUtils.scaleY(13),
                            fontWeight: FontWeight.w600,
                            color: themeData.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      rating = index + 1.0;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeUtils.scaleX(8),
                                    ),
                                    child: AnimatedScale(
                                      scale: rating >= index + 1 ? 1.2 : 1.0,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: FaIcon(
                                        rating >= index + 1
                                            ? FontAwesomeIcons.solidStar
                                            : FontAwesomeIcons.star,
                                        size: SizeUtils.scaleY(28),
                                        color:
                                            rating >= index + 1
                                                ? Colors.amber.shade500
                                                : Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        SizedBox(height: SizeUtils.scaleY(8)),
                        Center(
                          child: Text(
                            rating > 0
                                ? '${rating.toStringAsFixed(0)} out of 5 stars'
                                : 'Select rating',
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(12),
                              color:
                                  rating > 0
                                      ? AppColors.primary
                                      : AppColors.darkGrey.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeUtils.scaleY(20)),

                    // Review text field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share your experience (optional)',
                          style: GoogleFonts.poppins(
                            fontSize: SizeUtils.scaleY(13),
                            fontWeight: FontWeight.w600,
                            color: themeData.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(8)),
                        TextField(
                          maxLines: 4,
                          minLines: 3,
                          onChanged: (value) {
                            setState(() {
                              review = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Tell us about your experience with this swap...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(12),
                              color: AppColors.darkGrey.withOpacity(0.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                SizeUtils.scaleY(12),
                              ),
                              borderSide: BorderSide(
                                color: themeData.dividerColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                SizeUtils.scaleY(12),
                              ),
                              borderSide: BorderSide(
                                color: themeData.dividerColor.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                SizeUtils.scaleY(12),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: themeData.colorScheme.primary
                                .withOpacity(0.02),
                            contentPadding: EdgeInsets.all(
                              SizeUtils.scaleY(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeUtils.scaleY(20)),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: SizeUtils.scaleY(12),
                              ),
                              side: BorderSide(color: themeData.dividerColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  SizeUtils.scaleY(10),
                                ),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: SizeUtils.scaleY(13),
                                fontWeight: FontWeight.w600,
                                color: themeData.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: SizeUtils.scaleX(12)),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                rating > 0 && !isSubmitting
                                    ? () async {
                                      setState(() {
                                        isSubmitting = true;
                                      });

                                      try {
                                        final controller =
                                            Get.find<ActivityController>();
                                        await controller.rateUser(
                                          requestId: widget.request.id,
                                          rating: rating.toInt(),
                                          comment:
                                              review.isNotEmpty ? review : null,
                                        );

                                        if (mounted) {
                                          Navigator.pop(context);
                                        }
                                      } catch (e) {
                                        setState(() {
                                          isSubmitting = false;
                                        });
                                      }
                                    }
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: AppColors.primary
                                  .withOpacity(0.5),
                              padding: EdgeInsets.symmetric(
                                vertical: SizeUtils.scaleY(12),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  SizeUtils.scaleY(10),
                                ),
                              ),
                            ),
                            child:
                                isSubmitting
                                    ? SizedBox(
                                      width: SizeUtils.scaleX(18),
                                      height: SizeUtils.scaleX(18),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : Text(
                                      'Submit Rating',
                                      style: GoogleFonts.poppins(
                                        fontSize: SizeUtils.scaleY(13),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
