import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gfbf/models/profile_model.dart';

part 'profile_edit_state.freezed.dart';

@freezed
class ProfileEditState with _$ProfileEditState {
  const factory ProfileEditState.loading() = _Loading;
  const factory ProfileEditState.edit(ProfileModel profileMoodel) = _Edit;
  const factory ProfileEditState.error(String message) = _Error;
}
