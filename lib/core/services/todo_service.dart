import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  CollectionReference get _todoRef =>
      _db.collection('users').doc(_uid).collection('todos');

  Stream<QuerySnapshot> getTodos() {
    return _todoRef.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> addTodo(String title) async {
    await _todoRef.add({
      'title': title,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleTodo(String id, bool value) async {
    await _todoRef.doc(id).update({'completed': value});
  }

  Future<void> deleteTodo(String id) async {
    await _todoRef.doc(id).delete();
  }
}
