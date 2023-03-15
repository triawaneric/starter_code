import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  dynamic id;
  String? title;
  String? content;
  Timestamp? dateCreated;

  Note({this.id = 0, this.title = '', this.content = '', this.dateCreated });

  Note.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.reference.id;
    title = documentSnapshot['title'];
    content = documentSnapshot['content'];
    dateCreated = documentSnapshot['dateCreated'];
  }

  Note.fromJson(Map<String, dynamic> json)
      : this(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      dateCreated : json['dateCreated']
  );

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'title': title,
        'content': content,
        'dateCreated':dateCreated
      };
}
