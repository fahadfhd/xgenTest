import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) => AuthController(ref));

class AuthController {
  final Ref ref;
  AuthController(this.ref);

  Future<void> signUp(String email, String password) async {
    await ref
        .read(firebaseAuthProvider)
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await ref
        .read(firebaseAuthProvider)
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await ref.read(firebaseAuthProvider).signOut();
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
