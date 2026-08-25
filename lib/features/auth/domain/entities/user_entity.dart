import 'package:equatable/equatable.dart';

import '../../../../../core/enums/user_role.dart';


class User extends Equatable {
  const User({
    required this.id,
    required this.fullName,
    required this.role,
    this.academicYear,
    this.studyYear,
  });

  final int id;
  final String fullName;
  final UserRole role;

  /// Student-only fields from the login response (e.g. "2025-2026" /
  /// "Fourth Year"). Null for accounts that don't carry them (e.g. patients).
  final String? academicYear;
  final String? studyYear;

  @override
  List<Object?> get props => [id, fullName, role, academicYear, studyYear];
}