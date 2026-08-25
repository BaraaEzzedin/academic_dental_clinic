import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_student_dashboard_use_case.dart';
import 'student_dashboard_state.dart';

class StudentDashboardCubit extends Cubit<StudentDashboardState> {
  StudentDashboardCubit(this._getDashboard)
      : super(const StudentDashboardState());

  final GetStudentDashboardUseCase _getDashboard;

  Future<void> load() async {
    emit(state.copyWith(status: StudentDashboardStatus.loading));
    final result = await _getDashboard();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: StudentDashboardStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (dashboard) => emit(
        state.copyWith(
          status: StudentDashboardStatus.loaded,
          dashboard: dashboard,
        ),
      ),
    );
  }
}
