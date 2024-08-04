import 'package:gfbf/state/profile_view_state.dart';
import 'package:gfbf/usecase/get_my_profile_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gfbf/utils/exception/app_exception.dart'; // Import custom exception classes
import 'package:gfbf/utils/log.dart'; // Import logging utility

class ProfileViewViewModel extends StateNotifier<ProfileViewState> {
  final GetMyProfileUseCase getMyProfileUseCase;

  ProfileViewViewModel(
    this.getMyProfileUseCase,
  ) : super(
          const ProfileViewState.loading(),
        );

  Future<void> getMyProfile() async {
    Log.info("내 프로필 조회 시도 중");

    // Set state to loading before attempting to fetch the profile
    state = const ProfileViewState.loading();

    try {
      final profile = await getMyProfileUseCase.execute();

      if (profile == null) {
        state = const ProfileViewState.error('프로필을 찾을 수 없습니다.');
        Log.warning("프로필을 찾을 수 없습니다.");
      } else {
        state = ProfileViewState.loaded(profile);
        Log.info("프로필 로드 성공 - 사용자 UID: ${profile.uid}");
      }
    } on NetworkException catch (e) {
      _handleError('인터넷 연결이 불안정합니다: ${e.message}');
    } on DatabaseException catch (e) {
      _handleError('데이터베이스 오류: ${e.message}');
    } on AuthorizationException catch (e) {
      _handleError('인증 오류: ${e.message}');
    } on AppException catch (e) {
      _handleError('앱 오류: ${e.message}');
    } catch (e) {
      _handleError('예상치 못한 오류: $e');
    }
  }

  void _handleError(String message) {
    // Log the error
    Log.error(message);

    // Set the state to error with the provided message
    state = ProfileViewState.error(message);
  }
}
