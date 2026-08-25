import 'package:equatable/equatable.dart';

/// Aggregate payload of the Student Dashboard (`GET /students/profile`).
class StudentDashboardEntity extends Equatable {
  const StudentDashboardEntity({
    required this.student,
    required this.subjects,
    required this.stats,
  });

  final DashboardStudentEntity student;
  final List<DashboardSubjectEntity> subjects;
  final DashboardStatsEntity stats;

  @override
  List<Object?> get props => [student, subjects, stats];
}

/// Academic identity shown in the dashboard's overview card.
class DashboardStudentEntity extends Equatable {
  const DashboardStudentEntity({
    required this.fullName,
    required this.universityId,
    required this.studyYear,
    required this.academicYear,
  });

  final String fullName;
  final String universityId;

  /// e.g. "Fourth Year".
  final String studyYear;

  /// e.g. "2025-2026".
  final String academicYear;

  @override
  List<Object?> get props => [fullName, universityId, studyYear, academicYear];
}

/// Per-subject clinical progress.
class DashboardSubjectEntity extends Equatable {
  const DashboardSubjectEntity({
    required this.id,
    required this.name,
    required this.sectionName,
    required this.supervisor,
    required this.completedProcedures,
    required this.requiredProcedures,
    required this.completionPercentage,
  });

  final int id;
  final String name;
  final String sectionName;
  final String supervisor;
  final int completedProcedures;
  final int requiredProcedures;

  /// Completion on a 0..100 scale (e.g. 42.9).
  final double completionPercentage;

  @override
  List<Object?> get props => [
        id,
        name,
        sectionName,
        supervisor,
        completedProcedures,
        requiredProcedures,
        completionPercentage,
      ];
}

/// Clinical + academic statistics.
class DashboardStatsEntity extends Equatable {
  const DashboardStatsEntity({
    required this.totalCases,
    required this.activeCases,
    required this.completedCases,
    required this.casesByStatus,
    required this.totalSessions,
    required this.completedProcedures,
    required this.requiredProcedures,
    required this.overallCompletionPercentage,
    required this.evaluations,
  });

  final int totalCases;
  final int activeCases;
  final int completedCases;

  /// Raw status → count map, in backend order (e.g. `treatment_in_progress`: 3).
  final Map<String, int> casesByStatus;

  final int totalSessions;
  final int completedProcedures;
  final int requiredProcedures;

  /// Overall completion on a 0..100 scale (e.g. 27.3).
  final double overallCompletionPercentage;

  final DashboardEvaluationsEntity evaluations;

  @override
  List<Object?> get props => [
        totalCases,
        activeCases,
        completedCases,
        casesByStatus,
        totalSessions,
        completedProcedures,
        requiredProcedures,
        overallCompletionPercentage,
        evaluations,
      ];
}

/// Evaluation performance summary.
class DashboardEvaluationsEntity extends Equatable {
  const DashboardEvaluationsEntity({
    required this.count,
    required this.averagePoints,
    required this.averageLetter,
    required this.gradeDistribution,
  });

  final int count;

  /// Average GPA points (e.g. 3.7). Null when there are no evaluations.
  final double? averagePoints;

  /// Average letter grade (e.g. "A-"). Null when there are no evaluations.
  final String? averageLetter;

  /// Letter grade → count, in backend order (A+, A, A-, …).
  final Map<String, int> gradeDistribution;

  bool get hasEvaluations => count > 0;

  @override
  List<Object?> get props =>
      [count, averagePoints, averageLetter, gradeDistribution];
}
