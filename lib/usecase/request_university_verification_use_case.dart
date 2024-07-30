import 'package:gfbf/models/university_verification_request_model.dart';
import 'package:gfbf/services/user_service.dart';

class RequestUniversityVerificationUseCase {
  final UserService userService;

  RequestUniversityVerificationUseCase(this.userService);

  Future<void> execute(UniversityVerificationRequestModel requestModel) async {
    await userService.createUniversityVerificationRequest(requestModel);
  }
}
