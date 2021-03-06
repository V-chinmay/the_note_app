import 'package:floor/floor.dart';
import 'package:get/state_manager.dart';
import 'package:rxdart/subjects.dart';
import 'package:the_note_app/app/data/daos/note_dao.dart';
import 'package:the_note_app/app/data/models/note_model.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';
part 'app_database_proxy.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Note])
abstract class _AppDatabase extends FloorDatabase {
  NoteDao get noteDao;

  static Future<_AppDatabase> get shared async =>
      await $Floor_AppDatabase.databaseBuilder("app_database.db").build();
}

class DateTimeConverter extends TypeConverter<DateTime?, int?> {
  @override
  DateTime? decode(int? databaseValue) {
    if (databaseValue == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int? encode(DateTime? value) {
    if (value == null) return null;
    return value.millisecondsSinceEpoch;
  }
}
