import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/data/database/app_database.dart';
import 'package:the_note_app/app/data/models/note_model.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';
import 'package:the_note_app/app/handlers/providers/note_provider.dart';

enum ControllerState { success, loading, failure }

class HomeController extends GetxController {
  List<Note> notesList = <Note>[];

  late AppDatabaseProxy _appDatabaseProxy = Get.find();
  late NoteProvider _noteProvider = Get.find();
  late CognitoAuthHandler _cognitoAuthHandler = Get.find();

  StreamSubscription<List<Note>>? _streamSubscription;

  var isSearchingMode = false.obs;

  var filteredNotesList = <Note>[];

  BehaviorSubject<ControllerState> _controllerStateSubject = BehaviorSubject();

  Stream<ControllerState> get controllerStateStream =>
      _controllerStateSubject.stream;

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

  Future<Result<void, AuthError>> logOutCurrentUser() async {
    String currentUserID = _cognitoAuthHandler.currentAuthorizedUserID!;
    final logoutResult = await _cognitoAuthHandler.logOut();
    if (logoutResult is SuccessResult) {
      await _appDatabaseProxy
          .clearAllNotes(currentUserID);
    }
    return logoutResult;
  }

  @override
  void onInit() async {
    _streamSubscription = _appDatabaseProxy.noteStream.listen((value) {
      notesList = value;
      update();
    });
    super.onInit();
  }

  Future<List<Note>> getAllNotesFromRemote() async {
    Result<List<Note>, NoteAPIError> allNotesResult =
        await _noteProvider.getAllNotes();
    if (allNotesResult is SuccessResult) {
      return allNotesResult.data!;
    }
    return [];
  }

  @override
  void onReady() async {
    super.onReady();
    _controllerStateSubject.add(ControllerState.loading);
    List<Note> allNotesFromRemote = await getAllNotesFromRemote();
    await _appDatabaseProxy.insertNewNotes(allNotesFromRemote);
    _controllerStateSubject.add(ControllerState.success);
  }

  @override
  void onClose() async {
    await _streamSubscription?.cancel();
    await _controllerStateSubject.close();
    queryEditingController.dispose();
    super.onClose();
  }
}
