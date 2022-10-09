import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dstnotes/services/cloud/cloud_storage_constants.dart';
import 'package:dstnotes/services/cloud/cloud_storage_exceptions.dart';

import 'cloud_note.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  void createNewNote({required String ownerUserId}) async {
    await notes.add({ownerUserIdField: ownerUserId, textField: ''});
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((e) => CloudNote.fromSnapshot(e))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<Iterable<CloudNote>> getNotesByUserId(
      {required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdField, isEqualTo: ownerUserId)
          .get()
          .then((value) => value.docs.map((e) {
                return CloudNote(
                    documentId: e.id,
                    ownerUserId: e.data()[ownerUserIdField],
                    text: e.data()[textField]);
              }));
    } catch (e) {
      throw CloudNotGetAllNotesException();
    }
  }

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({textField: text});
    } catch (e) {
      throw CloudNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CloudNotDeleteNoteException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
