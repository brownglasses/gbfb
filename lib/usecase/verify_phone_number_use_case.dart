import 'package:firebase_auth/firebase_auth.dart';
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다
import 'package:gfbf/utils/log.dart'; // 로깅 유틸리티를 가져옵니다

class VerifyPhoneNumberUseCase {
  final FirebaseAuth firebaseAuth;

  VerifyPhoneNumberUseCase(this.firebaseAuth);

  Future<void> execute({
    required String phoneNumber,
    required Function(String) codeSent,
    required Function(String) verificationFailed,
  }) async {
    Log.info("전화번호 인증 시작 - 전화번호: $phoneNumber");

    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _handleVerificationCompleted,
        verificationFailed: (e) =>
            _handleVerificationFailed(e, verificationFailed),
        codeSent: (verificationId, resendToken) =>
            _handleCodeSent(verificationId, codeSent),
        codeAutoRetrievalTimeout: _handleAutoRetrievalTimeout,
      );
    } catch (e, stackTrace) {
      Log.error("전화번호 인증 중 예상치 못한 오류 발생", e, stackTrace);
      verificationFailed("전화번호 인증 중 예상치 못한 오류 발생: ${e.toString()}");
    }
  }

  Future<void> _handleVerificationCompleted(
      PhoneAuthCredential credential) async {
    try {
      Log.info("자동 인증 완료.");
      await firebaseAuth.signInWithCredential(credential);
      Log.info("자동 인증으로 사용자 로그인 성공.");
    } on FirebaseAuthException catch (e) {
      Log.error("자동 인증 로그인 실패 - 코드: ${e.code}, 메시지: ${e.message}");
      throw AuthorizationException("자동 인증 로그인 실패: ${e.message ?? "알 수 없는 오류"}");
    } catch (e) {
      Log.error("자동 인증 중 예상치 못한 오류 발생", e);
      throw AppException("자동 인증 중 예상치 못한 오류 발생: ${e.toString()}");
    }
  }

  void _handleVerificationFailed(
      FirebaseAuthException e, Function(String) verificationFailed) {
    Log.error("전화번호 인증 실패 - 코드: ${e.code}, 메시지: ${e.message}");
    verificationFailed(e.message ?? "인증 실패");
  }

  void _handleCodeSent(String verificationId, Function(String) codeSent) {
    Log.info("인증 코드 전송 성공 - 인증 ID: $verificationId");
    codeSent(verificationId);
  }

  void _handleAutoRetrievalTimeout(String verificationId) {
    Log.warning("자동 회수 시간 초과 - 인증 ID: $verificationId");
  }
}
