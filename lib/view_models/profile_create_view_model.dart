import 'dart:io';

import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/models/user_model.dart';
import 'package:gfbf/provider.dart';
import 'package:gfbf/state/profile_create_state.dart';
import 'package:gfbf/usecase/create_profile_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다
import 'package:gfbf/utils/log.dart'; // 로깅 유틸리티를 가져옵니다

class ProfileCreateViewModel extends StateNotifier<ProfileCreateState> {
  final CreateProfileUseCase createProfileUseCase;
  final UserModel? userModel;
  final Ref ref;

  ProfileCreateViewModel(this.createProfileUseCase, this.userModel, this.ref)
      : super(ProfileCreateState.create(userModel));

  Future<void> createProfile(ProfileModel profileModel, File? file) async {
    // 프로필 생성이 시작되었음을 알립니다.
    Log.info("프로필 생성 시작 - 사용자 UID: ${userModel?.uid}");

    try {
      // 프로필 생성 Use Case 실행
      await createProfileUseCase.execute(profileModel, file);

      // 프로필 상태 업데이트
      ref.read(profileNotifierProvider.notifier).setState(profileModel);
      state = ProfileCreateState.create(userModel);

      // 성공 로그는 UseCase에서 처리되었으므로 여기서는 UI 업데이트에 집중합니다.
    } on NetworkException catch (e) {
      // 네트워크 관련 오류 처리
      state = ProfileCreateState.error('인터넷 연결이 불안정합니다: ${e.message}');
    } on DatabaseException catch (e) {
      // 데이터베이스 관련 오류 처리
      state = ProfileCreateState.error('데이터베이스 오류: ${e.message}');
    } on FileNotFoundException catch (e) {
      // 파일 업로드 관련 오류 처리
      state = ProfileCreateState.error('파일 업로드 오류: ${e.message}');
    } on AuthorizationException catch (e) {
      // 인증 관련 오류 처리
      state = ProfileCreateState.error('인증 오류: ${e.message}');
    } on AppException catch (e) {
      // 기타 앱 관련 오류 처리
      state = ProfileCreateState.error('앱 오류: ${e.message}');
    } catch (e) {
      // 예상치 못한 일반 오류 처리
      state = ProfileCreateState.error('예상치 못한 오류: $e');
    }
  }
}
