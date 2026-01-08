import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class NotificationsSkeletonLoader extends StatelessWidget {
  const NotificationsSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtils.scaleX(12),
        vertical: SizeUtils.scaleY(16),
      ),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: SizeUtils.scaleY(12)),
      itemBuilder: (_, __) => _buildCardSkeleton(),
    );
  }

  Widget _buildCardSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.peach.withOpacity(0.25),
      highlightColor: AppColors.peach.withOpacity(0.6),
      child: Container(
        padding: EdgeInsets.all(SizeUtils.scaleX(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeUtils.scaleY(12)),
          border: Border.all(color: AppColors.peach.withOpacity(0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon placeholder
            Container(
              width: SizeUtils.scaleX(40),
              height: SizeUtils.scaleY(40),
              decoration: BoxDecoration(
                color: AppColors.peach.withOpacity(0.5),
                borderRadius: BorderRadius.circular(SizeUtils.scaleY(10)),
              ),
            ),
            SizedBox(width: SizeUtils.scaleX(12)),
            // Text lines
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: SizeUtils.scaleY(14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.peach.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(6)),
                    ),
                  ),
                  SizedBox(height: SizeUtils.scaleY(8)),
                  Container(
                    height: SizeUtils.scaleY(12),
                    width: SizeUtils.scaleX(120),
                    decoration: BoxDecoration(
                      color: AppColors.peach.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(6)),
                    ),
                  ),
                  SizedBox(height: SizeUtils.scaleY(8)),
                  Container(
                    height: SizeUtils.scaleY(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.peach.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(6)),
                    ),
                  ),
                  SizedBox(height: SizeUtils.scaleY(6)),
                  Container(
                    height: SizeUtils.scaleY(12),
                    width: SizeUtils.scaleX(180),
                    decoration: BoxDecoration(
                      color: AppColors.peach.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(6)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: SizeUtils.scaleX(8)),
            // Unread dot placeholder
            Container(
              width: SizeUtils.scaleX(10),
              height: SizeUtils.scaleX(10),
              decoration: BoxDecoration(
                color: AppColors.peach.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
