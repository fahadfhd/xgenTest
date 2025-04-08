import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xgen_test/features/home/data/model/new_file_model.dart';
import 'package:xgen_test/features/home/domain/fire_store_provider.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  final auth = FirebaseAuth.instance;
  return NotesRepository(firestore, auth);
});

class NotesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NotesRepository(this._firestore, this._auth);

  CollectionReference get _notesRef => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('notes');

  Stream<List<Note>> getNotes() {
    return _notesRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => Note.fromDoc(doc)).toList(),
        );
  }

  Future<void> addNote(Note note) {
    return _notesRef.add(note.toMap());
  }

  Future<void> updateNote(String id, Note note) {
    return _notesRef.doc(id).update(note.toMap());
  }

  Future<void> deleteNote(String id) {
    return _notesRef.doc(id).delete();
  }
}
