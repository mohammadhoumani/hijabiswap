import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/utils/size_utils.dart';
import 'package:hijabiswap/modules/addproduct/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Add Product',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: SizeUtils.scaleY(18),
            color: theme.colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(SizeUtils.scaleX(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photos upload area (multiple)
              Text(
                'Photos',
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(14),
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(8)),
              Obx(
                () => GridView.builder(
                  itemCount: controller.photos.length + 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: SizeUtils.scaleX(8),
                    mainAxisSpacing: SizeUtils.scaleY(8),
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final isAddTile = index == 0;

                    if (isAddTile) {
                      return GestureDetector(
                        onTap: controller.pickImages,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(12),
                            ),
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: SizeUtils.scaleX(32),
                                  color: theme.colorScheme.primary,
                                ),
                                SizedBox(height: SizeUtils.scaleY(6)),
                                Text(
                                  'Add',
                                  style: GoogleFonts.inter(
                                    fontSize: SizeUtils.scaleY(12),
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    // Display uploaded image with delete button
                    final photoIndex = index - 1;
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              SizeUtils.scaleX(12),
                            ),
                            border: Border.all(
                              color: theme.colorScheme.surfaceVariant,
                              width: 1,
                            ),
                            image: DecorationImage(
                              image: FileImage(
                                File(controller.photos[photoIndex].path),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => controller.removePhoto(photoIndex),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ),
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(SizeUtils.scaleX(4)),
                              child: Icon(
                                Icons.close,
                                size: SizeUtils.scaleX(14),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(6)),
              Obx(
                () => Text(
                  'Add up to 5 photos (${controller.photos.length}/5)',
                  style: GoogleFonts.inter(
                    fontSize: SizeUtils.scaleY(12),
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(24)),

              // Product name field
              Text(
                'Product Name',
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(14),
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(8)),
              TextField(
                controller: controller.namePkController,
                decoration: InputDecoration(
                  hintText: 'e.g., Black Abaya',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeUtils.scaleX(14),
                    vertical: SizeUtils.scaleY(14),
                  ),
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(16)),

              // Description field
              Text(
                'Description',
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(14),
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(8)),
              TextField(
                controller: controller.descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe your product...',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeUtils.scaleX(14),
                    vertical: SizeUtils.scaleY(14),
                  ),
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(16)),

              // Size, Type row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Size',
                          style: GoogleFonts.inter(
                            fontSize: SizeUtils.scaleY(14),
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(8)),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.selectedSize.value,
                            isExpanded: true,
                            items:
                                controller.sizes
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) {
                              controller.selectedSize.value = v;
                            },
                            decoration: InputDecoration(
                              hintText: 'Select',
                              filled: true,
                              fillColor: theme.colorScheme.surfaceVariant
                                  .withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  SizeUtils.scaleX(12),
                                ),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: SizeUtils.scaleX(14),
                                vertical: SizeUtils.scaleY(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: SizeUtils.scaleX(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type',
                          style: GoogleFonts.inter(
                            fontSize: SizeUtils.scaleY(14),
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: SizeUtils.scaleY(8)),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.selectedType.value,
                            isExpanded: true,
                            items:
                                controller.types
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(t),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) {
                              controller.selectedType.value = v;
                            },
                            decoration: InputDecoration(
                              hintText: 'Select',
                              filled: true,
                              fillColor: theme.colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  SizeUtils.scaleX(12),
                                ),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: SizeUtils.scaleX(14),
                                vertical: SizeUtils.scaleY(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeUtils.scaleY(16)),

              // Condition field
              Text(
                'Condition',
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(14),
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(8)),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedCondition.value,
                  isExpanded: true,
                  items:
                      controller.conditions
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                  onChanged: (v) {
                    controller.selectedCondition.value = v;
                  },
                  decoration: InputDecoration(
                    hintText: 'Select',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant.withOpacity(
                      0.3,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: SizeUtils.scaleX(14),
                      vertical: SizeUtils.scaleY(14),
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(20)),

              // Colors input + chips
              Text(
                'Colors',
                style: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(14),
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(8)),
              TextField(
                controller: controller.colorController,
                onSubmitted: controller.addColor,
                decoration: InputDecoration(
                  hintText: 'Type a color and press Enter',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeUtils.scaleX(14),
                    vertical: SizeUtils.scaleY(14),
                  ),
                  suffixIcon: IconButton(
                    onPressed:
                        () => controller.addColor(
                          controller.colorController.text,
                        ),
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: 'Add color',
                  ),
                ),
              ),
              SizedBox(height: SizeUtils.scaleY(8)),
              Obx(
                () =>
                    controller.colors.isEmpty
                        ? Text(
                          'No colors added yet. Press Enter or + to add.',
                          style: GoogleFonts.inter(
                            fontSize: SizeUtils.scaleY(12),
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        )
                        : Wrap(
                          spacing: SizeUtils.scaleX(8),
                          runSpacing: SizeUtils.scaleY(8),
                          children:
                              controller.colors
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => Chip(
                                      label: Text(
                                        entry.value,
                                        style: GoogleFonts.inter(
                                          fontSize: SizeUtils.scaleY(12),
                                          fontWeight: FontWeight.w600,
                                          color:
                                              theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                        ),
                                      ),
                                      backgroundColor: theme
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withOpacity(0.5),
                                      deleteIcon: Icon(
                                        Icons.close,
                                        size: SizeUtils.scaleX(14),
                                      ),
                                      onDeleted:
                                          () =>
                                              controller.removeColor(entry.key),
                                    ),
                                  )
                                  .toList(),
                        ),
              ),
              SizedBox(height: SizeUtils.scaleY(24)),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: SizeUtils.scaleY(48),
                child: ElevatedButton(
                  onPressed:
                      () => controller.addProduct(
                        controller.namePkController.text,
                        controller.selectedSize.value ?? '',
                        controller.selectedType.value ?? '',
                        controller.colors,
                        "modest-fashion",
                        controller.descriptionController.text,
                        controller.photos.map((e) => e.path).toList(),
                        true,
                        controller.selectedCondition.value ?? '',
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeUtils.scaleX(12)),
                    ),
                  ),
                  child: Obx(
                    () =>
                        controller.isLoading.value
                            ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            )
                            : Text(
                              'Add Product',
                              style: GoogleFonts.inter(
                                fontSize: SizeUtils.scaleY(16),
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                  ),
                ),
              ),

              SizedBox(height: SizeUtils.scaleY(24)),
            ],
          ),
        ),
      ),
    );
  }
}
