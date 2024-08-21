import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:gfbf/models/match_model.dart';
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다.

class FetchSentMatchesUseCase {
  final FirebaseFunctions functions;

  FetchSentMatchesUseCase(this.functions);

  Future<List<MatchModel>> execute() async {
    try {
      Log.info("보낸 매칭 목록 가져오기 시작");

      final result = await functions.httpsCallable('getSentMatches').call();
      Log.info(result.data.toString());
      debugPrint(result.data.toString());
      final sentMatches = (result.data as List)
          .map((item) => MatchModel.fromMap(Map<String, dynamic>.from(item)))
          .toList();

      Log.info("보낸 매칭 목록 가져오기 성공 - 결과: ${sentMatches.length}건");

      return sentMatches;
    } on FirebaseFunctionsException catch (e) {
      Log.error('Firebase Functions 오류 발생: ${e.message}', e);
      throw AppException('Firebase Functions 호출 중 오류가 발생했습니다. 다시 시도해주세요.');
    } catch (e, stackTrace) {
      Log.error('매칭 목록 가져오는 중 예상치 못한 오류 발생', e, stackTrace);
      throw AppException('예상치 못한 오류가 발생했습니다: $e');
    }
  }
}
