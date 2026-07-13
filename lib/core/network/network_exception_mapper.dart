import 'package:dio/dio.dart';
import '../error/exceptions.dart';

AppException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.connectionError:
      return const NetworkException();

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode ?? 0;
      final message = _messageFromResponse(error.response);
      if (statusCode == 401 || statusCode == 403) {
        return AuthException(message ?? 'Authentication failed');
      }
      return ServerException(message ?? 'Something went wrong on the server');

    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return const ServerException();
  }
}


String? _messageFromResponse(Response<dynamic>? response) {
  final data = response?.data;
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
  }
  return null;
}