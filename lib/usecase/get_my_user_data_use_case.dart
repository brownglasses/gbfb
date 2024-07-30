import 'package:gfbf/models/user_model.dart';
import 'package:gfbf/notifier/user_notifier.dart';

class GetMyUserDataUseCase {
  UserNotifier userInfomer;

  GetMyUserDataUseCase(this.userInfomer);

  Future<UserModel?> execute() {
    return userInfomer.getUserData();
  }
}
