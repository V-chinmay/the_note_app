import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/data/database/app_database.dart';
import 'package:the_note_app/app/data/models/note_model.dart';
import 'package:the_note_app/app/handlers/providers/note_provider.dart';

class HomeController extends GetxController {
  List<Note> notesList = <Note>[];

  late AppDatabaseProxy _appDatabaseProxy = Get.find();
  late NoteProvider _noteProvider = Get.find();

  StreamSubscription<List<Note>>? _streamSubscription;

  var isSearchingMode = false.obs;

  var filteredNotesList = <Note>[];

  TextEditingController queryEditingController = TextEditingController();

  void toggleSearchingMode() {
    filteredNotesList = notesList;
    isSearchingMode.value = false;
    queryEditingController.clear();
  }

  void onQueryChanged(String? query) {
    filteredNotesList = query == null
        ? notesList
        : notesList
            .where((element) =>
                element.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();
    update();
  }

  @override
  void onInit() async {
    _streamSubscription = _appDatabaseProxy.noteStream.listen((value) {
      notesList = value;
      update();
    });

    Result<List<Note>,NoteAPIError> note = await this._noteProvider.getAllNotes(userID: "");

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    queryEditingController.dispose();
    super.onClose();
  }
}
