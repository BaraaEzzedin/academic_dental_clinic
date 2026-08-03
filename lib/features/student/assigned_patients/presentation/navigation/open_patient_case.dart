import 'package:flutter/material.dart';
import '../../../../../core/enums/patient_status.dart';
import '../../../patient_case/presentation/screens/case_details_screen.dart';
import '../../domain/entities/assigned_patient_entity.dart';

void openAssignedPatientCase(
  BuildContext context,
  AssignedPatientEntity patient,
) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => CaseDetailsScreen(
        patientId: patient.id.toString(),
        status: PatientStatus.inTreatment,
      ),
    ),
  );
}