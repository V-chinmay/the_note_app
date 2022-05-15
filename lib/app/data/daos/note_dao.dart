import 'dart:ffi';

import 'package:floor/floor.dart';
import 'dart:async';

import 'package:the_note_app/app/data/models/note_model.dart';

@dao
abstract class NoteDao {
  @Query("SELECT * FROM Note WHERE userID=:userID")
  Future<List<Note>> getAllNotes(String userID);

  @Query("DELETE FROM Note WHERE userID=:userID")
  Future<void> deleteAllNotes(String userID);

  @Query("QUERY * FROM Note WHERE  userID=:userID AND  noteID=:noteID ")
  Future<Note?> getNoteWithID(String userID, String noteID);

  @Query("DELETE FROM Note WHERE  userID=:userID  AND noteID=:noteID")
  Future<void> deleteNoteWithID(String userID, String noteID);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateNote(Note note);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNote(Note note);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotes(List<Note> notes);
}
