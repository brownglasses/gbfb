import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfbf/models/user_model.dart';
import 'package:gfbf/services/user_service.dart';

///goRouter redirect 를 위한 notifier 이자 유저의 정보를 담는 notifer 입니다.
///처음 앱을 시작할 때 reditect 하기 위해 사용합니다.
///또한 유저의 정보를 얻어오는데 사용합니다.
///처음 시작 : toInitAppFetchUser
///유저의 정보 얻어오기 : getUser
///getUser 는 무조건 toInitAppFetchUser 이후 사용해야합니다.
class UserNotifier extends ChangeNotifier {
  UserModel? _userModel;
  final UserService _userService;
  final FirebaseAuth _firebaseAuth;
  bool _isInitialized = false;

  UserNotifier(this._userService, this._firebaseAuth);

  UserModel? get userModel => _userModel;
  bool get isInitialized => _isInitialized;

  Future<void> toInitAppFetchUser() async {
    if (_firebaseAuth.currentUser == null) {
      _isInitialized = true;
      notifyListeners();
      return;
    }

    _userModel = await _userService.getUser(_firebaseAuth.currentUser!.uid);
    debugPrint('UserInfomer getUser: $_userModel');
    _isInitialized = true;
    notifyListeners();
  }

  Future<UserModel?> getUserData() async {
    return _userModel;
  }

  void logout() {
    _userModel = null;
    _isInitialized = false;
    notifyListeners();
  }
}
