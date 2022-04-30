import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../note_model.dart';

class NoteEditController extends GetxController {
  Note? _note;

  set note(Note note) {
    _note = note;
    titleEditingController =
        TextEditingController(text: GetUtils.capitalize(_note!.title!));
    descriptionEditingController = TextEditingController(
        text: GetUtils.capitalize(_note!.description ?? ""));
  }

  late TextEditingController descriptionEditingController;
  late TextEditingController titleEditingController;

  var isEditingMode = false.obs;

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
