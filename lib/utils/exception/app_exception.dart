class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => "AppException: $message";
}

class AuthorizationException extends AppException {
  AuthorizationException(super.message);

  @override
  String toString() => "AuthorizationException: $message";
}

class NetworkException extends AppException {
  NetworkException(super.message);

  @override
  String toString() => "NetworkException: $message";
}

class DatabaseException extends AppException {
  DatabaseException(super.message);

  @override
  String toString() => "DatabaseException: $message";
}

class FileNotFoundException extends AppException {
  FileNotFoundException(super.message);

  @override
  String toString() => "FileNotFoundException: $message";
}

class DataNotFoundException extends AppException {
  DataNotFoundException(super.message);

  @override
  String toString() => "DataNotFoundException: $message";
}

class StorageException extends AppException {
  StorageException(super.message);

  @override
  String toString() => "StorageException: $message";
}
