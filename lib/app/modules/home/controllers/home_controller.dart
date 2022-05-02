import 'dart:async';

import 'package:get/get.dart';
import 'package:the_note_app/app/data/database/app_database.dart';
import 'package:the_note_app/app/data/models/note_model.dart';

class HomeController extends GetxController {
  List<Note> notesList = <Note>[];

  late AppDatabaseProxy _appDatabaseProxy = Get.find();

  StreamSubscription<List<Note>>? _streamSubscription;

  @override
  void onInit() async {
    Get.put(AppDatabaseProxy());

    _streamSubscription = _appDatabaseProxy.noteStream.listen((value) {
      notesList = value;
      update();
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
  }
}
