import '../../../../core/enums/user_role.dart';
import '../../domain/entities/user_entity.dart';
import '../mapper/user_role_mapper.dart';
import 'user_model.dart';


class AuthResponseModel {
  const AuthResponseModel({
    required this.accessToken,
    required this.role,
    required this.user,
  });

  final String accessToken;
  final UserRole role;
  final UserModel user;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      role: userRoleFromApi(json['role'] as String?),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  User toEntity() => User(id: user.id, fullName: user.fullName, role: role);
}