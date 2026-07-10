import '../../../../core/enums/user_role.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.role,
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json, {
        required UserRole role,
      }) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      fullName: json['full_name'] as String,
      role: role,
    );
  }
}