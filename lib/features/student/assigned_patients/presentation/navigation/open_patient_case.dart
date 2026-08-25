import 'package:flutter/material.dart';
import '../../domain/entities/assigned_patient_entity.dart';
import '../screens/assigned_patient_details_screen.dart';

/// Opens the Assigned Patient Details screen for an assigned [patient].
///
/// Shared by the home-page preview card and the full Assigned Patients screen so
/// "View Details" behaves identically in both places. From there the student can
/// review the case and submit a case-acceptance request to the supervisor.
///
/// Resolves to `true` when the student cancelled the assignment on the details
/// screen, signalling the caller to reload its assigned-patients list.
Future<bool?> openAssignedPatientCase(
  BuildContext context,
  AssignedPatientEntity patient,
) {
  return Navigator.of(context).push<bool>(
    MaterialPageRoute<bool>(
      builder: (_) => AssignedPatientDetailsScreen(patient: patient),
    ),
  );
}