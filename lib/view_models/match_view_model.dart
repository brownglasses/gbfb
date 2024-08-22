import 'package:gfbf/models/match_model.dart';
import 'package:gfbf/provider.dart';
import 'package:gfbf/state/match_list_state.dart';
import 'package:gfbf/usecase/fetch_received_matches_use_case.dart';
import 'package:gfbf/usecase/fetch_received_matches_use_case.dart';
import 'package:gfbf/usecase/fetch_sent_matches_use_case.dart';
import 'package:gfbf/usecase/fetch_sent_matches_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다
import 'package:gfbf/utils/log.dart'; // 로깅 유틸리티를 가져옵니다

class MatchListViewModel extends StateNotifier<MatchListState> {
  final FetchReceivedMatchesUseCase fetchReceivedMatchesUseCase;
  final FetchSentMatchesUseCase fetchSentMatchesUseCase;
  final Ref ref;

  MatchListViewModel(
      this.fetchReceivedMatchesUseCase, this.fetchSentMatchesUseCase, this.ref)
      : super(const MatchListState.initial());

  Future<void> fetchMatches() async {
    Log.info("매칭 목록 가져오기 시작");

    try {
      var user = ref.read(userNotifierProvider).userModel;
      if (user == null) {
        state = const MatchListState.error('로그인이 필요합니다');
        return;
      }
      // 매칭 목록 Use Case 실행
      final receivedMatches =
          await fetchReceivedMatchesUseCase.execute(user.uid);
      final sentMatches = await fetchSentMatchesUseCase.execute(user.uid);
      // 상태 업데이트
      ref.read(receivedMatchListProvider.notifier).state = receivedMatches;
      ref.read(sentMatchListProvider.notifier).state = sentMatches;
      state = MatchListState.success(receivedMatches, sentMatches);

      Log.info(
          "매칭 목록 가져오기 성공 - 받은 매칭: ${receivedMatches.length}건, 보낸 매칭: ${sentMatches.length}건");
    } on NetworkException catch (e) {
      // 네트워크 관련 오류 처리
      state = MatchListState.error('인터넷 연결이 불안정합니다: ${e.message}');
      Log.error('네트워크 오류 발생: ${e.message}', e);
    } on DatabaseException catch (e) {
      // 데이터베이스 관련 오류 처리
      state = MatchListState.error('데이터베이스 오류: ${e.message}');
      Log.error('데이터베이스 오류 발생: ${e.message}', e);
    } on AppException catch (e) {
      // 기타 앱 관련 오류 처리
      state = MatchListState.error('앱 오류: ${e.message}');
      Log.error('앱 오류 발생: ${e.message}', e);
    } catch (e) {
      // 예상치 못한 일반 오류 처리
      state = MatchListState.error('예상치 못한 오류: $e');
      Log.error('예상치 못한 오류 발생: $e', e);
    }
  }
}

/// 매칭 목록 상태를 저장하고 관리하는 Provider입니다.
final matchListNotifierProvider =
    StateNotifierProvider<MatchListViewModel, MatchListState>(
  (ref) => MatchListViewModel(
    ref.read(fetchReceivedMatchesUseCaseProvider),
    ref.read(fetchSentMatchesUseCaseProvider),
    ref,
  ),
);

/// 매칭 목록을 임시적으로 저장하는 Provider입니다.
final receivedMatchListProvider = StateProvider<List<MatchModel>>((ref) => []);

final sentMatchListProvider = StateProvider<List<MatchModel>>((ref) => []);
