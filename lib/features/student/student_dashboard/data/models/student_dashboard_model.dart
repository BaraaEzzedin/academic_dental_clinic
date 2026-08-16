import '../../domain/entities/student_dashboard_entity.dart';

/// Parses the `data` object of `GET /students/profile` into a
/// [StudentDashboardEntity]. Tolerant of missing/null fields.
class StudentDashboardModel {
  const StudentDashboardModel._();

  static StudentDashboardEntity fromData(Map<String, dynamic> data) {
    final student = data['student'] as Map<String, dynamic>? ?? const {};
    final user = data['user'] as Map<String, dynamic>? ?? const {};
    final academic = data['academic'] as Map<String, dynamic>? ?? const {};
    final studyYear = academic['studyYear'] as Map<String, dynamic>? ?? const {};
    final academicYear =
        academic['academicYear'] as Map<String, dynamic>? ?? const {};
    final subjects = data['subjects'] as List<dynamic>? ?? const [];
    final stats = data['stats'] as Map<String, dynamic>? ?? const {};

    return StudentDashboardEntity(
      student: DashboardStudentEntity(
        fullName: user['fullName'] as String? ?? '',
        universityId: student['universityId'] as String? ?? '',
        studyYear: studyYear['name'] as String? ?? '',
        academicYear: academicYear['label'] as String? ?? '',
      ),
      subjects: subjects
          .whereType<Map<String, dynamic>>()
          .map(_subjectFromJson)
          .toList(),
      stats: _statsFromJson(stats),
    );
  }

  static DashboardSubjectEntity _subjectFromJson(Map<String, dynamic> json) {
    final section = json['section'] as Map<String, dynamic>? ?? const {};
    return DashboardSubjectEntity(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      sectionName: section['name'] as String? ?? '',
      supervisor: json['supervisor'] as String? ?? '',
      completedProcedures: (json['completedProcedures'] as num?)?.toInt() ?? 0,
      requiredProcedures: (json['requiredProcedures'] as num?)?.toInt() ?? 0,
      completionPercentage:
          (json['completionPercentage'] as num?)?.toDouble() ?? 0,
    );
  }

  static DashboardStatsEntity _statsFromJson(Map<String, dynamic> json) {
    return DashboardStatsEntity(
      totalCases: (json['totalCases'] as num?)?.toInt() ?? 0,
      activeCases: (json['activeCases'] as num?)?.toInt() ?? 0,
      completedCases: (json['completedCases'] as num?)?.toInt() ?? 0,
      casesByStatus: _intMap(json['casesByStatus']),
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
      completedProcedures: (json['completedProcedures'] as num?)?.toInt() ?? 0,
      requiredProcedures: (json['requiredProcedures'] as num?)?.toInt() ?? 0,
      overallCompletionPercentage:
          (json['overallCompletionPercentage'] as num?)?.toDouble() ?? 0,
      evaluations: _evaluationsFromJson(
        json['evaluations'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  static DashboardEvaluationsEntity _evaluationsFromJson(
    Map<String, dynamic> json,
  ) {
    final average = json['averageGrade'] as Map<String, dynamic>?;
    return DashboardEvaluationsEntity(
      count: (json['count'] as num?)?.toInt() ?? 0,
      averagePoints: (average?['points'] as num?)?.toDouble(),
      averageLetter: average?['letter'] as String?,
      gradeDistribution: _intMap(json['gradeDistribution']),
    );
  }

  /// Coerces a `{ key: number }` JSON object into an ordered `Map<String,int>`.
  static Map<String, int> _intMap(dynamic value) {
    if (value is! Map) return const {};
    return {
      for (final entry in value.entries)
        entry.key.toString(): (entry.value as num?)?.toInt() ?? 0,
    };
  }
}
