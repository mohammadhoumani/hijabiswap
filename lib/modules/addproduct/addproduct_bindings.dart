import 'package:get/get.dart';
import 'package:hijabiswap/modules/addproduct/add_product_controller.dart';

class AddProductBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AddProductController>(AddProductController());
  }
}
