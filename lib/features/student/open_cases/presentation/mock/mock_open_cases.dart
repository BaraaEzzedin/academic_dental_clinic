import '../../domain/entities/case_subject_entity.dart';
import '../../domain/entities/open_case_entity.dart';

/// Temporary in-memory data used to build out the Patient Requests UI while the
/// backend is being finished. Swap this for the real data source / use case
/// once the API is ready — the widgets already consume domain entities, so no
/// UI changes will be needed.
const List<CaseSubjectEntity> mockCaseSubjects = [
  CaseSubjectEntity(id: 1, name: 'Operative Dentistry'),
  CaseSubjectEntity(id: 2, name: 'Endodontics'),
  CaseSubjectEntity(id: 3, name: 'Periodontics'),
  CaseSubjectEntity(id: 4, name: 'Prosthodontics'),
  CaseSubjectEntity(id: 5, name: 'Oral Surgery'),
];

const List<OpenCaseEntity> mockOpenCases = [
  // ---------- Operative Dentistry (1) ----------
  OpenCaseEntity(
    id: 101,
    subjectId: 1,
    subject: 'Operative Dentistry',
    patientName: 'Layla Haddad',
    chiefComplaint: 'Sensitivity to cold and a visible cavity on a lower molar.',
    coordinatorName: 'Dr. Rania Fadel',
    department: 'Restorative Clinic A',
  ),
  OpenCaseEntity(
    id: 102,
    subjectId: 1,
    subject: 'Operative Dentistry',
    patientName: 'Omar Nasser',
    chiefComplaint: 'Chipped front tooth after a minor fall, wants it restored.',
    coordinatorName: 'Dr. Rania Fadel',
    department: 'Restorative Clinic A',
  ),
  OpenCaseEntity(
    id: 103,
    subjectId: 1,
    subject: 'Operative Dentistry',
    patientName: 'Hana Khoury',
    chiefComplaint: 'Old filling fell out and food keeps getting stuck.',
    coordinatorName: 'Dr. Samir Aziz',
    department: 'Restorative Clinic B',
  ),

  // ---------- Endodontics (2) ----------
  OpenCaseEntity(
    id: 201,
    subjectId: 2,
    subject: 'Endodontics',
    patientName: 'Yousef Barakat',
    chiefComplaint: 'Severe throbbing pain in an upper back tooth, worse at night.',
    coordinatorName: 'Dr. Nadia Salem',
    department: 'Endodontic Clinic',
  ),
  OpenCaseEntity(
    id: 202,
    subjectId: 2,
    subject: 'Endodontics',
    patientName: 'Mariam Darwish',
    chiefComplaint: 'Lingering pain after hot drinks and swelling near the gum.',
    coordinatorName: 'Dr. Nadia Salem',
    department: 'Endodontic Clinic',
  ),

  // ---------- Periodontics (3) ----------
  OpenCaseEntity(
    id: 301,
    subjectId: 3,
    subject: 'Periodontics',
    patientName: 'Karim Mansour',
    chiefComplaint: 'Bleeding gums when brushing and bad breath for weeks.',
    coordinatorName: 'Dr. Lina Habib',
    department: 'Periodontal Clinic',
  ),
  OpenCaseEntity(
    id: 302,
    subjectId: 3,
    subject: 'Periodontics',
    patientName: 'Salma Rahal',
    chiefComplaint: 'Loose lower front teeth and receding gum line.',
    coordinatorName: 'Dr. Lina Habib',
    department: 'Periodontal Clinic',
  ),

  // ---------- Prosthodontics (4) ----------
  OpenCaseEntity(
    id: 401,
    subjectId: 4,
    subject: 'Prosthodontics',
    patientName: 'Fadi Chalhoub',
    chiefComplaint: 'Missing two back teeth, difficulty chewing on the left side.',
    coordinatorName: 'Dr. Tarek Younis',
    department: 'Prosthodontic Clinic',
  ),
  OpenCaseEntity(
    id: 402,
    subjectId: 4,
    subject: 'Prosthodontics',
    patientName: 'Rima Sleiman',
    chiefComplaint: 'Ill-fitting old denture that causes sore spots.',
    coordinatorName: 'Dr. Tarek Younis',
    department: 'Prosthodontic Clinic',
  ),

  // ---------- Oral Surgery (5) ----------
  OpenCaseEntity(
    id: 501,
    subjectId: 5,
    subject: 'Oral Surgery',
    patientName: 'Nabil Aoun',
    chiefComplaint: 'Impacted wisdom tooth causing pain and jaw stiffness.',
    coordinatorName: 'Dr. Hadi Karam',
    department: 'Oral Surgery Clinic',
  ),
];