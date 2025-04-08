import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:xgen_test/features/home/data/model/new_file_model.dart';
import 'package:xgen_test/features/home/presentation/add_notes_screen.dart';
import 'package:xgen_test/features/home/presentation/home_screen.dart';

class NoteDetailScreen extends StatelessWidget {
  static const route = '/note-detail';
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  void deleteNote(BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final notesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notes');

      await notesRef.doc(note.id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted successfully!')),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreen.route,
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting note: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditNoteScreen(note: note),
                  ),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => deleteNote(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(
              DateFormat.yMMMd().add_jm().format(note.timestamp),
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),
            Expanded(child: SingleChildScrollView(child: Text(note.content))),
          ],
        ),
      ),
    );
  }
}
