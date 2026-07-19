import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/assigned_patient.dart';
import 'patient_filter_state.dart';


class PatientFilterCubit extends Cubit<PatientFilterState> {
  PatientFilterCubit({List<AssignedPatient> patients = const []})
      : super(PatientFilterState(patients: patients));

  void selectFilter(PatientStatusFilter filter) {
    if (filter == state.selectedFilter) return;
    emit(state.copyWith(selectedFilter: filter));
  }
}