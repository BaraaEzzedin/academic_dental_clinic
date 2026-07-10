class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}


class ServerException extends AppException {
  const ServerException([super.message = 'Something went wrong on the server']);
}


class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}


class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed']);
}


class CacheException extends AppException {
  const CacheException([super.message = 'Local storage error']);
}