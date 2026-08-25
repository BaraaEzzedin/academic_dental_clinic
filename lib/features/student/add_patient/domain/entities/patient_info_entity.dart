import 'package:equatable/equatable.dart';

import '../../../../../core/utils/app_validator.dart';

/// Step 1 data — the patient's personal/medical details plus the case-level
/// symptoms and chief complaint. Maps to the `patient` object of the walk-in
/// request (`patientInfo` + `symptoms` + `chiefComplaint`).
class PatientInfoEntity extends Equatable {
  const PatientInfoEntity({
    this.fullName = '',
    this.phone = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.allergies = '',
    this.medicalHistory = '',
    this.currentMedications = '',
    this.symptoms = '',
    this.chiefComplaint = '',
  });

  final String fullName;
  final String phone;

  /// ISO date string, e.g. `1990-01-01`.
  final String dateOfBirth;
  final String gender;
  final String allergies;
  final String medicalHistory;
  final String currentMedications;

  final String symptoms;
  final String chiefComplaint;

  /// The minimum required to move past Step 1.
  bool get isComplete =>
      fullName.trim().isNotEmpty &&
      AppValidator.isValidSyrianPhone(phone) &&
      dateOfBirth.trim().isNotEmpty &&
      gender.trim().isNotEmpty &&
      chiefComplaint.trim().isNotEmpty;

  PatientInfoEntity copyWith({
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? allergies,
    String? medicalHistory,
    String? currentMedications,
    String? symptoms,
    String? chiefComplaint,
  }) {
    return PatientInfoEntity(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      allergies: allergies ?? this.allergies,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      currentMedications: currentMedications ?? this.currentMedications,
      symptoms: symptoms ?? this.symptoms,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        phone,
        dateOfBirth,
        gender,
        allergies,
        medicalHistory,
        currentMedications,
        symptoms,
        chiefComplaint,
      ];
}
