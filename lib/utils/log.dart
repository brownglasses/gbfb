import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // 호출 스택에 표시할 메서드 수
      errorMethodCount: 8, // 오류 스택에 표시할 메서드 수
      lineLength: 120, // 한 줄에 표시할 최대 길이
      colors: true, // 색상 사용
      printEmojis: true, // 이모지 사용
      printTime: true, // 타임스탬프 사용
    ),
  );

  static void debug(String message) {
    _logger.d(message);
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void critical(String message,
      [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
