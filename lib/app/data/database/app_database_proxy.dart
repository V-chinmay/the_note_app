part of 'app_database.dart';

enum DatabaseOperation { insert, update, delete, clear }

class AppDatabaseProxy {
  AppDatabaseProxy(this.currentUserID) {
    _updateNoteStreamWithLatestNotes(userID: this.currentUserID);
  }
  _AppDatabase? __appDatabase;
  String currentUserID;

  Future<_AppDatabase> get _appDatabase async {
    if (__appDatabase == null) {
      __appDatabase = await _AppDatabase.shared;
    }
    return __appDatabase!;
  }

  BehaviorSubject<List<Note>> noteStream = BehaviorSubject();

  Future<void> insertNewNotes(List<Note> notes) async {
    await _performDBOperation(notes, DatabaseOperation.insert);
  }

  Future<void> insertNewNote(Note note) async {
    await _performDBOperation([note], DatabaseOperation.insert);
  }

  Future<void> updateNote(Note note) async {
    await _performDBOperation([note], DatabaseOperation.update);
  }

  Future<void> deleteNote(Note note) async {
    await _performDBOperation([note], DatabaseOperation.delete);
  }

  Future<void> clearAllNotes(String userID) async {
    await _performDBOperation([Note(userID: userID)], DatabaseOperation.clear);
  }

  _performDBOperation(
      List<Note> note, DatabaseOperation databaseOperation) async {
    switch (databaseOperation) {
      case DatabaseOperation.insert:
        await (await _appDatabase).noteDao.insertNotes(note);
        break;
      case DatabaseOperation.update:
        await (await _appDatabase).noteDao.updateNote(note[0]);
        break;
      case DatabaseOperation.delete:
        await (await _appDatabase)
            .noteDao
            .deleteNoteWithID(note[0].userID!, note[0].noteID!);
        break;
      case DatabaseOperation.clear:
        await (await _appDatabase).noteDao.deleteAllNotes(note[0].userID!);
        break;
    }
    _updateNoteStreamWithLatestNotes(userID: this.currentUserID);
  }

  void _updateNoteStreamWithLatestNotes({required String userID}) async {
    noteStream.add(await (await _appDatabase).noteDao.getAllNotes(userID));
  }
}
