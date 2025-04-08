import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:xgen_test/features/home/domain/fire_store_provider.dart';
import 'package:xgen_test/features/home/presentation/add_notes_screen.dart';
import 'package:xgen_test/features/home/presentation/note_details_screen.dart';
import 'package:xgen_test/features/profile/presentation/profile.dart';

class HomeScreen extends ConsumerWidget {
  static const String route = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        leading: SizedBox(),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, UserProfileScreen.route),
            child: Icon(Icons.person),
          ),
          SizedBox(width: 20.w),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(child: Text("No notes yet."));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(
                  DateFormat.yMMMd().add_jm().format(note.timestamp),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NoteDetailScreen.route,
                    arguments: NoteDetailScreen(note: note),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddEditNoteScreen.route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
