import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/usecase/create_profile_use_case.dart';
import 'package:gfbf/usecase/get_my_profile_use_case.dart';

// 프로필 데이터를 관리하는 StateNotifier
class ProfileNotifier extends StateNotifier<ProfileModel?> {
  final GetMyProfileUseCase getMyProfileUseCase;
  final CreateProfileUseCase createProfileUseCase;

  ProfileNotifier(this.getMyProfileUseCase, this.createProfileUseCase)
      : super(null);

  Future<ProfileModel?> fetchProfileData() async {
    try {
      final profile = await getMyProfileUseCase.execute();
      state = profile;
      return state;
    } catch (error) {
      print('Error fetching profile data: $error');
    }
    return null;
  }

  Future<void> createProfile(ProfileModel profileModel, File? file) async {
    try {
      await createProfileUseCase.execute(profileModel, file);
      state = profileModel;
    } catch (error) {
      print('Error creating profile: $error');
    }
  }

  void setState(ProfileModel? profileModel) {
    state = profileModel;
  }
}
