import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다.

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
        Log.error('로그인된 사용자가 없습니다.');
        throw AuthorizationException('로그인된 사용자가 없습니다');
      }

      Log.info('로그인된 사용자 UID: ${user.uid}');

      // Firestore에서 프로필 문서 가져오기
      Log.info('Firestore에서 프로필 문서 가져오기 - UID: ${user.uid}');
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firebaseFirestore.collection('profiles').doc(user.uid).get();

      if (!documentSnapshot.exists) {
        Log.error('프로필을 찾을 수 없습니다.');
        throw DatabaseException('프로필을 찾을 수 없습니다');
      }

      Log.debug('프로필 문서 데이터: ${documentSnapshot.data()}');

      // 프로필 데이터를 ProfileModel로 변환
      Map<String, dynamic>? data = documentSnapshot.data();
      if (data == null) {
        Log.error('프로필 데이터가 비어 있습니다.');
        throw AppException('프로필 데이터가 비어 있습니다');
      }

      Log.info('프로필 조회 성공 - UID: ${user.uid}');
      return ProfileModel.fromFirestore(data);
    } on FirebaseAuthException catch (e) {
      Log.error('Firebase 인증 오류 발생', e);
      throw AuthorizationException('Firebase 인증 오류: ${e.message}');
    } on FirebaseException catch (e) {
      Log.error('Firestore 오류 발생', e);
      throw DatabaseException('Firestore 오류: ${e.message}');
    } catch (e, stackTrace) {
      Log.error('프로필 조회 중 예상치 못한 오류 발생', e, stackTrace);
      throw AppException('예상치 못한 오류: $e');
    }
  }
}
