import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addNote(String title, String content) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('notes').add({
      'uid': user.uid,
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
