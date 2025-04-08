import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xgen_test/features/home/data/model/new_file_model.dart';
import 'package:xgen_test/features/home/presentation/home_screen.dart';

class AddEditNoteScreen extends StatefulWidget {
  static const route = '/add-edit-note';
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  Future<void> saveNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final notesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notes');

      if (widget.note != null) {
        await notesRef.doc(widget.note!.id).update({
          'title': title,
          'content': content,
          'timestamp': DateTime.now(),
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note updated successfully!')),
          );
        }
      } else {
        await notesRef.add({
          'title': title,
          'content': content,
          'timestamp': DateTime.now(),
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note created successfully!')),
          );
        }
      }

      await Future.delayed(const Duration(milliseconds: 300));

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.route,
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving note: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Note' : 'Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Note'),
              onPressed: saveNote,
            ),
          ],
        ),
      ),
    );
  }
}
