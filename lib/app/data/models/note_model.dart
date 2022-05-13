import 'package:floor_annotation/floor_annotation.dart';

@entity
class Note {
  @primaryKey
  String? noteId;
  String? content;
  String? userId;
  int? expires;
  String? cat;
  int? timestamp;
  
  String? title;

  DateTime? get timeStampDate => timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp!) : null;

  Note(
      {this.content,
      this.userId,
      this.expires,
      this.cat,
      this.timestamp,
      this.noteId,
      this.title});

  Note.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    userId = json['user_id'];
    expires = json['expires'];
    cat = json['cat'];
    timestamp = json['timestamp'];
    noteId = json['note_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['content'] = content;
    data['user_id'] = userId;
    data['expires'] = expires;
    data['cat'] = cat;
    data['timestamp'] = timestamp;
    data['note_id'] = noteId;
    data['title'] = title;
    return data;
  }
}
