class CustomException implements Exception {
  final String message;
  final String? code;

  CustomException({required this.message, this.code});

  @override
  String toString() {
    return "CustomException: $message${code != null ? ' (code: $code)' : ''}";
  }
}
