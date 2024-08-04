import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스 import

class EditProfileUseCase {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  EditProfileUseCase(
    this.firebaseAuth,
    this.firebaseFirestore,
    this.firebaseStorage,
  );

  Future<ProfileModel> execute(
      ProfileModel profileModel, String? filePath) async {
    // 프로필 수정 시작을 로깅합니다.
    Log.info("프로필 수정 시작");

    try {
      // 현재 로그인된 사용자 가져오기
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw AuthorizationException('로그인된 사용자가 없습니다');
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
          .update(profileModel.toMap());

      Log.info('프로필 업데이트 성공 - UID: ${user.uid}');

      return profileModel;
    } on FirebaseAuthException catch (e) {
      throw AuthorizationException('Firebase 인증 오류: ${e.message}');
    } on FirebaseException catch (e) {
      throw DatabaseException('Firestore 오류: ${e.message}');
    } on SocketException {
      throw NetworkException('인터넷 연결이 없습니다');
    } catch (e) {
      throw AppException('예상치 못한 오류: $e');
    }
  }

  Future<String> _uploadProfilePhoto(String filePath, String uid) async {
    File file = File(filePath);
    try {
      TaskSnapshot snapshot =
          await firebaseStorage.ref('profile_photos/$uid').putFile(file);

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw FileNotFoundException('파일 업로드 실패: ${e.message}');
    } on SocketException {
      throw NetworkException('인터넷 연결이 없습니다');
    } catch (e) {
      throw AppException('파일 업로드 중 예상치 못한 오류: $e');
    }
  }
}
