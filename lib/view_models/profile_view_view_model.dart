import 'package:gfbf/state/profile_view_state.dart';

import 'package:gfbf/usecase/get_my_profile_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileViewViewModel extends StateNotifier<ProfileViewState> {
  final GetMyProfileUseCase getMyProfileUseCase;

  ProfileViewViewModel(
    this.getMyProfileUseCase,
  ) : super(
          const ProfileViewState.loading(),
        );

  Future<void> getMyProfile() async {
    try {
      final profile = await getMyProfileUseCase.execute();
      if (profile == null) {
        state = const ProfileViewState.error('Profile not found');
      } else {
        state = ProfileViewState.loaded(profile);
      }
    } catch (e) {
      state = ProfileViewState.error(e.toString());
    }
  }
}
