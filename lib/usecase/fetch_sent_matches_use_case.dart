import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gfbf/models/match_model.dart';
import 'package:gfbf/utils/exception/app_exception.dart';
import 'package:gfbf/utils/log.dart';

class FetchSentMatchesUseCase {
  final FirebaseFirestore firebaseFirestore;

  FetchSentMatchesUseCase(this.firebaseFirestore);

  Future<List<MatchModel>> execute(String userId) async {
    try {
      Log.info("펜딩된 매칭 목록 가져오기 시작");

      final result = await firebaseFirestore
          .collection('matches')
          .where('status', isEqualTo: 'pending')
          .where('fromUserId', isEqualTo: userId)
          .get();

      Log.info(result.docs.toString());

      final sentMatches =
          result.docs.map((item) => MatchModel.fromMap(item.data())).toList();

      Log.info("펜딩된 매칭 목록 가져오기 성공 - 결과: ${sentMatches.length}건");

      return sentMatches;
    } on FirebaseException catch (e) {
      Log.error('Firebase 데이터 조회 중오류 발생: ${e.message}', e);
      throw AppException('Firebase 데이터 조회 중 오류가 발생했습니다. 다시 시도해주세요.');
    } catch (e, stackTrace) {
      Log.error('매칭 목록 가져오는 중 예상치 못한 오류 발생', e, stackTrace);
      throw AppException('예상치 못한 오류가 발생했습니다: $e');
    }
  }
}
