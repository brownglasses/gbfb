import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다.

class SendMatchRequestUseCase {
  final FirebaseFirestore firestore;

  SendMatchRequestUseCase(this.firestore);

  Future<void> execute(String fromUserId, String toUserId) async {
    try {
      Log.info("매칭 요청 시작 - fromUserId: $fromUserId, toUserId: $toUserId");

      await firestore.collection('matches').add({
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      Log.info("매칭 요청 성공 - fromUserId: $fromUserId, toUserId: $toUserId");
    } on FirebaseException catch (e) {
      Log.error('Firebase 오류 발생: ${e.message}', e);
      throw AppException('Firebase에 접근하는 중 오류가 발생했습니다. 다시 시도해주세요.');
    } catch (e, stackTrace) {
      Log.error('매칭 요청 중 예상치 못한 오류 발생', e, stackTrace);
      throw AppException('예상치 못한 오류가 발생했습니다: $e');
    }
  }
}
