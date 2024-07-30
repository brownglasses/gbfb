// ProfileCreateViewModel.dart
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/provider.dart';

import 'package:gfbf/usecase/edit_profile_use_case.dart';
import 'package:gfbf/usecase/get_my_profile_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditViewModel extends StateNotifier<ProfileModel?> {
  final EditProfileUseCase editProfileUseCase;
  final GetMyProfileUseCase getMyProfileUseCase;
  final Ref ref;
  ProfileEditViewModel(
      this.editProfileUseCase, this.getMyProfileUseCase, this.ref)
      : super(null);

  Future<void> editProfile(ProfileModel profileModel, String? filePath) async {
    try {
      editProfileUseCase.execute(profileModel, filePath);
      ref.read(profileNotifierProvider.notifier).setState(profileModel);
    } catch (e) {}
  }
}
