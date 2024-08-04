import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gfbf/models/user_model.dart';
import 'package:gfbf/usecase/sign_in_with_phone_number_use_case.dart';
import 'package:gfbf/usecase/verify_phone_number_use_case.dart';
import 'package:gfbf/utils/exception/app_exception.dart'; // Import custom exception classes
import 'package:gfbf/utils/log.dart'; // Import logging utility

class SignUpViewModel extends StateNotifier<UserModel?> {
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;
  final SignInWithPhoneNumberUseCase signInWithPhoneNumberUseCase;

  SignUpViewModel(
    this.verifyPhoneNumberUseCase,
    this.signInWithPhoneNumberUseCase,
  ) : super(null);

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) codeSent,
    required Function(String) verificationFailed,
  }) async {
    Log.info("전화번호 인증 시작 - 전화번호: $phoneNumber");

    try {
      await verifyPhoneNumberUseCase.execute(
        phoneNumber: phoneNumber,
        codeSent: codeSent,
        verificationFailed: verificationFailed,
      );
    } on NetworkException catch (e) {
      Log.error("네트워크 오류 발생 - 메시지: ${e.message}");
      verificationFailed('인터넷 연결이 불안정합니다: ${e.message}');
    } on AppException catch (e) {
      Log.error("앱 오류 발생 - 메시지: ${e.message}");
      verificationFailed('앱 오류: ${e.message}');
    } catch (e, stackTrace) {
      Log.error("전화번호 인증 중 예상치 못한 오류 발생", e, stackTrace);
      verificationFailed('예상치 못한 오류: $e');
    }
  }

  Future<void> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
    required String age,
    required String gender,
  }) async {
    Log.info("전화번호로 로그인 시도 - Verification ID: $verificationId");

    try {
      final user = await signInWithPhoneNumberUseCase.execute(
        verificationId: verificationId,
        smsCode: smsCode,
        age: age,
        gender: gender,
      );
      state = user;
      Log.info("로그인 성공 - 사용자 UID: ${user?.uid}");
    } on NetworkException catch (e) {
      Log.error("네트워크 오류 발생 - 메시지: ${e.message}");
      state = null;
    } on AuthorizationException catch (e) {
      Log.error("인증 오류 발생 - 메시지: ${e.message}");
      state = null;
    } on AppException catch (e) {
      Log.error("앱 오류 발생 - 메시지: ${e.message}");
      state = null;
    } catch (e, stackTrace) {
      Log.error("로그인 중 예상치 못한 오류 발생", e, stackTrace);
      state = null;
    }
  }
}
