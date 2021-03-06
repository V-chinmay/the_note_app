// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $Floor_AppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$_AppDatabaseBuilder databaseBuilder(String name) =>
      _$_AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$_AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$_AppDatabaseBuilder(null);
}

class _$_AppDatabaseBuilder {
  _$_AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$_AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$_AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<_AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$_AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$_AppDatabase extends _AppDatabase {
  _$_AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NoteDao? _noteDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Note` (`noteID` TEXT, `content` TEXT, `userID` TEXT, `expires` INTEGER, `cat` TEXT, `timestamp` INTEGER, `isSyncedWithRemote` INTEGER NOT NULL, `title` TEXT, PRIMARY KEY (`noteID`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NoteDao get noteDao {
    return _noteDaoInstance ??= _$NoteDao(database, changeListener);
  }
}

class _$NoteDao extends NoteDao {
  _$NoteDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _noteInsertionAdapter = InsertionAdapter(
            database,
            'Note',
            (Note item) => <String, Object?>{
                  'noteID': item.noteID,
                  'content': item.content,
                  'userID': item.userID,
                  'expires': item.expires,
                  'cat': item.cat,
                  'timestamp': item.timestamp,
                  'isSyncedWithRemote': item.isSyncedWithRemote ? 1 : 0,
                  'title': item.title
                }),
        _noteUpdateAdapter = UpdateAdapter(
            database,
            'Note',
            ['noteID'],
            (Note item) => <String, Object?>{
                  'noteID': item.noteID,
                  'content': item.content,
                  'userID': item.userID,
                  'expires': item.expires,
                  'cat': item.cat,
                  'timestamp': item.timestamp,
                  'isSyncedWithRemote': item.isSyncedWithRemote ? 1 : 0,
                  'title': item.title
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Note> _noteInsertionAdapter;

  final UpdateAdapter<Note> _noteUpdateAdapter;

  @override
  Future<List<Note>> getAllNotes(String userID) async {
    return _queryAdapter.queryList('SELECT * FROM Note WHERE userID=?1',
        mapper: (Map<String, Object?> row) => Note(
            content: row['content'] as String?,
            userID: row['userID'] as String?,
            expires: row['expires'] as int?,
            cat: row['cat'] as String?,
            timestamp: row['timestamp'] as int?,
            noteID: row['noteID'] as String?,
            title: row['title'] as String?),
        arguments: [userID]);
  }

  @override
  Future<void> deleteAllNotes(String userID) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Note WHERE userID=?1', arguments: [userID]);
  }

  @override
  Future<Note?> getNoteWithID(String userID, String noteID) async {
    return _queryAdapter.query(
        'QUERY * FROM Note WHERE  userID=?1 AND  noteID=?2',
        mapper: (Map<String, Object?> row) => Note(
            content: row['content'] as String?,
            userID: row['userID'] as String?,
            expires: row['expires'] as int?,
            cat: row['cat'] as String?,
            timestamp: row['timestamp'] as int?,
            noteID: row['noteID'] as String?,
            title: row['title'] as String?),
        arguments: [userID, noteID]);
  }

  @override
  Future<void> deleteNoteWithID(String userID, String noteID) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Note WHERE  userID=?1  AND noteID=?2',
        arguments: [userID, noteID]);
  }

  @override
  Future<void> insertNote(Note note) async {
    await _noteInsertionAdapter.insert(note, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertNotes(List<Note> notes) async {
    await _noteInsertionAdapter.insertList(notes, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateNote(Note note) async {
    await _noteUpdateAdapter.update(note, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
