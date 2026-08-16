import 'package:equatable/equatable.dart';

/// The student's identity shown in the Home header card.
///
/// A plain view object, populated from the persisted login profile via
/// [StudentInfoCubit]. Decoupled from the data source so the widget layer only
/// depends on this shape.
class StudentInfo extends Equatable {
  const StudentInfo({
    required this.studentName,
    required this.studyYear,
    required this.academicYear,
  });

  /// Full name, e.g. "Omar Nasser".
  final String studentName;

  /// Academic level, e.g. "Fourth Year".
  final String studyYear;

  /// The active academic year range, e.g. "2025-2026".
  final String academicYear;

  /// Empty placeholder used before the profile has loaded.
  static const StudentInfo empty =
      StudentInfo(studentName: '', studyYear: '', academicYear: '');

  bool get hasName => studentName.trim().isNotEmpty;

  @override
  List<Object?> get props => [studentName, studyYear, academicYear];
}