import 'package:firebase_auth/firebase_auth.dart';

class VerifyPhoneNumberUseCase {
  final FirebaseAuth firebaseAuth;

  VerifyPhoneNumberUseCase(this.firebaseAuth);

  Future<void> execute({
    required String phoneNumber,
    required Function(String) codeSent,
    required Function(String) verificationFailed,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await firebaseAuth.signInWithCredential(credential);
          } catch (e) {
            verificationFailed(
                "Automatic verification failed: ${e.toString()}");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          verificationFailed(e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      verificationFailed("Phone number verification failed: ${e.toString()}");
    }
  }
}
