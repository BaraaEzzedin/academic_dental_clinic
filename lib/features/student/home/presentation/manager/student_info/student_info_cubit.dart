import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/auth/data/data_source/auth_local_data_source.dart';
import '../../models/student_info.dart';

/// Loads the signed-in student's identity (name, study year, academic year)
/// from the persisted login profile for the Home header card.
class StudentInfoCubit extends Cubit<StudentInfo> {
  StudentInfoCubit(this._local) : super(StudentInfo.empty);

  final AuthLocalDataSource _local;

  Future<void> load() async {
    final name = await _local.getUserName() ?? '';
    final studyYear = await _local.getStudyYear() ?? '';
    final academicYear = await _local.getAcademicYear() ?? '';
    emit(StudentInfo(
      studentName: name,
      studyYear: studyYear,
      academicYear: academicYear,
    ));
  }
}