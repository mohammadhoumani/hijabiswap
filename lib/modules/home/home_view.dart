import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/modules/home/home_controller.dart';
import 'package:hijabiswap/modules/home/widgets/image-slider.dart';
import 'package:hijabiswap/modules/home/widgets/products_card.dart';
import 'package:hijabiswap/modules/home/widgets/my_products_card.dart';
import 'package:hijabiswap/modules/home/widgets/skeleton_home_loader.dart';
import 'package:hijabiswap/routes/app_routes.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/images/hijabiswap.jpg',
          width: SizeUtils.scaleX(40),
          height: SizeUtils.scaleY(40),
        ),
        title: Text(
          'HijabiSwap',
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: SizeUtils.scaleY(17),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              Obx(
                () =>
                    controller.unreadNotificationsCount.value > 0
                        ? Positioned(
                          top: SizeUtils.scaleY(0),
                          right: SizeUtils.scaleX(0),
                          child: Container(
                            width: SizeUtils.scaleY(20),
                            height: SizeUtils.scaleY(20),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                controller.unreadNotificationsCount.value
                                            .toString()
                                            .length >
                                        2
                                    ? '99+'
                                    : controller.unreadNotificationsCount.value
                                        .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeUtils.scaleY(8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
              IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.notifications);
                },
                icon: Icon(Icons.notifications, color: AppColors.primary),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.profile);
            },
            icon: Icon(Icons.person),
          ),
        ],
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchProducts();
          await controller.fetchMyProducts();
        },
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        strokeWidth: 3,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Obx(
              () =>
                  controller.isLoading.value
                      ? const SkeletonHomeLoader()
                      : Column(
                        children: [
                          SizedBox(height: SizeUtils.scaleY(16)),
                          buildImageSlider(),
                          SizedBox(height: SizeUtils.scaleY(24)),
                          // My Products Section
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeUtils.scaleX(16),
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                vertical: SizeUtils.scaleY(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'My Products',
                                    style: GoogleFonts.poppins(
                                      fontSize: SizeUtils.scaleY(16),
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    controller.myProducts.length.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: SizeUtils.scaleY(10),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: SizeUtils.scaleY(8)),
                          if (!controller.isLoading.value &&
                              controller.myProducts.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeUtils.scaleX(16),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(SizeUtils.scaleY(20)),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.peach.withOpacity(0.15),
                                      AppColors.primary.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    SizeUtils.scaleY(16),
                                  ),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(
                                            SizeUtils.scaleY(10),
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.add_photo_alternate_outlined,
                                            color: AppColors.primary,
                                            size: SizeUtils.scaleY(24),
                                          ),
                                        ),
                                        SizedBox(width: SizeUtils.scaleX(12)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'No products yet',
                                                style: GoogleFonts.poppins(
                                                  fontSize: SizeUtils.scaleY(
                                                    14,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              SizedBox(
                                                height: SizeUtils.scaleY(4),
                                              ),
                                              Text(
                                                'Start by adding your first item to swap',
                                                style: GoogleFonts.inter(
                                                  fontSize: SizeUtils.scaleY(
                                                    12,
                                                  ),
                                                  color: AppColors.secondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: SizeUtils.scaleY(12)),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Get.toNamed(AppRoutes.addProduct);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: SizeUtils.scaleY(12),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              SizeUtils.scaleY(10),
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          size: SizeUtils.scaleY(18),
                                        ),
                                        label: Text(
                                          'Add Your First Product',
                                          style: GoogleFonts.poppins(
                                            fontSize: SizeUtils.scaleY(13),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (controller.myProducts.isNotEmpty)
                            SizedBox(
                              height: SizeUtils.scaleY(132),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeUtils.scaleX(8),
                                ),
                                itemBuilder: (context, index) {
                                  final p = controller.myProducts[index];
                                  return MyProductsCard(
                                    product: p,
                                    onEdit: null,
                                    onDelete: null,
                                  );
                                },
                                separatorBuilder:
                                    (_, __) =>
                                        SizedBox(width: SizeUtils.scaleX(4)),
                                itemCount: controller.myProducts.length,
                              ),
                            ),
                          SizedBox(height: SizeUtils.scaleY(24)),

                          // Divider
                          Divider(
                            color: AppColors.peach.withOpacity(0.4),
                            thickness: 1,
                            indent: SizeUtils.scaleX(16),
                            endIndent: SizeUtils.scaleX(16),
                          ),
                          SizedBox(height: SizeUtils.scaleY(4)),
                          // Discover Products Section
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeUtils.scaleX(16),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: SizeUtils.scaleY(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Discover Products',
                                    style: GoogleFonts.poppins(
                                      fontSize: SizeUtils.scaleY(16),
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const Spacer(),

                                  // Results count (filtered/total)
                                  SizedBox(width: SizeUtils.scaleX(8)),
                                  // Clear only when filters active
                                  Obx(() {
                                    final hasFilters =
                                        controller.selectedTypes.isNotEmpty ||
                                        controller.selectedCondition.value !=
                                            null;
                                    return hasFilters
                                        ? TextButton(
                                          onPressed: controller.clearFilters,
                                          child: Text(
                                            'Clear',
                                            style: GoogleFonts.poppins(
                                              fontSize: SizeUtils.scaleY(10),
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        )
                                        : const SizedBox.shrink();
                                  }),
                                  IconButton(
                                    tooltip: 'Filters',
                                    onPressed:
                                        () => _openDiscoverFilters(
                                          context,
                                          controller,
                                        ),
                                    icon: Icon(
                                      Icons.tune_rounded,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: SizeUtils.scaleY(4)),
                          if (!controller.isLoading.value &&
                              controller.filteredProducts.isEmpty &&
                              controller.products.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeUtils.scaleX(16),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(SizeUtils.scaleY(20)),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.peach.withOpacity(0.15),
                                      AppColors.primary.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    SizeUtils.scaleY(16),
                                  ),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(
                                            SizeUtils.scaleY(10),
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.travel_explore_rounded,
                                            color: AppColors.primary,
                                            size: SizeUtils.scaleY(24),
                                          ),
                                        ),
                                        SizedBox(width: SizeUtils.scaleX(12)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'No products match your filters',
                                                style: GoogleFonts.poppins(
                                                  fontSize: SizeUtils.scaleY(
                                                    14,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              SizedBox(
                                                height: SizeUtils.scaleY(4),
                                              ),
                                              Text(
                                                'Try clearing filters to see more items.',
                                                style: GoogleFonts.inter(
                                                  fontSize: SizeUtils.scaleY(
                                                    12,
                                                  ),
                                                  color: AppColors.secondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: SizeUtils.scaleY(12)),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: controller.clearFilters,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                vertical: SizeUtils.scaleY(12),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      SizeUtils.scaleY(10),
                                                    ),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              'Clear Filters',
                                              style: GoogleFonts.poppins(
                                                fontSize: SizeUtils.scaleY(13),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: SizeUtils.scaleX(12)),
                                        IconButton(
                                          onPressed:
                                              () => _openDiscoverFilters(
                                                context,
                                                controller,
                                              ),
                                          icon: Icon(
                                            Icons.tune_rounded,
                                            color: AppColors.primary,
                                          ),
                                          tooltip: 'Adjust Filters',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: SizeUtils.scaleX(8),
                                    mainAxisSpacing: SizeUtils.scaleY(12),
                                    childAspectRatio: 0.76,
                                  ),
                              itemBuilder: (context, index) {
                                final item = controller.filteredProducts[index];
                                return ProductsCard(
                                  haveShippingAddress:
                                      controller.haveShippingAddress,
                                  onRequest:
                                      (message) => controller.requestProduct(
                                        id: item.id,
                                        message:
                                            message, // Now uses actual message from text field
                                      ),
                                  product: item,
                                  requestLoading: controller.requestLoading,
                                );
                              },
                              itemCount: controller.filteredProducts.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(SizeUtils.scaleX(10)),
                              physics: NeverScrollableScrollPhysics(),
                            ),
                          SizedBox(height: SizeUtils.scaleY(24)),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _openDiscoverFilters(
  BuildContext context,
  HomeController c,
) async {
  final tempTypes = {...c.selectedTypes};
  String? tempCondition = c.selectedCondition.value;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .9,
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeUtils.scaleX(12),
                      vertical: SizeUtils.scaleY(6),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Filters',
                          style: GoogleFonts.poppins(
                            fontSize: SizeUtils.scaleY(16),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              tempTypes.clear();
                              tempCondition = null;
                            });
                          },
                          child: Text(
                            'Clear all',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: AppColors.peach.withOpacity(0.4)),
                  // Content
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeUtils.scaleX(16),
                      ),
                      children: [
                        SizedBox(height: SizeUtils.scaleY(12)),
                        Text(
                          'Types',
                          style: GoogleFonts.poppins(
                            fontSize: SizeUtils.scaleY(14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        ...c.types.map(
                          (t) => CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: tempTypes.contains(t),
                            onChanged:
                                (v) => setState(() {
                                  if (v == true) {
                                    tempTypes.add(t);
                                  } else {
                                    tempTypes.remove(t);
                                  }
                                }),
                            title: Text(
                              t,
                              style: GoogleFonts.poppins(
                                fontSize: SizeUtils.scaleY(13),
                              ),
                            ),
                            secondary: Icon(
                              Icons.checkroom_rounded,
                              color: AppColors.primary,
                            ),
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(8)),
                        Text(
                          'Condition',
                          style: GoogleFonts.poppins(
                            fontSize: SizeUtils.scaleY(14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        RadioListTile<String?>(
                          contentPadding: EdgeInsets.zero,
                          value: null,
                          groupValue: tempCondition,
                          onChanged: (v) => setState(() => tempCondition = v),
                          title: Text(
                            'Any',
                            style: GoogleFonts.poppins(
                              fontSize: SizeUtils.scaleY(13),
                            ),
                          ),
                        ),
                        ...c.conditions.map(
                          (cond) => RadioListTile<String?>(
                            contentPadding: EdgeInsets.zero,
                            value: cond,
                            groupValue: tempCondition,
                            onChanged: (v) => setState(() => tempCondition = v),
                            title: Text(
                              cond,
                              style: GoogleFonts.poppins(
                                fontSize: SizeUtils.scaleY(13),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(24)),
                      ],
                    ),
                  ),
                  // Actions
                  Padding(
                    padding: EdgeInsets.all(SizeUtils.scaleY(16)),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                tempTypes.clear();
                                tempCondition = null;
                              });
                              c.selectedTypes.clear();
                              c.selectedCondition.value = null;
                              Navigator.pop(context);
                            },
                            child: const Text('Clear'),
                          ),
                        ),
                        SizedBox(width: SizeUtils.scaleX(12)),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              c.selectedTypes
                                ..clear()
                                ..addAll(tempTypes);
                              c.selectedCondition.value = tempCondition;
                              Navigator.pop(context);
                            },
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
