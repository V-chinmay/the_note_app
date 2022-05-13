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
            'CREATE TABLE IF NOT EXISTS `Note` (`noteId` TEXT, `content` TEXT, `userId` TEXT, `expires` INTEGER, `cat` TEXT, `timestamp` INTEGER, `title` TEXT, PRIMARY KEY (`noteId`))');

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
                  'noteId': item.noteId,
                  'content': item.content,
                  'userId': item.userId,
                  'expires': item.expires,
                  'cat': item.cat,
                  'timestamp': item.timestamp,
                  'title': item.title
                }),
        _noteUpdateAdapter = UpdateAdapter(
            database,
            'Note',
            ['noteId'],
            (Note item) => <String, Object?>{
                  'noteId': item.noteId,
                  'content': item.content,
                  'userId': item.userId,
                  'expires': item.expires,
                  'cat': item.cat,
                  'timestamp': item.timestamp,
                  'title': item.title
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Note> _noteInsertionAdapter;

  final UpdateAdapter<Note> _noteUpdateAdapter;

  @override
  Future<List<Note>> getAllNotes(String userID) async {
    return _queryAdapter.queryList('SELECT * FROM Note WHERE userId=?1',
        mapper: (Map<String, Object?> row) => Note(
            content: row['content'] as String?,
            userId: row['userId'] as String?,
            expires: row['expires'] as int?,
            cat: row['cat'] as String?,
            timestamp: row['timestamp'] as int?,
            noteId: row['noteId'] as String?,
            title: row['title'] as String?),
        arguments: [userID]);
  }

  @override
  Future<void> deleteAllNotes(String userID) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Note WHERE userId=?1', arguments: [userID]);
  }

  @override
  Future<Note?> getNoteWithID(String userID, String noteId) async {
    return _queryAdapter.query(
        'QUERY * FROM Note WHERE  userId=?1 AND  noteId=?2',
        mapper: (Map<String, Object?> row) => Note(
            content: row['content'] as String?,
            userId: row['userId'] as String?,
            expires: row['expires'] as int?,
            cat: row['cat'] as String?,
            timestamp: row['timestamp'] as int?,
            noteId: row['noteId'] as String?,
            title: row['title'] as String?),
        arguments: [userID, noteId]);
  }

  @override
  Future<void> deleteNoteWithID(String userID, String noteId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Note WHERE  userId=?1  AND noteId=?2',
        arguments: [userID, noteId]);
  }

  @override
  Future<void> insertNote(Note note) async {
    await _noteInsertionAdapter.insert(note, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateNote(Note note) async {
    await _noteUpdateAdapter.update(note, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
