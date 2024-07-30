import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gfbf/models/profile_model.dart';

class EditProfileUseCase {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  EditProfileUseCase(
      this.firebaseAuth, this.firebaseFirestore, this.firebaseStorage);

  Future<ProfileModel> execute(
      ProfileModel profileModel, String? filePath) async {
    try {
      // 현재 로그인된 사용자 가져오기
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // 프로필 모델에 UID 설정
      profileModel = profileModel.copyWith(uid: user.uid);

      // 프로필 사진 업로드 (있을 경우)
      String? photoUrl;
      if (filePath != null) {
        photoUrl = await _uploadProfilePhoto(filePath, user.uid);
        profileModel = profileModel.copyWith(photoUrl: photoUrl);
      }

      // Firestore에 프로필 업데이트

      await firebaseFirestore
          .collection('profiles')
          .doc(user.uid)
          .set(profileModel.toMap());

      return profileModel;
    } catch (e) {
      debugPrint('Error editing profile: $e');
      rethrow;
    }
  }

  Future<String> _uploadProfilePhoto(String filePath, String uid) async {
    File file = File(filePath);
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
