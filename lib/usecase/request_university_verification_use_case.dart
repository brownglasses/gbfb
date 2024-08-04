import 'package:gfbf/models/university_verification_request_model.dart';
import 'package:gfbf/services/user_service.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다.

class RequestUniversityVerificationUseCase {
  final UserService userService;

  RequestUniversityVerificationUseCase(this.userService);

  Future<void> execute(UniversityVerificationRequestModel requestModel) async {
    try {
      Log.info("대학교 인증 요청 시작 - 요청 데이터: ${requestModel.toString()}");

      // 대학교 인증 요청 생성
      await userService.createUniversityVerificationRequest(requestModel);

      Log.info("대학교 인증 요청 성공 - 요청 데이터: ${requestModel.toString()}");
    } on NetworkException catch (e) {
      Log.error('네트워크 오류 발생: ${e.message}', e);
      throw NetworkException('네트워크 연결 오류가 발생했습니다. 다시 시도해주세요.');
    } on DatabaseException catch (e) {
      Log.error('데이터베이스 오류 발생: ${e.message}', e);
      throw DatabaseException('데이터베이스에 접근하는 중 오류가 발생했습니다.');
    } catch (e, stackTrace) {
      Log.error('대학교 인증 요청 중 예상치 못한 오류 발생', e, stackTrace);
      throw AppException('예상치 못한 오류가 발생했습니다: $e');
    }
  }
}
