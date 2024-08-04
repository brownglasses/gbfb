import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gfbf/models/university_verification_request_model.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  Future<void> createUniversityVerificationRequest(
      UniversityVerificationRequestModel
          universityVerificationRequestModel) async {
    await _firestore
        .collection('university_verification_requests')
        .doc(universityVerificationRequestModel.uid)
        .set(universityVerificationRequestModel.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final user = await _firestore.collection('users').doc(uid).get();
    if (user.exists) {
      return UserModel.fromMap(user.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<UniversityVerificationRequestModel?> getUniversityVerificationRequest(
      String uid) async {
    final universityVerificationRequest = await _firestore
        .collection('university_verification_requests')
        .doc(uid)
        .get();
    if (universityVerificationRequest.exists) {
      return UniversityVerificationRequestModel.fromMap(
          universityVerificationRequest.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
