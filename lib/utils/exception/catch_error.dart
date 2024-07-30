import 'package:firebase_auth/firebase_auth.dart';
import 'package:gfbf/utils/exception/custom_exception.dart';

Future<T> catchError<T>(Future<T> Function() tryBlock) async {
  try {
    return await tryBlock();
  } catch (e) {
    if (e is FirebaseAuthException) {
      // Handle Firebase specific exceptions
      throw CustomException(message: e.message ?? "An error occurred");
    } else {
      // Handle generic exceptions
      throw CustomException(message: e.toString());
    }
  }
}
