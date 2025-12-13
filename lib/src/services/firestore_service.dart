import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';
import '../models/user_profile.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ----- Profile -----
  Future<void> createOrUpdateProfile(String uid, Map<String, dynamic> data) {
    final ref = _db.collection('users').doc(uid);
    return ref.set(data, SetOptions(merge: true));
  }

  Future<UserProfile?> getProfile(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    if (!snap.exists) return null;
    return UserProfile.fromMap(uid, snap.data()!);
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) {
    final ref = _db.collection('users').doc(uid);
    return ref.update(data);
  }

  // ----- Todos (subcollection) -----
  Future<String> createTodo(String uid, Map<String, dynamic> data) async {
    final ref = _db.collection('users').doc(uid).collection('todos').doc();
    await ref.set(data);
    return ref.id;
  }

  Stream<List<Todo>> todosStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('todos')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Todo.fromDoc(d)).toList());
  }

  Future<void> updateTodo(String uid, String todoId, Map<String, dynamic> data) async {
    final ref = _db.collection('users').doc(uid).collection('todos').doc(todoId);
    return ref.update(data);
  }

  Future<void> deleteTodo(String uid, String todoId) async {
    final ref = _db.collection('users').doc(uid).collection('todos').doc(todoId);
    return ref.delete();
  }
}
