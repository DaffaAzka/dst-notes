import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dstnotes/services/cloud/cloud_storage_constants.dart';

class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;

  CloudNote(
      {required this.documentId,
      required this.ownerUserId,
      required this.text});

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdField],
        text = snapshot.data()[textField] as String;
}
