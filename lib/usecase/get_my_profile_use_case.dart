import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/utils/log.dart'; // Import logging utility
import 'package:gfbf/utils/exception/app_exception.dart'; // Import custom exception classes

class GetMyProfileUseCase {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  GetMyProfileUseCase(this.firebaseAuth, this.firebaseFirestore);

  Future<ProfileModel?> execute() async {
    try {
      Log.info("프로필 조회 시작");

      // 현재 로그인된 사용자 가져오기
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw AuthorizationException('로그인된 사용자가 없습니다.');
      }

      // Firestore에서 프로필 문서 가져오기
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firebaseFirestore.collection('profiles').doc(user.uid).get();

      if (!documentSnapshot.exists) {
        throw DatabaseException('프로필을 찾을 수 없습니다.');
      }

      // 프로필 데이터를 ProfileModel로 변환
      Map<String, dynamic>? data = documentSnapshot.data();
      if (data == null) {
        throw AppException('프로필 데이터가 비어 있습니다.');
      }

      Log.info('프로필 조회 성공 - UID: ${user.uid}');
      return ProfileModel.fromFirestore(data);
    } on FirebaseAuthException catch (e) {
      throw AuthorizationException('Firebase 인증 오류: ${e.message}');
    } on FirebaseException catch (e) {
      throw DatabaseException('Firestore 오류: ${e.message}');
    } catch (e) {
      throw AppException('프로필 조회 중 예상치 못한 오류 발생: $e');
    }
  }
}
