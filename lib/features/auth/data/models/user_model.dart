import '../../domain/entities/user_entity.dart';
import '../mapper/user_role_mapper.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.role,
    super.academicYear,
    super.studyYear,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      // Prefer `full_name`, falling back to `name` when present.
      fullName: (json['full_name'] as String?) ?? (json['name'] as String?) ?? '',
      role: userRoleFromApi(json['role'] as String?),
      academicYear: json['academicYear'] as String?,
      studyYear: json['studyYear'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'role': userRoleToApi(role),
      'academicYear': academicYear,
      'studyYear': studyYear,
    };
  }
}