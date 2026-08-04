import 'package:flutter/material.dart';
import '../../domain/entities/assigned_patient_entity.dart';
import '../screens/assigned_patient_details_screen.dart';

/// Opens the Assigned Patient Details screen for an assigned [patient].
///
/// Shared by the home-page preview card and the full Assigned Patients screen so
/// "View Details" behaves identically in both places. From there the student can
/// review the case and submit a case-acceptance request to the supervisor.
void openAssignedPatientCase(
  BuildContext context,
  AssignedPatientEntity patient,
) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => AssignedPatientDetailsScreen(patient: patient),
    ),
  );
}