import 'package:get/get.dart';

import 'package:hijabiswap/modules/confirmorder/confirm_order_controller.dart';

class ConfirmOrderBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmOrderController>(() => ConfirmOrderController());
  }
}
