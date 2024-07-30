import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfbf/models/profile_model.dart';

class GetMyProfileUseCase {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  GetMyProfileUseCase(this.firebaseAuth, this.firebaseFirestore);

  Future<ProfileModel?> execute() async {
    try {
      // 현재 로그인된 사용자 가져오기
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Firestore에서 프로필 문서 가져오기
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firebaseFirestore.collection('profiles').doc(user.uid).get();

      if (!documentSnapshot.exists) {
        throw Exception('Profile not found');
      }

      // 프로필 데이터를 ProfileModel로 변환
      Map<String, dynamic>? data = documentSnapshot.data();
      if (data == null) {
        return null;
      }

      return ProfileModel.fromFirestore(data);
    } catch (e) {
      debugPrint('Error getting profile: $e');
      rethrow;
    }
  }
}
