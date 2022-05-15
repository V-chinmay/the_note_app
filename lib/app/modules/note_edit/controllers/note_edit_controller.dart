import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/data/database/app_database.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';
import 'package:the_note_app/app/handlers/providers/note_provider.dart';
import 'package:the_note_app/app/modules/home/controllers/home_controller.dart';

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

  BehaviorSubject<ControllerState> _controllerStateSubject = BehaviorSubject();

  Stream<ControllerState> get controllerStateStream =>
      _controllerStateSubject.stream;

  late TextEditingController descriptionEditingController;
  late TextEditingController titleEditingController;

  int TITLE_MAX_LENGTH = 15;

  String get lastModifiedDate =>
      (_note.timeStampDate ?? DateTime.now()).formattedDateString();

  late var isEditingMode = (false | isNewNote).obs;

  var isASaveableEdit = false.obs;

  late AppDatabaseProxy _appDatabaseProxy = Get.find();
  late NoteProvider _noteProvider = Get.find();
  late String? _currentAuthorizedUserID =
      Get.find<CognitoAuthHandler>().currentAuthorizedUserID;

  Future<void> deleteNote() async {
    _controllerStateSubject.add(ControllerState.loading);
    Result<void, NoteAPIError> remoteDeleteNoteResult =
        await _noteProvider.deleteNote(_note);
    if (remoteDeleteNoteResult is SuccessResult) {
      await _appDatabaseProxy.deleteNote(_note);
    }
    _controllerStateSubject.add(ControllerState.success);
  }

  Future<void> updateNote() async {
    _note.timestamp = DateTime.now().millisecondsSinceEpoch;
    _note.content = descriptionEditingController.text;
    _note.title = titleEditingController.text;
    _controllerStateSubject.add(ControllerState.loading);

    if (_note.noteID == null) {
      _note.noteID = _note.hashCode.toRadixString(16);
      _note.userID = Get.find<CognitoAuthHandler>().currentAuthorizedUserID!;
      Result<Note, Error> remoteCreateResult =
          await _noteProvider.createNote(_note);
      if (remoteCreateResult is FailureResult) {
        _controllerStateSubject.add(ControllerState.failure);
        //failed to create note in the remote only saving it to db
        return;
      }
      _note = remoteCreateResult.data!;
      await _appDatabaseProxy.insertNewNote(_note);
    } else {
      Result<Note, NoteAPIError> remoteUpdateResult =
          await _noteProvider.updateNote(_note);
      if (remoteUpdateResult is FailureResult) {
        //failed to create note in the remote only saving it to db
        _controllerStateSubject.add(ControllerState.failure);
        return;
      }
      _note = remoteUpdateResult.data!;
      await _appDatabaseProxy.updateNote(_note);
    }
    _controllerStateSubject.add(ControllerState.success);
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
    _controllerStateSubject.close();
    descriptionEditingController.dispose();
    titleEditingController.dispose();
  }
}
