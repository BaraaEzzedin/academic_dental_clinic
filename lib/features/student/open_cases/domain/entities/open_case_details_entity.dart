import 'package:equatable/equatable.dart';

/// Full detail payload for a single open (unassigned) case, shown on the
/// Open Case Details screen. This aggregates everything the student needs
/// before taking the case for the initial patient examination.
///
/// TODO(backend): map this from the real API response once the open-case
/// details endpoint is ready. The widgets already consume this entity, so no
/// UI changes will be needed.
class OpenCaseDetailsEntity extends Equatable {
  const OpenCaseDetailsEntity({
    required this.id,
    required this.patientName,
    required this.subject,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.chiefComplaint,
    required this.symptoms,
    required this.currentMedications,
    required this.allergies,
    required this.media,
  });

  final int id;
  final String patientName;
  final String subject;
  final int age;
  final String gender;
  final String phoneNumber;

  /// The main complaint — identical to the one shown on the open-case list card.
  final String chiefComplaint;

  final List<String> symptoms;
  final List<String> currentMedications;
  final List<String> allergies;
  final List<CaseMediaEntity> media;

  @override
  List<Object?> get props => [
        id,
        patientName,
        subject,
        age,
        gender,
        phoneNumber,
        chiefComplaint,
        symptoms,
        currentMedications,
        allergies,
        media,
      ];
}

/// A single media/file attachment (x-ray, photo, scan) tied to an open case.
/// [imageUrl] is null until the backend provides media; the UI falls back to a
/// placeholder in that case.
class CaseMediaEntity extends Equatable {
  const CaseMediaEntity({
    required this.label,
    required this.date,
    this.imageUrl,
  });

  final String label;
  final String date;
  final String? imageUrl;

  @override
  List<Object?> get props => [label, date, imageUrl];
}