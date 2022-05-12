import 'package:get/get.dart';
import 'package:the_note_app/app/data/database/app_database.dart';
import 'package:the_note_app/app/handlers/providers/note_provider.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(AppDatabaseProxy());
    Get.put(NoteProvider());
    
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    
  }
}
