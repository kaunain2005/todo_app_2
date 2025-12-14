// lib/core/services/profile_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  DocumentReference get _userRef => _db.collection('users').doc(_uid);

  Stream<DocumentSnapshot> profileStream() {
    return _userRef.snapshots();
  }

  Future<void> updateName(String name) async {
    await _userRef.update({'name': name});
  }

  Future<void> updateTheme(String theme) async {
    await _userRef.update({'theme': theme});
  }

  Future<String?> getThemeOnce() async {
    final doc = await _userRef.get();
    final data = doc.data() as Map<String, dynamic>?;
    return data?['theme'];
  }
}
