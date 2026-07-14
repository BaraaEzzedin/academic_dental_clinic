import '../../../../../core/enums/user_role.dart';

UserRole userRoleFromApi(String? value) {
  return UserRole.values.firstWhere(
        (role) => role.name == value,
    orElse: () => UserRole.unknown,
  );
}

String userRoleToApi(UserRole role) => role.name;