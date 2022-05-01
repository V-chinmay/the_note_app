import 'dart:ffi';

import 'package:floor/floor.dart';
import 'dart:async';

import 'package:the_note_app/app/data/models/note_model.dart';

@dao
abstract class NoteDao {
  @Query("SELECT * FROM Note")
  Future<List<Note>> getAllNotes();


  @Query("SELECT * FROM Note")
  Future<Stream<List<Note>>?> getAllNotesAsStream();

  @Query("DELETE FROM Note")
  Future<void> deleteAllNotes();

  @Query("QUERY * FROM Note WHERE id=:id")
  Future<Note?> getNoteWithID(String id);

  @Query("DELETE FROM Note WHERE id=:id")
  Future<void> deleteNoteWithID(String id);

  @update
  Future<void> updateNote(Note note);

  @insert
  Future<void> insertNote(Note note);
}
