import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_exam/models/note.dart';
import 'package:map_exam/models/user.dart';


class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(uid).get();
      return UserModel.fromDocumentSnapshot(documentSnapshot: doc);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      rethrow;
    }
  }



  Future<void> addNote(String title, String content, String uid) async {
    try {
      await _firestore.collection('users').doc(uid).collection('notes').add(
          {'title': title, 'content': content, 'dateCreated': Timestamp.now()});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<Note>> noteStream(String uid) {


    return _firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .orderBy('dateCreated', descending: false)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Note> retVel = [];
      for (var element in query.docs) {
        retVel.add(Note.fromDocumentSnapshot(element));
      }
      return retVel;
    });
  }

  Future deleteData(String id, String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection("notes")
          .doc(id)
          .delete();
    } catch (e) {
      return false;
    }
  }

    //
  Future<void> updateNote(String  title, String content ,String uid, String id, ) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('notes')
          .doc(id)
          .update({
          'title': title,
          'content' : content,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}