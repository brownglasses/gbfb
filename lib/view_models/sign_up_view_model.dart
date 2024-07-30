import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gfbf/models/user_model.dart';
import 'package:gfbf/usecase/sign_in_with_phone_number_use_case.dart';
import 'package:gfbf/usecase/verify_phone_number_use_case.dart';

class SignUpViewModel extends StateNotifier<UserModel?> {
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;
  final SignInWithPhoneNumberUseCase signInWithPhoneNumberUseCase;

  SignUpViewModel(
      this.verifyPhoneNumberUseCase, this.signInWithPhoneNumberUseCase)
      : super(null);

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) codeSent,
    required Function(String) verificationFailed,
  }) async {
    await verifyPhoneNumberUseCase.execute(
      phoneNumber: phoneNumber,
      codeSent: codeSent,
      verificationFailed: verificationFailed,
    );
  }

  Future<void> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
    required String age,
    required String gender,
  }) async {
    try {
      final user = await signInWithPhoneNumberUseCase.execute(
        verificationId: verificationId,
        smsCode: smsCode,
        age: age,
        gender: gender,
      );
      state = user;
    } catch (e) {
      state = null;
      // 예외 처리 로직 추가
    }
  }
}
