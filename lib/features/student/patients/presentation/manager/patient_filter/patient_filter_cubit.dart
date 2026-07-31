import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/assigned_patient_entity.dart';
import '../../models/patient_status_filter.dart';
import 'patient_filter_state.dart';


class PatientFilterCubit extends Cubit<PatientFilterState> {
  PatientFilterCubit({List<AssignedPatientEntity> patients = const []})
      : super(PatientFilterState(patients: patients));

  void selectFilter(PatientStatusFilter filter) {
    if (filter == state.selectedFilter) return;
    emit(state.copyWith(selectedFilter: filter));
  }
}