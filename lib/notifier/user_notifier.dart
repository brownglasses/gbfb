import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfbf/models/user_model.dart';
import 'package:gfbf/services/user_service.dart';
import 'package:gfbf/utils/log.dart'; // Import the custom logging utility
import 'package:gfbf/utils/exception/app_exception.dart'; // Import custom exceptions

/// goRouter redirect 를 위한 notifier 이자 유저의 정보를 담는 notifier 입니다.
/// 처음 앱을 시작할 때 redirect 하기 위해 사용합니다.
/// 또한 유저의 정보를 얻어오는데 사용합니다.
/// 처음 시작 : toInitAppFetchUser
/// 유저의 정보 얻어오기 : getUser
/// getUser 는 무조건 toInitAppFetchUser 이후 사용해야합니다.
class UserNotifier extends ChangeNotifier {
  UserModel? _userModel;
  final UserService _userService;
  final FirebaseAuth _firebaseAuth;
  bool _isInitialized = false;

  UserNotifier(this._userService, this._firebaseAuth);

  UserModel? get userModel => _userModel;
  bool get isInitialized => _isInitialized;

  Future<void> toInitAppFetchUser() async {
    Log.info('앱 초기화 및 유저 정보 가져오기 시작');

    try {
      if (_firebaseAuth.currentUser == null) {
        Log.warning('로그인된 유저가 없습니다.');
        _isInitialized = true;
        notifyListeners();
        return;
      }

      _userModel = await _userService.getUser(_firebaseAuth.currentUser!.uid);
      Log.info('유저 정보 가져오기 성공: $_userModel');

      _isInitialized = true;
      notifyListeners();
    } on NetworkException catch (e) {
      Log.error('네트워크 오류 발생 - 메시지: ${e.message}');
      _handleError('인터넷 연결이 불안정합니다: ${e.message}');
    } on AuthorizationException catch (e) {
      Log.error('인증 오류 발생 - 메시지: ${e.message}');
      _handleError('인증 오류: ${e.message}');
    } on DatabaseException catch (e) {
      Log.error('데이터베이스 오류 발생 - 메시지: ${e.message}');
      _handleError('데이터베이스 오류: ${e.message}');
    } on AppException catch (e) {
      Log.error('앱 오류 발생 - 메시지: ${e.message}');
      _handleError('앱 오류: ${e.message}');
    } catch (e, stackTrace) {
      Log.error('유저 정보 가져오기 중 예상치 못한 오류 발생', e, stackTrace);
      _handleError('예상치 못한 오류: $e');
    }
  }

  Future<UserModel?> getUserData() async {
    Log.info('유저 데이터 요청');

    if (_userModel == null) {
      Log.warning('유저 정보가 초기화되지 않았습니다. toInitAppFetchUser 를 먼저 호출해야 합니다.');
      throw AppException(
          '유저 정보가 초기화되지 않았습니다. toInitAppFetchUser 를 먼저 호출해야 합니다.');
    }

    return _userModel;
  }

  void logout() {
    Log.info('유저 로그아웃');
    _userModel = null;
    _isInitialized = false;
    notifyListeners();
  }

  void _handleError(String message) {
    Log.error(message);
    // TODO : Show error message to user using dialog or snackbar
    notifyListeners();
  }
}
