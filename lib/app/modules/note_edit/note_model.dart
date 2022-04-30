class Note {
  String? title;
  String? description;
  DateTime? lastModifiedDate;

  Note({this.title, this.description, this.lastModifiedDate});

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    lastModifiedDate = int.parse(json['last_modified_date']!) != null ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['last_modified_date']!)) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['last_modified_date'] = lastModifiedDate;
    return data;
  }
}
