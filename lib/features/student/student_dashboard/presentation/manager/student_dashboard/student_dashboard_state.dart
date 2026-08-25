import 'package:equatable/equatable.dart';
import '../../../domain/entities/student_dashboard_entity.dart';

enum StudentDashboardStatus { initial, loading, loaded, error }

class StudentDashboardState extends Equatable {
  const StudentDashboardState({
    this.status = StudentDashboardStatus.initial,
    this.dashboard,
    this.errorMessage,
  });

  final StudentDashboardStatus status;
  final StudentDashboardEntity? dashboard;
  final String? errorMessage;

  bool get isLoading => status == StudentDashboardStatus.loading;
  bool get hasError => status == StudentDashboardStatus.error;

  StudentDashboardState copyWith({
    StudentDashboardStatus? status,
    StudentDashboardEntity? dashboard,
    String? errorMessage,
  }) {
    return StudentDashboardState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, dashboard, errorMessage];
}
