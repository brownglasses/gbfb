import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gfbf/models/user_model.dart';

import 'package:gfbf/services/user_service.dart';
import 'package:gfbf/notifier/user_notifier.dart';
import 'package:gfbf/utils/exception/custom_exception.dart';

class SignInWithPhoneNumberUseCase {
  final FirebaseAuth firebaseAuth;
  final FirebaseMessaging firebaseMessaging;
  final UserService userService;
  final UserNotifier userInfomer;
  SignInWithPhoneNumberUseCase(this.firebaseAuth, this.firebaseMessaging,
      this.userService, this.userInfomer);

  Future<UserModel?> execute({
    required String verificationId,
    required String smsCode,
    required String age,
    required String gender,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        String? fcmToken = await firebaseMessaging.getToken();

        UserModel user = UserModel(
          uid: firebaseUser.uid,
          phoneNumber: firebaseUser.phoneNumber!,
          age: age,
          gender: gender,
          fcmToken: fcmToken,
          verified: false,
          university: null,
          profile: false,
        );

        await userService.createUser(user);
        await userInfomer.toInitAppFetchUser();
        return user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_NO_USER',
          message: 'User not found after sign-in',
        );
      }
    } catch (e) {
      throw CustomException(
          message: "Sign-in with phone number failed: ${e.toString()}");
    }
  }
}
