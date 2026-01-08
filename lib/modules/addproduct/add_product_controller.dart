import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijabiswap/data/services/product_service.dart';
import 'package:hijabiswap/modules/home/home_controller.dart';
import 'package:hijabiswap/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  final photos = <XFile>[].obs;
  final ProductService _productService = ProductService();
  final RxBool isLoading = false.obs;
  TextEditingController namePkController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final RxList<String> colors = <String>[].obs;

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

  // Selected values
  final Rxn<String> selectedSize = Rxn<String>();
  final Rxn<String> selectedType = Rxn<String>();
  final Rxn<String> selectedCondition = Rxn<String>();

  void addColor(String value) {
    final c = value.trim();
    if (c.isEmpty) return;
    final exists = colors.any((e) => e.toLowerCase() == c.toLowerCase());
    if (!exists) {
      colors.add(c);
    }
    colorController.clear();
  }

  void removeColor(int index) {
    if (index >= 0 && index < colors.length) {
      colors.removeAt(index);
    }
  }

  Future<void> pickImages() async {
    try {
      if (photos.length >= 5) {
        return; // Max 5 images reached
      }

      final List<XFile> selectedImages = await _imagePicker.pickMultiImage(
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (selectedImages.isNotEmpty) {
        final availableSlots = 5 - photos.length;
        final imagesToAdd = selectedImages.take(availableSlots).toList();
        photos.addAll(imagesToAdd);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < photos.length) {
      photos.removeAt(index);
    }
  }

  Future<void> editProduct(
    String productId,
    String namePk,
    String size,
    String type,
    List<String> color,
    String category,
    String description,
    List<String> images,
    bool isAvailable,
    String condition,
  ) async {
    try {
      print('════════════════════════════════════════════════════════');
      print('🛠️  EditProduct() invoked');
      print('  • productId: $productId');
      print('  • namePk: $namePk');
      print('  • size: $size');
      print('  • type: $type');
      print('  • category: $category');
      print('  • condition: $condition');
      print('  • isAvailable: $isAvailable');
      print('  • description length: ${description.length}');
      print('  • colors (${color.length}): ${color.join(', ')}');
      print('  • images (${images.length}):');
      for (var i = 0; i < images.length; i++) {
        print('      [$i] ${images[i]}');
      }

      isLoading.value = true;
      await _productService.editProduct(
        productId,
        namePk: namePk,
        size: size,
        type: type,
        color: color,
        category: category,
        description: description,
        images: images,
        isAvailable: isAvailable,
        condition: condition,
      );

      print('✅ editProduct service call completed successfully');

      // Navigate back and refresh
      await Get.find<HomeController>().fetchMyProducts();
      Get.back();

      await Future.delayed(Duration(milliseconds: 100));
      Get.snackbar(
        'Success',
        'Product edited successfully',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      );
    } catch (e) {
      print('❌ Error in editProduct: $e');
      Get.snackbar(
        'Error',
        'Failed to edit product: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      );
      print('Error editing product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(
    String namePk,
    String size,
    String type,
    List<String> color,
    String category,
    String description,
    List<String> images,
    bool isAvailable,
    String condition,
  ) async {
    if (selectedSize.value == null ||
        selectedType.value == null ||
        selectedCondition.value == null ||
        colors.isEmpty ||
        namePk.isEmpty ||
        category.isEmpty ||
        description.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields and add at least 1 color',
        colorText: Colors.white,
        backgroundColor: AppColors.primary,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;

    try {
      await _productService.addProduct(
        namePk: namePk,
        size: size,
        type: type,
        color: color,
        category: category,
        description: description,
        images: images,
        isAvailable: isAvailable,
        condition: condition,
      );

      Get.snackbar(
        'Success',
        'Product added successfully',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      );

      // Clear form
      namePkController.clear();
      colorController.clear();
      categoryController.clear();
      descriptionController.clear();
      photos.clear();
      colors.clear();
      selectedSize.value = null;
      selectedType.value = null;
      selectedCondition.value = null;

      // Navigate back after a short delay
      await Future.delayed(Duration(milliseconds: 500));
      Get.back();
      await Get.find<HomeController>().fetchMyProducts();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add product: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      );
      print('Error adding product: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
