import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class SkeletonHomeLoader extends StatelessWidget {
  const SkeletonHomeLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeUtils.scaleY(16)),
        // Carousel skeleton
        _buildCarouselSkeleton(),
        SizedBox(height: SizeUtils.scaleY(24)),
        // My Products section header skeleton
        _buildSectionHeaderSkeleton(),
        SizedBox(height: SizeUtils.scaleY(8)),
        // My Products cards skeleton
        _buildMyProductsCardsSkeleton(),
        SizedBox(height: SizeUtils.scaleY(24)),
        // Divider
        Divider(
          color: AppColors.peach.withOpacity(0.4),
          thickness: 1,
          indent: SizeUtils.scaleX(16),
          endIndent: SizeUtils.scaleX(16),
        ),
        SizedBox(height: SizeUtils.scaleY(4)),
        // Discover Products section header skeleton
        _buildSectionHeaderSkeleton(),
        SizedBox(height: SizeUtils.scaleY(4)),
        // Products grid skeleton
        _buildProductsGridSkeleton(),
      ],
    );
  }

  Widget _buildCarouselSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeUtils.scaleX(16)),
      child: Shimmer.fromColors(
        baseColor: AppColors.peach.withOpacity(0.3),
        highlightColor: AppColors.peach.withOpacity(0.7),
        child: Container(
          height: SizeUtils.scaleY(203),
          decoration: BoxDecoration(
            color: AppColors.peach.withOpacity(0.5),
            borderRadius: BorderRadius.circular(SizeUtils.scaleX(10)),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeaderSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeUtils.scaleX(16)),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: SizeUtils.scaleY(8)),
        child: Shimmer.fromColors(
          baseColor: AppColors.peach.withOpacity(0.2),
          highlightColor: AppColors.peach.withOpacity(0.6),
          child: Container(
            height: SizeUtils.scaleY(16),
            width: SizeUtils.scaleX(140),
            decoration: BoxDecoration(
              color: AppColors.peach.withOpacity(0.4),
              borderRadius: BorderRadius.circular(SizeUtils.scaleX(4)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyProductsCardsSkeleton() {
    return SizedBox(
      height: SizeUtils.scaleY(132),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.scaleX(8)),
        itemBuilder: (context, index) => _buildMyProductCardSkeleton(),
        separatorBuilder: (_, __) => SizedBox(width: SizeUtils.scaleX(4)),
        itemCount: 3,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildMyProductCardSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.peach.withOpacity(0.2),
      highlightColor: AppColors.peach.withOpacity(0.6),
      child: Container(
        width: SizeUtils.scaleX(260),
        margin: EdgeInsets.symmetric(
          horizontal: SizeUtils.scaleX(12),
          vertical: SizeUtils.scaleY(6),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(SizeUtils.scaleY(12)),
        ),
        child: Row(
          children: [
            // Left image placeholder
            Container(
              width: SizeUtils.scaleX(110),
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.peach.withOpacity(0.4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeUtils.scaleY(12)),
                  bottomLeft: Radius.circular(SizeUtils.scaleY(12)),
                ),
              ),
            ),
            // Right content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(SizeUtils.scaleY(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placeholder
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
                    // Badge placeholder
                    Container(
                      height: SizeUtils.scaleY(16),
                      width: SizeUtils.scaleX(60),
                      decoration: BoxDecoration(
                        color: AppColors.peach.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(
                          SizeUtils.scaleX(14),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeUtils.scaleY(6)),
                    // Chips row
                    Row(
                      children: [
                        Container(
                          height: SizeUtils.scaleY(20),
                          width: SizeUtils.scaleX(40),
                          decoration: BoxDecoration(
                            color: AppColors.peach.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(6),
                            ),
                          ),
                        ),
                        SizedBox(width: SizeUtils.scaleX(6)),
                        Container(
                          height: SizeUtils.scaleY(20),
                          width: SizeUtils.scaleX(40),
                          decoration: BoxDecoration(
                            color: AppColors.peach.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    // Footer info
                    Row(
                      children: [
                        Container(
                          height: SizeUtils.scaleY(12),
                          width: SizeUtils.scaleX(40),
                          decoration: BoxDecoration(
                            color: AppColors.peach.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(3),
                            ),
                          ),
                        ),
                        SizedBox(width: SizeUtils.scaleX(8)),
                        Container(
                          height: SizeUtils.scaleY(12),
                          width: SizeUtils.scaleX(50),
                          decoration: BoxDecoration(
                            color: AppColors.peach.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(3),
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

  Widget _buildProductsGridSkeleton() {
    return Padding(
      padding: EdgeInsets.all(SizeUtils.scaleX(10)),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return _buildProductCardSkeleton();
        },
        itemCount: 6,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildProductCardSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.peach.withOpacity(0.2),
      highlightColor: AppColors.peach.withOpacity(0.6),
      child: Container(
        margin: EdgeInsets.all(SizeUtils.scaleX(6)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeUtils.scaleX(10)),
          color: AppColors.white,
        ),
        padding: EdgeInsets.all(SizeUtils.scaleX(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: SizeUtils.scaleY(100),
              decoration: BoxDecoration(
                color: AppColors.peach.withOpacity(0.4),
                borderRadius: BorderRadius.circular(SizeUtils.scaleX(10)),
              ),
            ),

            // Title placeholder
            Container(
              height: SizeUtils.scaleY(16),
              decoration: BoxDecoration(
                color: AppColors.peach.withOpacity(0.35),
                borderRadius: BorderRadius.circular(SizeUtils.scaleX(4)),
              ),
            ),
            SizedBox(height: SizeUtils.scaleY(6)),

            // Condition chip placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: SizeUtils.scaleY(16),
                  width: SizeUtils.scaleX(60),
                  decoration: BoxDecoration(
                    color: AppColors.peach.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(4)),
                  ),
                ),
                Container(
                  height: SizeUtils.scaleY(16),
                  width: SizeUtils.scaleX(50),
                  decoration: BoxDecoration(
                    color: AppColors.peach.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(4)),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeUtils.scaleY(6)),

            // Location and likes placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: SizeUtils.scaleY(12),
                  width: SizeUtils.scaleX(70),
                  decoration: BoxDecoration(
                    color: AppColors.peach.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(3)),
                  ),
                ),
                Container(
                  height: SizeUtils.scaleY(12),
                  width: SizeUtils.scaleX(50),
                  decoration: BoxDecoration(
                    color: AppColors.peach.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(3)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
