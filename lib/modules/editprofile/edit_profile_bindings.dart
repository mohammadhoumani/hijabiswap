import 'package:get/get.dart';
import 'package:hijabiswap/modules/editprofile/edit_profile_controller.dart';

class EditProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}
