import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/data/models/note_model.dart';
import 'package:the_note_app/app/handlers/endpoints.dart';

abstract class NoteProviderInterface {
  Future<Result<List<Note>, NoteAPIError>> getAllNotes(
      {required String userID});
  Future<Result<Note, NoteAPIError>> getNoteDetail(
      {required String userID, required String noteID});
  Future<Result<Note, NoteAPIError>> addNote(Note note,
      {required String userID, required String noteID});
  Future<Result<void, NoteAPIError>> updateNote(
      {required String userID, required String noteID});
  Future<Result<void, NoteAPIError>> deleteNote(
      {required String userID, required String noteID});
}

class NoteProvider implements NoteProviderInterface {
  @override
  Future<Result<Note, NoteAPIError>> addNote(Note note,
      {required String userID, required String noteID}) {
    // TODO: implement addNote
    throw UnimplementedError();
  }

  @override
  Future<Result<void, NoteAPIError>> deleteNote(
      {required String userID, required String noteID}) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  

  @override
  Future<Result<List<Note>, NoteAPIError>> getAllNotes(
      {required String userID}) async {
    Result<List<Note>, NoteAPIError> notesFetchResult;
    
    try {
      RestOptions restOptions =
          RestOptions(path: Endpoints.getAlllNotesEndpoint,apiName: "get_notes");

      RestResponse response =
          await Amplify.API.get(restOptions: restOptions).response;

      List<dynamic> responseJson =
          jsonDecode(String.fromCharCodes(response.data));

      List<Note> allNotesList =
          responseJson.map((e) => Note.fromJson(e)).toList();

      notesFetchResult = SuccessResult(allNotesList);
    } on ApiException catch (error) {
      notesFetchResult = FailureResult(NoteAPIError("500", error.message));
    }

    return notesFetchResult;
  }

  @override
  Future<Result<Note, NoteAPIError>> getNoteDetail(
      {required String userID, required String noteID}) {
    // TODO: implement getNoteDetail
    throw UnimplementedError();
  }

  @override
  Future<Result<void, NoteAPIError>> updateNote(
      {required String userID, required String noteID}) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}
