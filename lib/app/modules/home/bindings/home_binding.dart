import 'package:get/get.dart';
import 'package:the_note_app/app/data/app_database.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    
  }
}
