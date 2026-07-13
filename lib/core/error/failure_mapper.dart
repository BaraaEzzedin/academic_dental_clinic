import 'exceptions.dart';
import 'failures.dart';

Failure mapExceptionToFailure(AppException exception) {
  return switch (exception) {
    NetworkException() => NetworkFailure(exception.message),
    AuthException() => AuthFailure(exception.message),
    CacheException() => CacheFailure(exception.message),
    _ => ServerFailure(exception.message),
  };
}