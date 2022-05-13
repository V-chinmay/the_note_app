import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/data/database/app_database.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';

import '../../../data/models/note_model.dart';
import 'package:the_note_app/app/common/extensions/datetime.dart';

class NoteEditController extends GetxController {
  late Note _note;

  bool isNewNote = false;

  set note(Note note) {
    _note = note;
    titleEditingController =
        TextEditingController(text: GetUtils.capitalize(_note.title ?? ""));
    descriptionEditingController =
        TextEditingController(text: GetUtils.capitalize(_note.content ?? ""));
  }

  late TextEditingController descriptionEditingController;
  late TextEditingController titleEditingController;
  String get lastModifiedDate =>
      (_note.timeStampDate ?? DateTime.now()).formattedDateString();

  late var isEditingMode = (false | isNewNote).obs;

  late AppDatabaseProxy _appDatabaseProxy = Get.find();

  Future<void> deleteNote() async {
    await _appDatabaseProxy.deleteNote(_note);
  }

  Future<void> updateNote() async {
    _note.timestamp = DateTime.now().millisecond;
    _note.content = descriptionEditingController.text;
    _note.title = titleEditingController.text;

    if (_note.noteId == null) {
      _note.noteId = _note.hashCode.toRadixString(16);
      _note.userId = Get.find<CognitoAuthHandler>().currentAuthorizedUserID!;
      await _appDatabaseProxy.insertNewNote(_note);
    } else {
      await _appDatabaseProxy.updateNote(_note);
    }
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
  void onClose() {
    descriptionEditingController.dispose();
    titleEditingController.dispose();
  }
}
