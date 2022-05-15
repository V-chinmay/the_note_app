import 'dart:convert';
import 'package:amplify_flutter/amplify.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/data/models/note_model.dart';
import 'package:the_note_app/app/handlers/endpoints.dart';

abstract class NoteProviderInterface {
  NoteProviderInterface({required this.userID, required this.token});
  final String userID;
  final String token;

  Future<Result<List<Note>, NoteAPIError>> getAllNotes();
  Future<Result<Note, NoteAPIError>> getNoteDetail();
  Future<Result<Note, NoteAPIError>> createNote(Note note);
  Future<Result<Note, NoteAPIError>> updateNote(Note note);
  Future<Result<void, NoteAPIError>> deleteNote(Note note);
}

class NoteProvider extends GetConnect implements NoteProviderInterface {
  @override
  // TODO: implement token
  String get token => this._token;

  @override
  // TODO: implement userID
  String get userID => this._userID;

  late String _token;
  late String _userID;

  NoteProvider({required String userID, required String token}) {
    this._token = token;
    this._userID = token;
    httpClient.addRequestModifier((Request request) {
      request.headers["app_user_id"] = userID;
      return request;
    });

    httpClient.addAuthenticator((Request request) async {
      request.headers["Authorization"] = "Bearer $token";
      return request;
    });
    httpClient.timeout = Duration(seconds: 5);
    httpClient.baseUrl = Endpoints.baseURL;
  }

  @override
  void onClose() {
    httpClient.removeRequestModifier((Request request) => request);
    super.onClose();
  }

  @override
  Future<Result<List<Note>, NoteAPIError>> getAllNotes() async {
    Result<List<Note>, NoteAPIError> notesFetchResult;

    try {
      Response response = await get(Endpoints.getAlllNotesEndpoint);
      final responseBody = response.body;
      if (responseBody["Items"] == null) throw NoteAPIError.responseParsing;
      final notesListJson = (responseBody["Items"] as List<dynamic>);
      List<Note> notesList = notesListJson
          .map((e) => Note.fromJson(e)..isSyncedWithRemote = true)
          .toList();
      notesFetchResult = SuccessResult(notesList);
    } catch (error) {
      if (error == NoteAPIError.responseParsing)
        notesFetchResult = FailureResult(NoteAPIError.responseParsing);
      else
        notesFetchResult = FailureResult(NoteAPIError.unknown);
    }

    return notesFetchResult;
  }

  @override
  Future<Result<Note, NoteAPIError>> createNote(Note note) async {
    Result<Note, NoteAPIError> createNoteResult;
    try {
      Map<String, dynamic> requestBody = {"Item": note.toJson()};
      Response createNoteResponse =
          await post(Endpoints.updateNoteEndpoint, requestBody);
      if (createNoteResponse.hasError) throw NoteAPIError.responseParsing;
      Note? parsedNote;
      try {
        parsedNote = Note.fromJson(createNoteResponse.body);
      } catch (error) {
        throw NoteAPIError.responseParsing;
      }

      parsedNote.isSyncedWithRemote = true;
      createNoteResult = SuccessResult(parsedNote);
    } catch (error) {
      createNoteResult =
          FailureResult((error is NoteAPIError) ? error : NoteAPIError.unknown);
    }

    return createNoteResult;
  }

  @override
  Future<Result<void, NoteAPIError>> deleteNote(Note note) async {
    Result<void, NoteAPIError> deleteNoteResult;
    try {
      if (note.timestamp == null) throw "Failed to get timestamp to delete";
      Response deleteNoteResponse =
          await delete(Endpoints.deleteNoteByTimestamp(note.timestamp!));
      if (deleteNoteResponse.hasError) throw NoteAPIError.unknown;
      if (deleteNoteResponse.hasError) throw NoteAPIError.responseParsing;

      deleteNoteResult = SuccessResult(null);
    } catch (error) {
      deleteNoteResult =
          FailureResult(error is NoteAPIError ? error : NoteAPIError.unknown);
    }

    return deleteNoteResult;
  }

  @override
  Future<Result<Note, NoteAPIError>> getNoteDetail() {
    // TODO: implement getNoteDetail
    throw UnimplementedError();
  }

  @override
  Future<Result<Note, NoteAPIError>> updateNote(Note note) async {
    Result<Note, NoteAPIError> UpdateNoteResult;
    try {
      Map<String, dynamic> requestBody = {"Item": note.toJson()};
      Response updateNoteResponse =
          await patch(Endpoints.updateNoteEndpoint, requestBody);

      if (updateNoteResponse.hasError) throw NoteAPIError.responseParsing;

      Note? parsedNote;
      try {
        parsedNote = Note.fromJson(updateNoteResponse.body);
      } catch (error) {
        throw NoteAPIError.jsonDecodeError;
      }
      parsedNote.isSyncedWithRemote = true;
      UpdateNoteResult = SuccessResult(parsedNote);
    } catch (error) {
      UpdateNoteResult =
          FailureResult(error is NoteAPIError ? error : NoteAPIError.unknown);
    }

    return UpdateNoteResult;
  }
}
