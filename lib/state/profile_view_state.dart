import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gfbf/models/profile_model.dart';

part 'profile_view_state.freezed.dart';

@freezed
class ProfileViewState with _$ProfileViewState {
  const factory ProfileViewState.loading() = _Loading;
  const factory ProfileViewState.loaded(ProfileModel profileMoodel) = _Loaded;
  const factory ProfileViewState.error(String message) = _Error;
}
