import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gfbf/models/profile_model.dart';

class CreateProfileUseCase {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  CreateProfileUseCase(
      this.firebaseAuth, this.firebaseFirestore, this.firebaseStorage);

  Future<void> execute(ProfileModel profileModel, File? file) async {
    try {
      // 현재 로그인된 사용자 가져오기
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // 프로필 모델에 UID 설정
      profileModel = profileModel.copyWith(uid: user.uid);

      // 프로필 사진 업로드
      String photoUrl = '';
      if (file != null) {
        photoUrl = await _uploadProfilePhoto(file, user.uid);
        profileModel = profileModel.copyWith(photoUrl: photoUrl);
      }

      // Firestore에 프로필 저장
      await firebaseFirestore
          .collection('profiles')
          .doc(user.uid)
          .set(profileModel.toMap());
    } catch (e) {
      debugPrint('Error creating profile: $e');
      rethrow;
    }
  }

  Future<String> _uploadProfilePhoto(File file, String uid) async {
    try {
      // Firebase Storage에 파일 업로드
      TaskSnapshot snapshot =
          await firebaseStorage.ref('profile_photos/$uid').putFile(file);

      // 업로드된 파일의 다운로드 URL 가져오기
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading profile photo: $e');
      rethrow;
    }
  }
}
