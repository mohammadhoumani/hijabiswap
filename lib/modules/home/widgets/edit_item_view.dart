import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/data/models/products_model.dart';
import 'package:hijabiswap/modules/addproduct/add_product_controller.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:hijabiswap/utils/size_utils.dart';
import 'package:image_picker/image_picker.dart';

class EditItemView extends StatefulWidget {
  final MyProduct product;

  const EditItemView({super.key, required this.product});

  @override
  State<EditItemView> createState() => _EditItemViewState();
}

class _EditItemViewState extends State<EditItemView> {
  late TextEditingController _namePkController;
  late TextEditingController _descriptionController;
  late TextEditingController _colorController;
  late String _selectedSize;
  late String _selectedType;
  late String _selectedCondition;
  late RxList<String> _colors;
  late RxList<XFile> _newPhotos;
  late RxList<int> _removedImageIndices;
  late AddProductController _controller;

  final ImagePicker _imagePicker = ImagePicker();

  // Enumerations
  final List<String> sizes = const [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'FREE_SIZE',
  ];
  final List<String> types = const [
    "pant",
    "accessories",
    "jackets",
    "shirt",
    "dress",
    "abaya",
    "skirt",
    "top",
    "hijab",
    "jilbab",
    "khimar",
    "set",
    "other",
  ];
  final List<String> conditions = const ['new', 'like-new', 'good', 'fair'];
  // Category is fixed to "modest-fashion"; no dropdown.

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AddProductController>();
    _namePkController = TextEditingController(text: widget.product.namePk);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _colorController = TextEditingController();
    _selectedSize = widget.product.size;
    _selectedType = widget.product.type;
    _selectedCondition = widget.product.condition;
    // Category fixed; not editable in UI.
    _colors = widget.product.color.obs;
    _newPhotos = <XFile>[].obs;
    _removedImageIndices = <int>[].obs;
  }

  @override
  void dispose() {
    _namePkController.dispose();
    _descriptionController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void addColor(String value) {
    final c = value.trim();
    if (c.isEmpty) return;
    final exists = _colors.any((e) => e.toLowerCase() == c.toLowerCase());
    if (!exists) {
      _colors.add(c);
    }
    _colorController.clear();
  }

  void removeColor(int index) {
    if (index >= 0 && index < _colors.length) {
      _colors.removeAt(index);
    }
  }

  void removeExistingImage(int index) {
    if (!_removedImageIndices.contains(index)) {
      _removedImageIndices.add(index);
    }
  }

  Future<void> pickImages() async {
    try {
      final totalImages =
          (widget.product.images.length - _removedImageIndices.length) +
          _newPhotos.length;
      if (totalImages >= 5) {
        Get.snackbar(
          'Limit Reached',
          'You can have a maximum of 5 images',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final List<XFile> selectedImages = await _imagePicker.pickMultiImage(
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (selectedImages.isNotEmpty) {
        final availableSlots = 5 - totalImages;
        final imagesToAdd = selectedImages.take(availableSlots).toList();
        _newPhotos.addAll(imagesToAdd);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void removeNewPhoto(int index) {
    if (index >= 0 && index < _newPhotos.length) {
      _newPhotos.removeAt(index);
    }
  }

  Future<void> _saveChanges() async {
    if (_namePkController.text.isEmpty) {
      Get.snackbar(
        'Validation',
        'Product name is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Prepare image paths - combine remaining existing images with new photos
      final List<String> imagePaths = [];

      // Add remaining existing image URLs
      for (int i = 0; i < widget.product.images.length; i++) {
        if (!_removedImageIndices.contains(i)) {
          imagePaths.add(widget.product.images[i].url);
        }
      }

      // Add new photo paths
      for (final photo in _newPhotos) {
        imagePaths.add(photo.path);
      }

      await _controller.editProduct(
        widget.product.id,
        _namePkController.text.trim(),
        _selectedSize,
        _selectedType,
        _colors.toList(),
        'modest-fashion',
        _descriptionController.text.trim(),
        imagePaths,
        true,
        _selectedCondition,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
            'Edit Product',
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
                // Photos section
                Text(
                  'Photos',
                  style: GoogleFonts.inter(
                    fontSize: SizeUtils.scaleY(14),
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: SizeUtils.scaleY(8)),
                Obx(() {
                  final remainingExisting =
                      widget.product.images
                          .asMap()
                          .entries
                          .where((e) => !_removedImageIndices.contains(e.key))
                          .toList();
                  final totalImages =
                      remainingExisting.length + _newPhotos.length;
                  final canAddMore = totalImages < 5;

                  return GridView.builder(
                    itemCount: totalImages + (canAddMore ? 1 : 0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: SizeUtils.scaleX(8),
                      mainAxisSpacing: SizeUtils.scaleY(8),
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final isAddTile = index == totalImages;

                      if (isAddTile) {
                        return GestureDetector(
                          onTap: pickImages,
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

                      // Determine which image to show
                      if (index < remainingExisting.length) {
                        final entry = remainingExisting[index];
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
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  SizeUtils.scaleX(12),
                                ),
                                child: Image.network(
                                  entry.value.url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey.shade400,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => removeExistingImage(entry.key),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
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
                      } else {
                        final newPhotoIndex = index - remainingExisting.length;
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
                                    File(_newPhotos[newPhotoIndex].path),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => removeNewPhoto(newPhotoIndex),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
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
                      }
                    },
                  );
                }),
                SizedBox(height: SizeUtils.scaleY(6)),
                Obx(() {
                  final remaining =
                      widget.product.images.length -
                      _removedImageIndices.length +
                      _newPhotos.length;
                  return Text(
                    'Photos ($remaining/5)',
                    style: GoogleFonts.inter(
                      fontSize: SizeUtils.scaleY(12),
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  );
                }),
                SizedBox(height: SizeUtils.scaleY(24)),

                // Product name
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
                  controller: _namePkController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Black Abaya',
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
                SizedBox(height: SizeUtils.scaleY(16)),

                // Description
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
                  controller: _descriptionController,
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

                // Size and Type row
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
                          DropdownButtonFormField<String>(
                            value: _selectedSize,
                            isExpanded: true,
                            items:
                                sizes
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) {
                              setState(() {
                                _selectedSize = v ?? _selectedSize;
                              });
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
                          DropdownButtonFormField<String>(
                            value: _selectedType,
                            isExpanded: true,
                            items:
                                types
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(t),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) {
                              setState(() {
                                _selectedType = v ?? _selectedType;
                              });
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
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeUtils.scaleY(16)),

                // Condition (category removed; category fixed to "modest-fashion")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Condition',
                      style: GoogleFonts.inter(
                        fontSize: SizeUtils.scaleY(14),
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: SizeUtils.scaleY(8)),
                    DropdownButtonFormField<String>(
                      value: _selectedCondition,
                      isExpanded: true,
                      items:
                          conditions
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    c
                                        .split('-')
                                        .map(
                                          (word) =>
                                              word[0].toUpperCase() +
                                              word.substring(1),
                                        )
                                        .join(' '),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedCondition = v ?? _selectedCondition;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select',
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(
                          0.3,
                        ),
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
                  ],
                ),
                SizedBox(height: SizeUtils.scaleY(16)),

                // Colors section
                Text(
                  'Colors',
                  style: GoogleFonts.inter(
                    fontSize: SizeUtils.scaleY(14),
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: SizeUtils.scaleY(8)),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _colorController,
                        decoration: InputDecoration(
                          hintText: 'Add a color',
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
                        onSubmitted: addColor,
                      ),
                    ),
                    SizedBox(width: SizeUtils.scaleX(8)),
                    GestureDetector(
                      onTap: () => addColor(_colorController.text),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeUtils.scaleX(16),
                          vertical: SizeUtils.scaleY(14),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            SizeUtils.scaleX(12),
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: SizeUtils.scaleY(20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeUtils.scaleY(12)),
                Obx(
                  () => Wrap(
                    spacing: SizeUtils.scaleX(8),
                    runSpacing: SizeUtils.scaleY(8),
                    children:
                        _colors
                            .asMap()
                            .entries
                            .map(
                              (entry) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeUtils.scaleX(12),
                                  vertical: SizeUtils.scaleY(8),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.peach.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    SizeUtils.scaleY(8),
                                  ),
                                  border: Border.all(
                                    color: AppColors.peach,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      entry.value,
                                      style: GoogleFonts.inter(
                                        fontSize: SizeUtils.scaleY(12),
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    SizedBox(width: SizeUtils.scaleX(6)),
                                    GestureDetector(
                                      onTap: () => removeColor(entry.key),
                                      child: Icon(
                                        Icons.close,
                                        size: SizeUtils.scaleY(14),
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                SizedBox(height: SizeUtils.scaleY(16)),

                // Availability toggle
                SizedBox(height: SizeUtils.scaleY(32)),

                // Save button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          _controller.isLoading.value ? null : _saveChanges,
                      icon: const FaIcon(FontAwesomeIcons.floppyDisk),
                      label: Text(
                        _controller.isLoading.value
                            ? 'Saving...'
                            : 'Save Changes',
                        style: GoogleFonts.poppins(
                          fontSize: SizeUtils.scaleY(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.primary.withOpacity(
                          0.5,
                        ),
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
                ),
                SizedBox(height: SizeUtils.scaleY(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
