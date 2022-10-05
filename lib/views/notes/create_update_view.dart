import 'package:dstnotes/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';
import '../../services/crud/notes_service.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteView();
}

class _CreateUpdateNoteView extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesService = NotesService();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textEditingControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    } else {
      _notesService.updateNote(note: note, text: _textEditingController.text);
    }
  }

  void _setupTextEditingController() {
    _textEditingController.removeListener(_textEditingControllerListener);
    _textEditingController.addListener(_textEditingControllerListener);
  }

  Future<DatabaseNote> creatOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textEditingController.text = widgetNote.text;
      return widgetNote;
    }

    final exitingNote = _note;
    if (exitingNote != null) {
      return exitingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = await _notesService.getUser(email: currentUser.email!);
    final createNote = await _notesService.createNote(owner: email);

    _note = createNote;
    return createNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    if (_textEditingController.text.isNotEmpty && note != null) {
      await _notesService.updateNote(
          note: note, text: _textEditingController.text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create note"),
        ),
        body: FutureBuilder(
          future: creatOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextEditingController();
                return TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your note...',
                  ),
                );

              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
