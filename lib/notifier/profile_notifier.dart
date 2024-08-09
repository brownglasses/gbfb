import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/usecase/create_profile_use_case.dart';
import 'package:gfbf/usecase/get_my_profile_use_case.dart';
import 'package:gfbf/utils/exception/app_exception.dart'; // Custom exception classes
import 'package:gfbf/utils/log.dart'; // Logging utility

///프로필 데이터를 관리하는 StateNotifier
class ProfileNotifier extends StateNotifier<ProfileModel?> {
  final GetMyProfileUseCase getMyProfileUseCase;
  final CreateProfileUseCase createProfileUseCase;

  ProfileNotifier(this.getMyProfileUseCase, this.createProfileUseCase)
      : super(null);

  Future<ProfileModel?> fetchProfileData() async {
    Log.info("프로필 데이터 가져오기 시작");

    try {
      final profile = await getMyProfileUseCase.execute();
      state = profile;
      if (profile != null) {
        Log.info("프로필 데이터 가져오기 성공 - 사용자 UID: ${profile.uid}");
      } else {
        Log.warning("프로필 데이터를 찾을 수 없습니다.");
      }
      return state;
    } on NetworkException catch (e) {
      Log.error("네트워크 오류 발생 - 메시지: ${e.message}");
    } on AuthorizationException catch (e) {
      Log.error("인증 오류 발생 - 메시지: ${e.message}");
    } on DatabaseException catch (e) {
      Log.error("데이터베이스 오류 발생 - 메시지: ${e.message}");
    } on AppException catch (e) {
      Log.error("앱 오류 발생 - 메시지: ${e.message}");
    } catch (e, stackTrace) {
      Log.error("프로필 데이터 가져오기 중 예상치 못한 오류 발생", e, stackTrace);
    }

    return null;
  }

  Future<void> createProfile(ProfileModel profileModel, File? file) async {
    Log.info("프로필 생성 시작 - 사용자 UID: ${profileModel.uid}");

    try {
      await createProfileUseCase.execute(profileModel, file);
      state = profileModel;
      Log.info("프로필 생성 성공 - 사용자 UID: ${profileModel.uid}");
    } on NetworkException catch (e) {
      Log.error("네트워크 오류 발생 - 메시지: ${e.message}");
    } on AuthorizationException catch (e) {
      Log.error("인증 오류 발생 - 메시지: ${e.message}");
    } on DatabaseException catch (e) {
      Log.error("데이터베이스 오류 발생 - 메시지: ${e.message}");
    } on FileNotFoundException catch (e) {
      Log.error("파일 업로드 오류 발생 - 메시지: ${e.message}");
    } on AppException catch (e) {
      Log.error("앱 오류 발생 - 메시지: ${e.message}");
    } catch (e, stackTrace) {
      Log.error("프로필 생성 중 예상치 못한 오류 발생", e, stackTrace);
    }
  }

  void setState(ProfileModel? profileModel) {
    Log.info("프로필 상태 설정 - 사용자 UID: ${profileModel?.uid}");
    state = profileModel;
  }
}
