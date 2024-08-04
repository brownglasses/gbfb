import 'package:gfbf/services/user_service.dart';
import 'package:gfbf/models/university_verification_request_model.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다.

class GetUniversityVerificationRequestResultUseCase {
  final UserService userService;

  GetUniversityVerificationRequestResultUseCase(this.userService);

  Future<UniversityVerificationRequestModel?> execute(String uid) async {
    try {
      Log.info("대학교 인증 요청 조회 시작 - UID: $uid");

      // 대학 인증 요청 데이터 가져오기
      UniversityVerificationRequestModel? verificationRequest =
          await userService.getUniversityVerificationRequest(uid);

      if (verificationRequest == null) {
        Log.warning("대학교 인증 요청을 찾을 수 없습니다. - UID: $uid");
        throw DataNotFoundException('대학교 인증 요청을 찾을 수 없습니다 - UID: $uid');
      }

      Log.info(
          "대학교 인증 요청 조회 성공 - UID: $uid, 데이터: ${verificationRequest.toString()}");

      return verificationRequest;
    } on DataNotFoundException catch (e) {
      Log.error('데이터 조회 오류 발생 - UID: $uid, 오류: ${e.message}');
      return null; // Handle not found case gracefully
    } on NetworkException catch (e) {
      Log.error('네트워크 오류 발생 - UID: $uid, 오류: ${e.message}');
      return null; // Handle network issues gracefully
    } catch (e, stackTrace) {
      Log.error('대학교 인증 요청 조회 중 예상치 못한 오류 발생 - UID: $uid', e, stackTrace);
      throw AppException('예상치 못한 오류 발생 - UID: $uid, 오류: $e');
    }
  }
}
