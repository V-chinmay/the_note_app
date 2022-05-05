import 'package:get/get.dart';

import '../controllers/user_verification_controller.dart';

class UserVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserVerificationController>(
      () => UserVerificationController(),
    );
  }
}
