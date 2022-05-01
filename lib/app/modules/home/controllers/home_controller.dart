import 'package:get/get.dart';
import 'package:the_note_app/app/data/app_database.dart';
import 'package:the_note_app/app/data/models/note_model.dart';

class HomeController extends GetxController {
  List<Note> notesList = <Note>[];

  void getLatestNotes() async {
    notesList = await Get.find<AppDatabase>().noteDao.getAllNotes();
    update();
    
  }

  @override
  void onInit() async {
    AppDatabase database = await AppDatabase.shared;
    Get.put(database);
    getLatestNotes();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
