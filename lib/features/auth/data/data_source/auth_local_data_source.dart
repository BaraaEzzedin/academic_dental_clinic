import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();

  /// Persists the signed-in user's display name so it can be shown later
  /// (e.g. the "created patient" appointment summary) without re-fetching.
  Future<void> saveUserName(String name);
  Future<String?> getUserName();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this.storage);

  final FlutterSecureStorage storage;

  static const String tokenKey = 'access_token';
  static const String userNameKey = 'user_full_name';

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
      await storage.delete(key: userNameKey);
    } catch (e) {
      throw const CacheException('Failed to clear the session token.');
    }
  }

  @override
  Future<void> saveUserName(String name) async {
    try {
      await storage.write(key: userNameKey, value: name);
    } catch (e) {
      throw const CacheException('Failed to save the user name.');
    }
  }

  @override
  Future<String?> getUserName() async {
    try {
      return await storage.read(key: userNameKey);
    } catch (e) {
      throw const CacheException('Failed to read the user name.');
    }
  }
}