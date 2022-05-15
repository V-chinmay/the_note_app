import 'package:floor_annotation/floor_annotation.dart';
import 'package:the_note_app/app/common/errors.dart';

@entity
class Note {
  @primaryKey
  String? noteID;
  String? content;
  String? userID;
  int? expires;
  String? cat;
  int? timestamp;

  int? get timeStampInMilliseconds => timestamp != null ? timestamp! * 1000 : null;

  bool isSyncedWithRemote = false;

  String? title;

  DateTime? get timeStampDate => timeStampInMilliseconds != null
      ? DateTime.fromMillisecondsSinceEpoch(timeStampInMilliseconds!)
      : null;

  Note(
      {this.content,
      this.userID,
      this.expires,
      this.cat,
      this.timestamp,
      this.noteID,
      this.title});

  Note.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    userID = json['user_id'];
    expires = json['expires'];
    cat = json['cat'];
    timestamp = json['timestamp'];
    noteID = json['note_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['content'] = content;
    data['user_id'] = userID;
    data['expires'] = expires;
    data['cat'] = cat;
    data['timestamp'] = timestamp;
    data['note_id'] = noteID;
    data['title'] = title;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
