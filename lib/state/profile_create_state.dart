import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gfbf/models/user_model.dart';

part 'profile_create_state.freezed.dart';

@freezed
class ProfileCreateState with _$ProfileCreateState {
  const factory ProfileCreateState.create(UserModel? userModel) = _Create;
  const factory ProfileCreateState.error(String message) = _Error;
}
