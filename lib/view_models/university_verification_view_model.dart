import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gfbf/models/university_verification_request_model.dart';
import 'package:gfbf/state/university_verification_state.dart';
import 'package:gfbf/usecase/get_university_verification_request_result_use_case.dart';
import 'package:gfbf/usecase/request_university_verification_use_case.dart';
import 'package:gfbf/usecase/upload_image_use_case.dart';
import 'package:gfbf/utils/constants/university_verification_status.dart';
import 'package:gfbf/utils/exception/app_exception.dart'; // 커스텀 예외 클래스를 가져옵니다
import 'package:gfbf/utils/log.dart'; // Log 클래스를 가져옵니다.

class UniversityVerificationViewModel
    extends StateNotifier<UniversityVerificationState> {
  final RequestUniversityVerificationUseCase requestUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final GetUniversityVerificationRequestResultUseCase getRequestResultUseCase;

  UniversityVerificationViewModel(
    this.requestUseCase,
    this.uploadImageUseCase,
    this.getRequestResultUseCase,
  ) : super(const UniversityVerificationState.loading());

  Future<void> requestUniversityVerification(
      UniversityVerificationRequestModel requestModel) async {
    Log.info('대학교 인증 요청 중 - 사용자 UID: ${requestModel.uid}');
    try {
      await requestUseCase.execute(requestModel);
      state = UniversityVerificationState.pending(requestModel);
      Log.info('대학교 인증 요청 성공 - 사용자 UID: ${requestModel.uid}');
    } on NetworkException catch (e) {
      _handleError('네트워크 오류: ${e.message}');
    } on AppException catch (e) {
      _handleError('앱 오류: ${e.message}');
    } catch (e) {
      _handleError('요청 중 예상치 못한 오류 발생: $e');
    }
  }

  Future<String> uploadImage(String uid, File file) async {
    Log.info('이미지 업로드 시도 중 - 사용자 UID: $uid');
    try {
      final downloadUrl = await uploadImageUseCase.execute(uid, file);
      Log.info('이미지 업로드 성공 - 사용자 UID: $uid');
      return downloadUrl;
    } on NetworkException catch (e) {
      _handleError('네트워크 오류: ${e.message}');
      rethrow; // Re-throwing to allow the caller to handle it
    } on FileNotFoundException catch (e) {
      _handleError('파일을 찾을 수 없음: ${e.message}');
      rethrow;
    } on AppException catch (e) {
      _handleError('앱 오류: ${e.message}');
      rethrow;
    } catch (e) {
      _handleError('이미지 업로드 중 예상치 못한 오류 발생: $e');
      rethrow;
    }
  }

  Future<void> getUniversityVerificationRequestResult(String? uid) async {
    if (uid == null) {
      Log.warning('유저 ID가 없습니다. 대학교 인증 요청을 가져올 수 없습니다.');
      state = const UniversityVerificationState.error('유저를 찾을 수 없습니다.');
      return;
    }

    Log.info('대학교 인증 요청 조회 중 - 사용자 UID: $uid');
    try {
      final request = await getRequestResultUseCase.execute(uid);
      if (request != null) {
        switch (request.universityVerificationStatus) {
          case 'approved':
            state = const UniversityVerificationState.approved();
            Log.info('대학교 인증 요청 승인됨 - 사용자 UID: $uid');
            break;
          case 'rejected':
            state = UniversityVerificationState.rejected(request);
            Log.info('대학교 인증 요청 거부됨 - 사용자 UID: $uid');
            break;
          default:
            state = UniversityVerificationState.pending(request);
            Log.info('대학교 인증 요청 대기 중 - 사용자 UID: $uid');
            break;
        }
      } else {
        state = const UniversityVerificationState.notSubmitted();
        Log.info('인증 요청이 없습니다 - 사용자 UID: $uid');
      }
    } on NetworkException catch (e) {
      _handleError('네트워크 오류: ${e.message}');
    } on DatabaseException catch (e) {
      _handleError('데이터베이스 오류: ${e.message}');
    } on AppException catch (e) {
      _handleError('앱 오류: ${e.message}');
    } catch (e) {
      _handleError('조회 중 예상치 못한 오류 발생: $e');
    }
  }

  void _handleError(String message) {
    Log.error(message);
    state = UniversityVerificationState.error(message);
  }
}
