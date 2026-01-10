import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:hijabiswap/data/models/activity_model.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class ReceivedRequestCard extends StatelessWidget {
  final ActivityRequest request;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final RxMap<String, bool> acceptLoading;
  final RxMap<String, bool> rejectLoading;

  const ReceivedRequestCard({
    super.key,
    required this.request,
    required this.acceptLoading,
    required this.rejectLoading,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final status = request.status.toLowerCase();
    final isPending = status.startsWith('pend');
    final isAccepted = status.startsWith('accept');
    final isConfirmed = status.startsWith('confirm');
    final isCompleted = status.startsWith('complete');
    final isRejected = status.startsWith('reject');
    final isCancelled = status.startsWith('cancel');

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeUtils.scaleX(16),
        vertical: SizeUtils.scaleY(8),
      ),
      decoration: BoxDecoration(
        color: themeData.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(SizeUtils.scaleY(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info and timestamp
          Padding(
            padding: EdgeInsets.all(SizeUtils.scaleY(12)),
            child: Row(
              children: [
                // User avatar
                CircleAvatar(
                  radius: SizeUtils.scaleY(24),
                  backgroundColor: AppColors.peach,
                  child: Text(
                    request.userId.name?.isNotEmpty == true
                        ? request.userId.name![0].toUpperCase()
                        : '?',
                    style: GoogleFonts.poppins(
                      fontSize: SizeUtils.scaleY(18),
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: SizeUtils.scaleX(12)),
                // User name and city
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.userId.name ?? "Unknown",
                        style: GoogleFonts.poppins(
                          fontSize: SizeUtils.scaleY(15),
                          fontWeight: FontWeight.w600,
                          color: themeData.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: SizeUtils.scaleY(2)),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: SizeUtils.scaleY(11),
                            color: AppColors.darkGrey,
                          ),
                          SizedBox(width: SizeUtils.scaleX(4)),
                          Text(
                            request.userId.city ?? "Unknown",
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(12),
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge
                _buildStatusBadge(
                  isPending,
                  isAccepted,
                  isConfirmed,
                  isCompleted,
                  isRejected,
                  isCancelled,
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: themeData.dividerColor.withOpacity(0.1),
          ),

          // Item info and message
          Padding(
            padding: EdgeInsets.all(SizeUtils.scaleY(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item image
                ClipRRect(
                  borderRadius: BorderRadius.circular(SizeUtils.scaleY(10)),
                  child: Container(
                    width: SizeUtils.scaleX(70),
                    height: SizeUtils.scaleY(70),
                    color: AppColors.peach.withOpacity(0.3),
                    child:
                        (request.itemId?.images.isNotEmpty == true)
                            ? Image.network(
                              request.itemId!.images.first.url,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                  ),
                                );
                              },
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.image_outlined,
                                    size: SizeUtils.scaleY(30),
                                    color: AppColors.darkGrey,
                                  ),
                            )
                            : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.peach.withOpacity(0.3),
                                    AppColors.primary.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        SizeUtils.scaleY(8),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.boxOpen,
                                        size: SizeUtils.scaleY(14),
                                        color: AppColors.primary.withOpacity(
                                          0.6,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: SizeUtils.scaleY(4)),
                                    Text(
                                      'No item',
                                      style: GoogleFonts.poppins(
                                        fontSize: SizeUtils.scaleY(9),
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary.withOpacity(
                                          0.7,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                  ),
                ),
                SizedBox(width: SizeUtils.scaleX(12)),
                // Item details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.itemId?.namePk ?? 'No item found',
                        style: GoogleFonts.poppins(
                          fontSize: SizeUtils.scaleY(14),
                          fontWeight: FontWeight.w600,
                          color: themeData.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: SizeUtils.scaleY(6)),
                      // Message
                      if (request.message != null &&
                          request.message!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeUtils.scaleX(10),
                            vertical: SizeUtils.scaleY(8),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.peach.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleY(8),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.message,
                                size: SizeUtils.scaleY(11),
                                color: AppColors.primary,
                              ),
                              SizedBox(width: SizeUtils.scaleX(6)),
                              Expanded(
                                child: Text(
                                  request.message!,
                                  style: GoogleFonts.inter(
                                    fontSize: SizeUtils.scaleY(12),
                                    color: AppColors.secondary,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action buttons (only for pending status)
          if (isPending) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: themeData.dividerColor.withOpacity(0.1),
            ),
            Padding(
              padding: EdgeInsets.all(SizeUtils.scaleY(12)),
              child: Row(
                children: [
                  // Reject button
                  Expanded(
                    child: Obx(() {
                      final isRejecting = rejectLoading[request.id] == true;
                      final isAccepting = acceptLoading[request.id] == true;
                      return OutlinedButton(
                        onPressed:
                            (isRejecting || isAccepting) ? null : onReject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade300),
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
                            isRejecting
                                ? SizedBox(
                                  width: SizeUtils.scaleX(18),
                                  height: SizeUtils.scaleX(18),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red.shade700,
                                    ),
                                  ),
                                )
                                : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.xmark,
                                      size: SizeUtils.scaleY(16),
                                    ),
                                    SizedBox(width: SizeUtils.scaleX(8)),
                                    Text(
                                      'Reject',
                                      style: GoogleFonts.poppins(
                                        fontSize: SizeUtils.scaleY(13),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                      );
                    }),
                  ),
                  SizedBox(width: SizeUtils.scaleX(12)),
                  // Accept button
                  Expanded(
                    child: Obx(() {
                      final isAccepting = acceptLoading[request.id] == true;
                      final isRejecting = rejectLoading[request.id] == true;
                      return ElevatedButton(
                        onPressed:
                            (isAccepting || isRejecting) ? null : onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: SizeUtils.scaleY(12),
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleY(10),
                            ),
                          ),
                        ),
                        child:
                            isAccepting
                                ? SizedBox(
                                  width: SizeUtils.scaleX(18),
                                  height: SizeUtils.scaleX(18),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.check,
                                      size: SizeUtils.scaleY(16),
                                    ),
                                    SizedBox(width: SizeUtils.scaleX(8)),
                                    Text(
                                      'Accept',
                                      style: GoogleFonts.poppins(
                                        fontSize: SizeUtils.scaleY(13),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],

          // Timestamp
          Padding(
            padding: EdgeInsets.only(
              left: SizeUtils.scaleX(12),
              right: SizeUtils.scaleX(12),
              bottom: SizeUtils.scaleY(12),
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.clock,
                  size: SizeUtils.scaleY(10),
                  color: AppColors.darkGrey.withOpacity(0.7),
                ),
                SizedBox(width: SizeUtils.scaleX(4)),
                Text(
                  _formatTimestamp(request.requestedAt),
                  style: GoogleFonts.inter(
                    fontSize: SizeUtils.scaleY(11),
                    color: AppColors.darkGrey.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(
    bool isPending,
    bool isAccepted,
    bool isConfirmed,
    bool isCompleted,
    bool isRejected,
    bool isCancelled,
  ) {
    Color bgColor;
    Color textColor;
    String statusText;
    IconData icon;

    if (isPending) {
      bgColor = Colors.orange.shade100;
      textColor = Colors.orange.shade700;
      statusText = 'Pending';
      icon = FontAwesomeIcons.clock;
    } else if (isAccepted) {
      bgColor = AppColors.green.withOpacity(0.15);
      textColor = AppColors.green;
      statusText = 'Accepted';
      icon = FontAwesomeIcons.circleCheck;
    } else if (isConfirmed) {
      bgColor = AppColors.primary.withOpacity(0.15);
      textColor = AppColors.primary;
      statusText = 'Confirmed';
      icon = FontAwesomeIcons.circleCheck;
    } else if (isCompleted) {
      bgColor = AppColors.secondary.withOpacity(0.15);
      textColor = AppColors.secondary;
      statusText = 'Completed';
      icon = FontAwesomeIcons.circleCheck;
    } else if (isRejected) {
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade700;
      statusText = 'Rejected';
      icon = FontAwesomeIcons.circleXmark;
    } else if (isCancelled) {
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade700;
      statusText = 'Cancelled';
      icon = FontAwesomeIcons.circleXmark;
    } else {
      bgColor = AppColors.peach.withOpacity(0.2);
      textColor = AppColors.darkGrey;
      statusText = request.status;
      icon = FontAwesomeIcons.circleCheck;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtils.scaleX(10),
        vertical: SizeUtils.scaleY(6),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(SizeUtils.scaleY(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: SizeUtils.scaleY(11), color: textColor),
          SizedBox(width: SizeUtils.scaleX(4)),
          Text(
            statusText,
            style: GoogleFonts.inter(
              fontSize: SizeUtils.scaleY(11),
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
