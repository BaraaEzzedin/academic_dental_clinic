import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this.storage);

  final FlutterSecureStorage storage;

  static const String tokenKey = 'access_token';

  @override
  Future<void> saveToken(String token) async {
    try {
      await storage.write(key: tokenKey, value: token);
    } catch (e) {
      throw const CacheException('Failed to save the session token.');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await storage.read(key: tokenKey);
    } catch (e) {
      throw const CacheException('Failed to read the session token.');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await storage.delete(key: tokenKey);
    } catch (e) {
      throw const CacheException('Failed to clear the session token.');
    }
  }
}