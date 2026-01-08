import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class ActivitySkeletonLoader extends StatelessWidget {
  const ActivitySkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips skeleton
        _buildFilterChipsSkeleton(),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: SizeUtils.scaleX(12),
              vertical: SizeUtils.scaleY(8),
            ),
            itemCount: 6,
            separatorBuilder: (_, __) => SizedBox(height: SizeUtils.scaleY(8)),
            itemBuilder: (_, __) => _buildRequestCardSkeleton(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChipsSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtils.scaleX(16),
        vertical: SizeUtils.scaleY(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _chipSkeleton(width: SizeUtils.scaleX(80)),
            SizedBox(width: SizeUtils.scaleX(8)),
            _chipSkeleton(width: SizeUtils.scaleX(90)),
            SizedBox(width: SizeUtils.scaleX(8)),
            _chipSkeleton(width: SizeUtils.scaleX(100)),
            SizedBox(width: SizeUtils.scaleX(8)),
            _chipSkeleton(width: SizeUtils.scaleX(110)),
          ],
        ),
      ),
    );
  }

  Widget _chipSkeleton({required double width}) {
    return Shimmer.fromColors(
      baseColor: AppColors.peach.withOpacity(0.25),
      highlightColor: AppColors.peach.withOpacity(0.6),
      child: Container(
        height: SizeUtils.scaleY(28),
        width: SizeUtils.scaleX(width),
        decoration: BoxDecoration(
          color: AppColors.peach.withOpacity(0.4),
          borderRadius: BorderRadius.circular(SizeUtils.scaleY(18)),
        ),
      ),
    );
  }

  Widget _buildRequestCardSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.peach.withOpacity(0.2),
      highlightColor: AppColors.peach.withOpacity(0.6),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeUtils.scaleX(8)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeUtils.scaleY(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeUtils.scaleY(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header skeleton
              Row(
                children: [
                  Container(
                    width: SizeUtils.scaleY(48),
                    height: SizeUtils.scaleY(48),
                    decoration: BoxDecoration(
                      color: AppColors.peach.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: SizeUtils.scaleX(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: SizeUtils.scaleY(14),
                          width: SizeUtils.scaleX(140),
                          decoration: BoxDecoration(
                            color: AppColors.peach.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(4),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(6)),
                        Container(
                          height: SizeUtils.scaleY(12),
                          width: SizeUtils.scaleX(100),
                          decoration: BoxDecoration(
                            color: AppColors.peach.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: SizeUtils.scaleY(18),
                    width: SizeUtils.scaleX(70),
                    decoration: BoxDecoration(
                      color: AppColors.peach.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(SizeUtils.scaleY(20)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeUtils.scaleY(12)),
              // Item block
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: SizeUtils.scaleX(70),
                    height: SizeUtils.scaleY(70),
                    decoration: BoxDecoration(
                      color: AppColors.peach.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(SizeUtils.scaleY(10)),
                    ),
                  ),
                  SizedBox(width: SizeUtils.scaleX(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: SizeUtils.scaleY(14),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.peach.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(4),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(6)),
                        Container(
                          height: SizeUtils.scaleY(36),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.peach.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeUtils.scaleY(12)),
              // Action buttons skeleton
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: SizeUtils.scaleY(36),
                      decoration: BoxDecoration(
                        color: AppColors.peach.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(
                          SizeUtils.scaleY(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: SizeUtils.scaleX(12)),
                  Expanded(
                    child: Container(
                      height: SizeUtils.scaleY(36),
                      decoration: BoxDecoration(
                        color: AppColors.peach.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(
                          SizeUtils.scaleY(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeUtils.scaleY(8)),
              // Timestamp skeleton
              Row(
                children: [
                  Container(
                    height: SizeUtils.scaleY(12),
                    width: SizeUtils.scaleX(100),
                    decoration: BoxDecoration(
                      color: AppColors.peach.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(3)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
