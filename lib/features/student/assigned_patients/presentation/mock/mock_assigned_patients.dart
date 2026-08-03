import '../../domain/entities/assigned_patient_entity.dart';

final List<AssignedPatientEntity> mockAssignedPatients = [
  AssignedPatientEntity(
    id: 1,
    patientName: 'Sara Mahmoud',
    subjectName: 'Periodontics',
    chiefComplaint: 'Bleeding gums when brushing and bad breath for weeks.',
    appointmentDate: DateTime(2026, 8, 5),
  ),
  AssignedPatientEntity(
    id: 2,
    patientName: 'Ahmad Khaled',
    subjectName: 'Operative Dentistry',
    chiefComplaint: 'Sensitivity to cold and a visible cavity on a lower molar.',
    appointmentDate: DateTime(2026, 8, 6),
  ),
  AssignedPatientEntity(
    id: 3,
    patientName: 'Lina Yousef',
    subjectName: 'Endodontics',
    chiefComplaint: 'Severe throbbing pain in an upper back tooth, worse at night.',
    appointmentDate: DateTime(2026, 8, 8),
  ),
  AssignedPatientEntity(
    id: 4,
    patientName: 'Omar Nasser',
    subjectName: 'Prosthodontics',
    chiefComplaint: 'Missing two back teeth, difficulty chewing on the left side.',
    appointmentDate: DateTime(2026, 8, 11),
  ),
  AssignedPatientEntity(
    id: 5,
    patientName: 'Hana Khoury',
    subjectName: 'Oral Surgery',
    chiefComplaint: 'Impacted wisdom tooth causing pain and jaw stiffness.',
    appointmentDate: DateTime(2026, 8, 13),
  ),
];