import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gfbf/models/profile_model.dart';

import 'package:gfbf/models/user_model.dart';
import 'package:gfbf/notifier/profile_notifier.dart';
import 'package:gfbf/state/profile_create_state.dart';
import 'package:gfbf/state/profile_edit_state.dart';

import 'package:gfbf/state/profile_view_state.dart';
import 'package:gfbf/state/university_verification_state.dart';
import 'package:gfbf/usecase/create_profile_use_case.dart';
import 'package:gfbf/usecase/edit_profile_use_case.dart';
import 'package:gfbf/usecase/get_my_profile_use_case.dart';
import 'package:gfbf/usecase/get_my_user_data_use_case.dart';
import 'package:gfbf/usecase/get_university_verification_request_result_use_case.dart';
import 'package:gfbf/usecase/request_university_verification_use_case.dart';
import 'package:gfbf/usecase/sign_in_with_phone_number_use_case.dart';
import 'package:gfbf/usecase/upload_student_card_image_use_case.dart';
import 'package:gfbf/usecase/verify_phone_number_use_case.dart';
import 'package:gfbf/notifier/user_notifier.dart';
import 'package:gfbf/view_models/profile_create_view_model.dart';
import 'package:gfbf/view_models/profile_edit_view_model.dart';
import 'package:gfbf/view_models/profile_view_view_model.dart';
import 'package:gfbf/view_models/sign_up_view_model.dart';
import 'package:gfbf/view_models/university_verification_view_model.dart';
import '../services/user_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final userNotifierProvider = ChangeNotifierProvider<UserNotifier>((ref) {
  final userService = ref.watch(userServiceProvider);
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return UserNotifier(userService, firebaseAuth);
});

final verifyPhoneNumberUseCaseProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return VerifyPhoneNumberUseCase(firebaseAuth);
});

final signInWithPhoneNumberUseCaseProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firebaseMessaging = ref.watch(firebaseMessagingProvider);
  final userService = ref.watch(userServiceProvider);
  final userInfomer = ref.watch(userNotifierProvider);
  return SignInWithPhoneNumberUseCase(
      firebaseAuth, firebaseMessaging, userService, userInfomer);
});

final signUpViewModelProvider =
    StateNotifierProvider<SignUpViewModel, UserModel?>((ref) {
  final verifyPhoneNumberUseCase = ref.watch(verifyPhoneNumberUseCaseProvider);
  final signInWithPhoneNumberUseCase =
      ref.watch(signInWithPhoneNumberUseCaseProvider);
  return SignUpViewModel(
      verifyPhoneNumberUseCase, signInWithPhoneNumberUseCase);
});

final requestUniversityVerificationUseCaseProvider = Provider((ref) {
  final userService = ref.watch(userServiceProvider);
  return RequestUniversityVerificationUseCase(userService);
});

final uploadImageUseCaseProvider = Provider((ref) {
  final firebaseStorage = ref.watch(firebaseStorageProvider);
  return UploadStudentCardImageUseCase(firebaseStorage);
});

final getUniversityVerificationRequestResultUseCaseProvider = Provider((ref) {
  final userService = ref.watch(userServiceProvider);
  return GetUniversityVerificationRequestResultUseCase(userService);
});

final universityVerificationViewModelProvider = StateNotifierProvider<
    UniversityVerificationViewModel, UniversityVerificationState>((ref) {
  final requestUseCase =
      ref.watch(requestUniversityVerificationUseCaseProvider);
  final uploadImageUseCase = ref.watch(uploadImageUseCaseProvider);
  final getRequestResultUseCase =
      ref.watch(getUniversityVerificationRequestResultUseCaseProvider);
  return UniversityVerificationViewModel(
      requestUseCase, uploadImageUseCase, getRequestResultUseCase);
});

final createProfileUseCaseProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firebaseFirestore = ref.watch(firebaseFirestoreProvider);
  final firebaseStorage = ref.watch(firebaseStorageProvider);

  return CreateProfileUseCase(firebaseAuth, firebaseFirestore, firebaseStorage);
});

final profileCreateViewModelProvider =
    StateNotifierProvider<ProfileCreateViewModel, ProfileCreateState>((ref) {
  final createProfileUseCase = ref.watch(createProfileUseCaseProvider);

  final userModel = ref.watch(userNotifierProvider).userModel;

  return ProfileCreateViewModel(createProfileUseCase, userModel, ref);
});

final getMyProfileUseCaseProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firebaseFirestore = ref.watch(firebaseFirestoreProvider);
  return GetMyProfileUseCase(firebaseAuth, firebaseFirestore);
});

final profileViewViewModelProvider =
    StateNotifierProvider<ProfileViewViewModel, ProfileViewState>((ref) {
  final getMyProfileUseCase = ref.watch(getMyProfileUseCaseProvider);
  return ProfileViewViewModel(getMyProfileUseCase);
});

final editProfileUseCaseProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firebaseFirestore = ref.watch(firebaseFirestoreProvider);
  final firebaseStorage = ref.watch(firebaseStorageProvider);
  return EditProfileUseCase(firebaseAuth, firebaseFirestore, firebaseStorage);
});

final profileEditViewModelProvider =
    StateNotifierProvider<ProfileEditViewModel, ProfileEditState>((ref) {
  final editProfileUseCase = ref.watch(editProfileUseCaseProvider);

  return ProfileEditViewModel(editProfileUseCase, ref);
});

final getMyUserDataUseCaseProvider = Provider((ref) {
  UserNotifier userInfomer = ref.watch(userNotifierProvider);
  return GetMyUserDataUseCase(userInfomer);
});

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileModel?>((ref) {
  final getMyProfileUseCase = ref.watch(getMyProfileUseCaseProvider);
  final createProfileUseCase = ref.watch(createProfileUseCaseProvider);

  return ProfileNotifier(getMyProfileUseCase, createProfileUseCase);
});
