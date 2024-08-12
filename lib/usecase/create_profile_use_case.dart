import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart';

class CreateProfileUseCase {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  CreateProfileUseCase(
    this.firebaseAuth,
    this.firebaseFirestore,
    this.firebaseStorage,
  );

  Future<void> execute(ProfileModel profileModel, File? file) async {
    try {
      Log.info("프로필 생성 UseCase 실행 시작");

      // 현재 로그인된 사용자 가져오기
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw AuthorizationException('로그인된 사용자가 없습니다.');
      }

      Log.info('로그인된 사용자 UID: ${user.uid}');
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
      Log.info('프로필 저장 성공 - UID: ${user.uid}');
    } on FirebaseAuthException catch (e) {
      throw AuthorizationException('Firebase 인증 오류: ${e.message}');
    } on FirebaseException catch (e) {
      throw DatabaseException('Firestore 오류: ${e.message}');
    } on SocketException {
      throw NetworkException('인터넷 연결이 불안정합니다.');
    } catch (e) {
      throw AppException('프로필 생성 중 예상치 못한 오류 발생: $e');
    }
  }

  Future<String> _uploadProfilePhoto(File file, String uid) async {
    try {
      Log.info('Firebase Storage에 파일 업로드 시작: profile_photos/$uid');
      TaskSnapshot snapshot =
          await firebaseStorage.ref('profile_photos/$uid').putFile(file);

      String downloadUrl = await snapshot.ref.getDownloadURL();
      Log.info('파일 업로드 성공, 다운로드 URL: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw FileNotFoundException('파일 업로드 실패: ${e.message}');
    } on SocketException {
      throw NetworkException('인터넷 연결이 불안정합니다.');
    } catch (e) {
      throw AppException('파일 업로드 중 예상치 못한 오류 발생: $e');
    }
  }
}
