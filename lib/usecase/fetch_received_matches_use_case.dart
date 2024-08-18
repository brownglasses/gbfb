import 'package:cloud_functions/cloud_functions.dart';
import 'package:gfbf/models/match_model.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다.

class FetchReceivedMatchesUseCase {
  final FirebaseFunctions functions;

  FetchReceivedMatchesUseCase(this.functions);

  Future<List<MatchModel>> execute() async {
    try {
      Log.info("펜딩된 매칭 목록 가져오기 시작");

      final result = await functions.httpsCallable('getReceivedMatches').call();
      final List<MatchModel> matches = MatchModel.fromList(result.data);

      Log.info("펜딩된 매칭 목록 가져오기 성공 - 결과: ${matches.length}건");

      return matches;
    } on FirebaseFunctionsException catch (e) {
      Log.error('Firebase Functions 오류 발생: ${e.message}', e);
      throw AppException('Firebase Functions 호출 중 오류가 발생했습니다. 다시 시도해주세요.');
    } catch (e, stackTrace) {
      Log.error('매칭 목록 가져오는 중 예상치 못한 오류 발생', e, stackTrace);
      throw AppException('예상치 못한 오류가 발생했습니다: $e');
    }
  }
}
