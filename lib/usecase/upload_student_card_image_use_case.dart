import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다.

class UploadStudentCardImageUseCase {
  final FirebaseStorage firebaseStorage;

  UploadStudentCardImageUseCase(this.firebaseStorage);

  Future<String> execute(String uid, File file) async {
    try {
      Log.info("이미지 업로드 시작 - UID: $uid, 파일 경로: ${file.path}");

      final storageRef = firebaseStorage
          .ref()
          .child('verification_request_studentcard_img/$uid');
      final uploadTask = storageRef.putFile(file);

      Log.info("이미지 업로드 중 - UID: $uid");

      final snapshot = await uploadTask.whenComplete(() => {});

      final downloadUrl = await snapshot.ref.getDownloadURL();

      Log.info("이미지 업로드 성공 - 다운로드 URL: $downloadUrl");

      return downloadUrl;
    } on FirebaseException catch (e) {
      Log.error("Firebase Storage 오류 발생 - 코드: ${e.code}, 메시지: ${e.message}");
      throw StorageException("Firebase Storage에 이미지 업로드 실패: ${e.message}");
    } on SocketException catch (e) {
      Log.error("네트워크 오류 발생 - 메시지: ${e.message}");
      throw NetworkException("인터넷 연결이 불안정합니다. 다시 시도해주세요.");
    } catch (e, stackTrace) {
      Log.error("이미지 업로드 중 예상치 못한 오류 발생", e, stackTrace);
      throw AppException("이미지 업로드 중 예상치 못한 오류가 발생했습니다: ${e.toString()}");
    }
  }
}
