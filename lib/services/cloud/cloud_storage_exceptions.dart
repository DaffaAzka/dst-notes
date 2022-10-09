class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CloudNotCreateNoteException implements CloudStorageExceptions {}

class CloudNotGetAllNotesException implements CloudStorageExceptions {}

class CloudNotUpdateNoteException implements CloudStorageExceptions {}

class CloudNotDeleteNoteException implements CloudStorageExceptions {}
