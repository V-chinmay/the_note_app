part of 'app_database.dart';

enum DatabaseOperation { insert, update, delete, clear }

class AppDatabaseProxy {
  AppDatabaseProxy(){
    _updateNoteStreamWithLatestNotes();
  }
  _AppDatabase? __appDatabase;

  Future<_AppDatabase> get _appDatabase async {
    if (__appDatabase == null) {
      __appDatabase = await _AppDatabase.shared;
    }
    return __appDatabase!;
  }

  BehaviorSubject<List<Note>> noteStream = BehaviorSubject();

  Future<void> insertNewNote(Note note) async {
    await _performDBOperation(note, DatabaseOperation.insert);
  }

  Future<void> updateNote(Note note) async {
    await _performDBOperation(note, DatabaseOperation.update);
  }

  Future<void> deleteNote(Note note) async {
    await _performDBOperation(note, DatabaseOperation.delete);
  }

  Future<void> clearAllNotes(Note note) async {
    await _performDBOperation(note, DatabaseOperation.clear);
  }

  _performDBOperation(Note note, DatabaseOperation databaseOperation) async {
    switch (databaseOperation) {
      case DatabaseOperation.insert:
        await (await _appDatabase).noteDao.insertNote(note);
        break;
      case DatabaseOperation.update:
        await (await _appDatabase).noteDao.updateNote(note);
        break;
      case DatabaseOperation.delete:
        await (await _appDatabase).noteDao.deleteNoteWithID(note.id!);
        break;
      case DatabaseOperation.clear:
        await (await _appDatabase).noteDao.deleteAllNotes();
        break;
    }
    _updateNoteStreamWithLatestNotes();
  }

  void _updateNoteStreamWithLatestNotes() async {
    noteStream.add(await (await _appDatabase).noteDao.getAllNotes());
  }
}
