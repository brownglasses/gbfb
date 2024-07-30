import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/models/user_model.dart';
import 'package:gfbf/provider.dart';
import 'package:gfbf/state/profile_create_state.dart';
import 'package:gfbf/usecase/create_profile_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileCreateViewModel extends StateNotifier<ProfileCreateState> {
  final CreateProfileUseCase createProfileUseCase;
  final UserModel? userModel;
  final Ref ref;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  ProfileCreateViewModel(this.createProfileUseCase, this.userModel, this.ref)
      : super(ProfileCreateState.create(userModel)) {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        _connectivityResult = results.first;
        if (_connectivityResult == ConnectivityResult.none) {
          state = const ProfileCreateState.error('No internet connection');
        }
      }
    });
  }

  Future<void> createProfile(ProfileModel profileModel, File? file) async {
    if (_connectivityResult == ConnectivityResult.none) {
      state = const ProfileCreateState.error('No internet connection');
      return;
    }

    try {
      await createProfileUseCase.execute(profileModel, file);
      ref.read(profileNotifierProvider.notifier).setState(profileModel);
      state = ProfileCreateState.create(userModel);
      // Optionally, you can set state to success or show a success message
    } on SocketException catch (_) {
      state = const ProfileCreateState.error('No Internet connection');
    } on FirebaseException catch (e) {
      state = ProfileCreateState.error(e.code == 'unavailable'
          ? 'Network is unavailable'
          : 'Error creating profile: ${e.message}');
    } catch (e) {
      state = ProfileCreateState.error('Unexpected error: $e');
    }
  }
}
