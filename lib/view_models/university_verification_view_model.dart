import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gfbf/models/university_verification_request_model.dart';
import 'package:gfbf/state/university_verification_state.dart';
import 'package:gfbf/usecase/get_university_verification_request_result_use_case.dart';
import 'package:gfbf/usecase/request_university_verification_use_case.dart';
import 'package:gfbf/usecase/upload_image_use_case.dart';
import 'package:gfbf/utils/constants/university_verification_status.dart';

import 'package:logging/logging.dart';

class UniversityVerificationViewModel
    extends StateNotifier<UniversityVerificationState> {
  final RequestUniversityVerificationUseCase requestUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final GetUniversityVerificationRequestResultUseCase getRequestResultUseCase;
  final Logger _logger = Logger('UniversityVerificationViewModel');

  UniversityVerificationViewModel(
    this.requestUseCase,
    this.uploadImageUseCase,
    this.getRequestResultUseCase,
  ) : super(const UniversityVerificationState.loading());

  Future<void> requestUniversityVerification(
      UniversityVerificationRequestModel requestModel) async {
    _logger.info(
        'Requesting university verification for user: ${requestModel.uid}');
    try {
      await requestUseCase.execute(requestModel);
      state = UniversityVerificationState.pending(requestModel);
      _logger.info(
          'University verification request submitted for user: ${requestModel.uid}');
    } catch (e) {
      _logger.severe(
          'Failed to submit university verification request for user: ${requestModel.uid}',
          e);
      state = UniversityVerificationState.error(e.toString());
    }
  }

  Future<String> uploadImage(String uid, File file) async {
    _logger.info('Uploading image for user: $uid');
    try {
      final downloadUrl = await uploadImageUseCase.execute(uid, file);
      _logger.info('Image uploaded successfully for user: $uid');
      return downloadUrl;
    } catch (e) {
      _logger.severe('Failed to upload image for user: $uid', e);
      rethrow;
    }
  }

  Future<void> getUniversityVerificationRequestResult(String? uid) async {
    if (uid == null) {
      _logger.warning(
          'User ID is null. Cannot fetch university verification request.');
      state = const UniversityVerificationState.error('User not found');
      return;
    }

    _logger.info('Fetching university verification request for user: $uid');
    try {
      final request = await getRequestResultUseCase.execute(uid);
      if (request != null) {
        if (request.universityVerificationStatus ==
            UniversityVerificationStatus.approved.name) {
          state = const UniversityVerificationState.approved();
          _logger
              .info('University verification request approved for user: $uid');
        } else if (request.universityVerificationStatus ==
            UniversityVerificationStatus.rejected.name) {
          state = UniversityVerificationState.rejected(request);
          _logger
              .info('University verification request rejected for user: $uid');
        } else {
          state = UniversityVerificationState.pending(request);
          _logger
              .info('University verification request pending for user: $uid');
        }
      } else {
        state = const UniversityVerificationState.notSubmitted();
        _logger.info('No university verification request found for user: $uid');
      }
    } catch (e) {
      _logger.severe(
          'Failed to fetch university verification request for user: $uid', e);
      state = UniversityVerificationState.error(e.toString());
    }
  }
}
