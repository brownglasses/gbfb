import 'package:gfbf/services/user_service.dart';
import 'package:gfbf/models/university_verification_request_model.dart';

class GetUniversityVerificationRequestResultUseCase {
  final UserService userService;

  GetUniversityVerificationRequestResultUseCase(this.userService);

  Future<UniversityVerificationRequestModel?> execute(String uid) async {
    return await userService.getUniversityVerificationRequest(uid);
  }
}
