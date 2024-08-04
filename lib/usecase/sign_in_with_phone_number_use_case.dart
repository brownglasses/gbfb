import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gfbf/models/user_model.dart';
import 'package:gfbf/services/user_service.dart';
import 'package:gfbf/notifier/user_notifier.dart';
import 'package:gfbf/utils/exception/app_exception.dart'; // Use app_exception instead
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.

class SignInWithPhoneNumberUseCase {
  final FirebaseAuth firebaseAuth;
  final FirebaseMessaging firebaseMessaging;
  final UserService userService;
  final UserNotifier userInfomer;

  SignInWithPhoneNumberUseCase(
    this.firebaseAuth,
    this.firebaseMessaging,
    this.userService,
    this.userInfomer,
  );

  Future<UserModel?> execute({
    required String verificationId,
    required String smsCode,
    required String age,
    required String gender,
  }) async {
    try {
      Log.info(
          "전화번호 인증 시작 - Verification ID: $verificationId, SMS Code: $smsCode");

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        Log.info("Firebase 사용자 인증 성공 - UID: ${firebaseUser.uid}");

        String? fcmToken = await firebaseMessaging.getToken();
        Log.info("FCM 토큰 획득 - 토큰: $fcmToken");

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
        Log.info("사용자 데이터베이스에 사용자 생성 성공 - UID: ${user.uid}");

        await userInfomer.toInitAppFetchUser();
        Log.info("앱 초기화 후 사용자 정보 가져오기 성공 - UID: ${user.uid}");

        return user;
      } else {
        Log.error("Firebase 사용자 인증 실패 - 사용자 없음");
        throw AuthorizationException('사용자를 찾을 수 없습니다. - 로그인 실패');
      }
    } on FirebaseAuthException catch (e) {
      Log.error("Firebase 인증 오류 발생 - 코드: ${e.code}, 메시지: ${e.message}");
      throw AuthorizationException("Firebase 인증 실패: ${e.message}");
    } on NetworkException catch (e) {
      Log.error("네트워크 오류 발생: ${e.message}");
      throw NetworkException("네트워크 연결에 문제가 발생했습니다. 다시 시도해 주세요.");
    } catch (e, stackTrace) {
      Log.error("전화번호 인증 중 예상치 못한 오류 발생", e, stackTrace);
      throw AppException(
        "전화번호 인증 중 예상치 못한 오류가 발생했습니다: ${e.toString()}",
      );
    }
  }
}
