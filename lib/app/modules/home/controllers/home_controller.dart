import 'package:get/get.dart';
import 'package:the_note_app/app/modules/note_edit/note_model.dart';

class HomeController extends GetxController {
  List<Note> notesList = <Note>[];

  void getLatestNotes() {
    notesList.addAll(List.generate(
        20,
        (index) => Note(
            title: "title $index",
            description: List.generate(2000, (index) => "description $index").join(" "),
            lastModifiedDate: DateTime.now()
                .subtract(Duration(days: index)))));
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
