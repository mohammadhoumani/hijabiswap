import 'package:get/get.dart';
import 'package:hijabiswap/modules/activity/activity_controller.dart';

class ActivityBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ActivityController>(ActivityController());
  }
}
