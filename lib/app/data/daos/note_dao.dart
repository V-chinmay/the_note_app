import 'dart:ffi';

import 'package:floor/floor.dart';
import 'dart:async';

import 'package:the_note_app/app/data/models/note_model.dart';

@dao
abstract class NoteDao {
  @Query("SELECT * FROM Note WHERE userId=:userID")
  Future<List<Note>> getAllNotes(String userID);


  @Query("DELETE FROM Note WHERE userId=:userID")
  Future<void> deleteAllNotes(String userID);

  @Query("QUERY * FROM Note WHERE  userId=:userID AND  noteId=:noteId ")
  Future<Note?> getNoteWithID(String userID,String noteId);

  @Query("DELETE FROM Note WHERE  userId=:userID  AND noteId=:noteId")
  Future<void> deleteNoteWithID(String userID,String noteId);

  @update
  Future<void> updateNote(Note note);

  @insert
  Future<void> insertNote(Note note);
}
