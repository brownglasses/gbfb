import 'package:gfbf/models/user_model.dart';
import 'package:gfbf/notifier/user_notifier.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다.

class GetMyUserDataUseCase {
  final UserNotifier userNotifier;

  GetMyUserDataUseCase(this.userNotifier);

  Future<UserModel?> execute() async {
    try {
      Log.info("사용자 데이터 조회 시작");

      // 사용자 데이터 가져오기
      UserModel? userData = await userNotifier.getUserData();

      if (userData == null) {
        Log.error('사용자 데이터를 찾을 수 없습니다.');
        throw DataNotFoundException('사용자 데이터를 찾을 수 없습니다');
      }

      Log.info('사용자 데이터 조회 성공: ${userData.uid}');
      return userData;
    } on DataNotFoundException catch (e) {
      Log.error('데이터 조회 오류: ${e.message}');
      return null; // Handle not found case gracefully
    } on NetworkException catch (e) {
      Log.error('네트워크 오류 발생: ${e.message}');
      return null; // Handle network issues gracefully
    } catch (e, stackTrace) {
      Log.error('사용자 데이터 조회 중 예상치 못한 오류 발생', e, stackTrace);
      throw AppException('예상치 못한 오류: $e');
    }
  }
}
