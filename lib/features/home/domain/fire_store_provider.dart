import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xgen_test/features/home/data/model/new_file_model.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final notesProvider = StreamProvider<List<Note>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  final notesRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('notes')
      .orderBy('timestamp', descending: true);

  return notesRef.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Note.fromDoc(doc)).toList();
  });
});
