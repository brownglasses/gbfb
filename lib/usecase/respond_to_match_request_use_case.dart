import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다.

class RespondToMatchRequestUseCase {
  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;

  RespondToMatchRequestUseCase(this.firestore, this.functions);

  Future<void> execute(String matchId, bool isAccepted) async {
    try {
      Log.info("매칭 요청 응답 시작 - matchId: $matchId, isAccepted: $isAccepted");

      // 매칭 상태 업데이트
      await firestore.collection('matches').doc(matchId).update({
        'status': isAccepted ? 'accepted' : 'rejected',
      });

      Log.info("매칭 상태 업데이트 성공 - matchId: $matchId, isAccepted: $isAccepted");

      if (isAccepted) {
        await _handleMatchAccepted(matchId);
      }
    } on FirebaseException catch (e) {
      Log.error('Firestore 오류 발생: ${e.message}', e);
      throw AppException('매칭 요청 응답 처리 중 오류가 발생했습니다. 다시 시도해주세요.');
    } catch (e, stackTrace) {
      Log.error('매칭 요청 응답 처리 중 예상치 못한 오류 발생', e, stackTrace);
      throw AppException('예상치 못한 오류가 발생했습니다: $e');
    }
  }

  Future<void> _handleMatchAccepted(String matchId) async {
    try {
      Log.info("매칭 수락 처리 중 - matchId: $matchId");

      // 매칭 문서 가져오기
      final matchDoc = await firestore.collection('matches').doc(matchId).get();
      final fromUserId = matchDoc['fromUserId'];
      final toUserId = matchDoc['toUserId'];

      // Cloud Function 호출
      await functions.httpsCallable('sendKakaoIds').call({
        'fromUserId': fromUserId,
        'toUserId': toUserId,
      });

      Log.info("매칭 수락 처리 성공 및 Cloud Function 호출 완료 - matchId: $matchId");
    } on FirebaseFunctionsException catch (e) {
      Log.error('Firebase Functions 오류 발생: ${e.message}', e);
      throw AppException('Cloud Function 호출 중 오류가 발생했습니다. 다시 시도해주세요.');
    } on FirebaseException catch (e) {
      Log.error('Firestore 오류 발생: ${e.message}', e);
      throw AppException('Firestore 데이터 조회 중 오류가 발생했습니다.');
    } catch (e, stackTrace) {
      Log.error('매칭 수락 처리 중 예상치 못한 오류 발생', e, stackTrace);
      throw AppException('예상치 못한 오류가 발생했습니다: $e');
    }
  }
}
