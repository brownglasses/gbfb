import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gfbf/models/university_verification_request_model.dart';

import 'package:logging/logging.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('UserService');

  Future<void> createUser(UserModel user) async {
    _logger.info('Creating user: ${user.uid}');

    await _firestore.collection('users').doc(user.uid).set(user.toMap());
    _logger.info('User created: ${user.uid}');
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    _logger.info('Updating user: $uid');

    await _firestore.collection('users').doc(uid).update(data);
    _logger.info('User updated: $uid');
  }

  Future<void> createUniversityVerificationRequest(
      UniversityVerificationRequestModel
          universityVerificationRequestModel) async {
    _logger.info(
        'Creating university verification request for user: ${universityVerificationRequestModel.uid}');

    await _firestore
        .collection('university_verification_requests')
        .doc(universityVerificationRequestModel.uid)
        .set(universityVerificationRequestModel.toMap());
    _logger.info(
        'University verification request created for user: ${universityVerificationRequestModel.uid}');
  }

  Future<UserModel?> getUser(String uid) async {
    _logger.info('Fetching user: $uid');

    final user = await _firestore.collection('users').doc(uid).get();
    if (user.exists) {
      _logger.info('User fetched: $uid');
      return UserModel.fromMap(user.data() as Map<String, dynamic>);
    } else {
      _logger.warning('User not found: $uid');
      return null;
    }
  }

  Future<UniversityVerificationRequestModel?> getUniversityVerificationRequest(
      String uid) async {
    _logger.info('Fetching university verification request for user: $uid');

    final universityVerificationRequest = await _firestore
        .collection('university_verification_requests')
        .doc(uid)
        .get();
    if (universityVerificationRequest.exists) {
      _logger.info('University verification request fetched for user: $uid');
      return UniversityVerificationRequestModel.fromMap(
          universityVerificationRequest.data() as Map<String, dynamic>);
    } else {
      _logger
          .warning('University verification request not found for user: $uid');
      return null;
    }
  }
}
