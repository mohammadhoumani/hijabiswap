import 'package:get/get.dart';
import 'package:hijabiswap/modules/favorites/favorites_controller.dart';

class FavoritesBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<FavoritesController>(FavoritesController());
  }
}
