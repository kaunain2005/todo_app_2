import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'firestore_service.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> register(String email, String password, {String? displayName}) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    if (displayName != null) {
      await cred.user?.updateDisplayName(displayName);
      await cred.user?.reload();
    }

    // FIX: Use cred.user, avoid null race condition
    final user = cred.user!;

    await _firestore.createOrUpdateProfile(user.uid, {
      'displayName': displayName ?? '',
      'email': user.email ?? '',
      'bio': '',
    });

    notifyListeners();
    return cred;
  }

  Future<UserCredential> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
    return cred;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
