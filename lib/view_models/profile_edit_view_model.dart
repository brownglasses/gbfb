import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/provider.dart';
import 'package:gfbf/state/profile_edit_state.dart';
import 'package:gfbf/usecase/edit_profile_use_case.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다
import 'package:gfbf/utils/log.dart'; // 로깅 유틸리티를 가져옵니다

class ProfileEditViewModel extends StateNotifier<ProfileEditState> {
  final EditProfileUseCase editProfileUseCase;

  final Ref ref;

  ProfileEditViewModel(this.editProfileUseCase, this.ref)
      : super(const ProfileEditState.loading());

  Future<void> editProfile(ProfileModel profileModel, String? filePath) async {
    Log.info("프로필 수정 시도 중 - 사용자 UID: ${profileModel.uid}");

    // Set state to loading before starting the edit operation
    state = const ProfileEditState.loading();

    try {
      // Execute profile edit use case
      final updatedProfile =
          await editProfileUseCase.execute(profileModel, filePath);

      // Update the profile state with the edited profile
      ref.read(profileNotifierProvider.notifier).setState(updatedProfile);
      state = ProfileEditState.edit(updatedProfile);

      Log.info("프로필 수정 성공 - 사용자 UID: ${updatedProfile.uid}");
    } on NetworkException catch (e) {
      _handleError('인터넷 연결이 불안정합니다: ${e.message}');
    } on DatabaseException catch (e) {
      _handleError('데이터베이스 오류: ${e.message}');
    } on FileNotFoundException catch (e) {
      _handleError('파일 업로드 오류: ${e.message}');
    } on AuthorizationException catch (e) {
      _handleError('인증 오류: ${e.message}');
    } on AppException catch (e) {
      _handleError('앱 오류: ${e.message}');
    } catch (e) {
      _handleError('예상치 못한 오류: $e');
    }
  }

  void _handleError(String message) {
    // Log the error once here
    Log.error(message);

    // Set the state to error with the provided message
    state = ProfileEditState.error(message);
  }
}
