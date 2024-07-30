import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImageUseCase {
  final FirebaseStorage firebaseStorage;

  UploadImageUseCase(this.firebaseStorage);

  Future<String> execute(String uid, File file) async {
    final storageRef = firebaseStorage
        .ref()
        .child('verification_request_studentcard_img/$uid');
    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
