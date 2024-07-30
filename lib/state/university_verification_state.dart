import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gfbf/models/university_verification_request_model.dart';

part 'university_verification_state.freezed.dart';

@freezed
class UniversityVerificationState with _$UniversityVerificationState {
  const factory UniversityVerificationState.loading() = _Loading;
  const factory UniversityVerificationState.notSubmitted() = _NotSubmitted;
  const factory UniversityVerificationState.pending(
      UniversityVerificationRequestModel
          universityVerificationRequestModel) = _Pending;
  const factory UniversityVerificationState.rejected(
      UniversityVerificationRequestModel
          universityVerificationRequestModel) = _Rejected;
  const factory UniversityVerificationState.approved() = _Approved;
  const factory UniversityVerificationState.error(String message) = _Error;
}
