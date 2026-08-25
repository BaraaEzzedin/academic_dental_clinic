import '../../../../../core/utils/date_formatter.dart';
import '../../domain/entities/open_case_details_entity.dart';

class OpenCaseDetailsModel extends OpenCaseDetailsEntity {
  const OpenCaseDetailsModel({
    required super.id,
    required super.subjectId,
    required super.patientName,
    required super.subject,
    required super.dateOfBirth,
    required super.gender,
    required super.phoneNumber,
    required super.chiefComplaint,
    required super.symptoms,
    required super.currentMedications,
    required super.allergies,
    required super.media,
  });

  factory OpenCaseDetailsModel.fromJson(Map<String, dynamic> json) {
    final patient = json['patient'] as Map<String, dynamic>?;
    final request = json['patient_request'] as Map<String, dynamic>?;
    final subject = json['subject'] as Map<String, dynamic>?;

    return OpenCaseDetailsModel(
      id: (json['id'] as num).toInt(),
      subjectId: (subject?['id'] as num?)?.toInt() ?? 0,
      patientName: patient?['fullName'] as String? ?? '',
      subject: subject?['name'] as String? ?? '',
      dateOfBirth:
          DateFormatter.mediumDateFromIso(patient?['dateOfBirth'] as String?),
      gender: patient?['gender'] as String? ?? '',
      phoneNumber: patient?['phone'] as String? ?? '',
      chiefComplaint: request?['chiefComplaint'] as String? ?? '',
      symptoms: _splitBullets(request?['symptoms'] as String?),
      currentMedications:
          _splitBullets(patient?['currentMedications'] as String?),
      allergies: _splitBullets(patient?['allergies'] as String?),
      // The API doesn't return media yet; the media card shows its empty state.
      media: const [],
    );
  }


  static List<String> _splitBullets(String? raw) {
    if (raw == null) return const [];
    return raw
        .split('*')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}