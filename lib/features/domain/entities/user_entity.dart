import 'package:equatable/equatable.dart';

import '../../../../core/enums/user_role.dart';


class User extends Equatable {
  const User({
    required this.id,
    required this.fullName,
    required this.role,
  });

  final int id;
  final String fullName;
  final UserRole role;

  @override
  List<Object?> get props => [id, fullName, role];
}