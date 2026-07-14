import '../../domain/entities/user_entity.dart';
import '../mapper/user_role_mapper.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      fullName: json['full_name'] as String,
      role: userRoleFromApi(json['role'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'role': userRoleToApi(role),
    };
  }
}