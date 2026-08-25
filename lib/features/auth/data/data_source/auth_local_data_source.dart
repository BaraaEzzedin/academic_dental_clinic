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

  /// Persists the student's academic profile (study year / academic year) so
  /// the Home identity card can render it without re-fetching.
  Future<void> saveStudentProfile({String? studyYear, String? academicYear});
  Future<String?> getStudyYear();
  Future<String?> getAcademicYear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this.storage);

  final FlutterSecureStorage storage;

  static const String tokenKey = 'access_token';
  static const String userNameKey = 'user_full_name';
  static const String studyYearKey = 'user_study_year';
  static const String academicYearKey = 'user_academic_year';

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
      await storage.delete(key: studyYearKey);
      await storage.delete(key: academicYearKey);
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

  @override
  Future<void> saveStudentProfile({
    String? studyYear,
    String? academicYear,
  }) async {
    try {
      if (studyYear != null) {
        await storage.write(key: studyYearKey, value: studyYear);
      }
      if (academicYear != null) {
        await storage.write(key: academicYearKey, value: academicYear);
      }
    } catch (e) {
      throw const CacheException('Failed to save the student profile.');
    }
  }

  @override
  Future<String?> getStudyYear() async {
    try {
      return await storage.read(key: studyYearKey);
    } catch (e) {
      throw const CacheException('Failed to read the study year.');
    }
  }

  @override
  Future<String?> getAcademicYear() async {
    try {
      return await storage.read(key: academicYearKey);
    } catch (e) {
      throw const CacheException('Failed to read the academic year.');
    }
  }
}