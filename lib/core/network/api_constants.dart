class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://main-dental-clinical.onrender.com';

  // Auth — staff
  static const String staffLogin = '/auth/staff/login';
  static const String logout = '/auth/logout';

  // Auth — patient
  static const String requestOtp = '/auth/login/send-otp';
  static const String verifyOtp = '/auth/login/verify-otp';

  // Clinical cases — student
  static const String myClinicalCases = '/clinical-cases/my-cases';
  static const String openCases = '/clinical-cases/open';
  static const String walkInCase = '/clinical-cases/walk-in';
  static String openCaseDetails(int id) => '$openCases/$id';
  static const String assignedCases = '/clinical-cases/assigned';
  static String assignedCaseDetails(int id) => '/clinical-cases/my/$id/assigned';
  static String myCaseDetails(int id) => '/clinical-cases/my/$id';
  static String caseMedia(int id) => '/clinical-cases/$id/media';

  // Treatment sessions — student (query param: clinicalCaseId)
  static const String treatmentSessions = '/treatment-sessions/student';

  // Treatment session — create (POST)
  static const String createTreatmentSession = '/treatment-sessions';

  // Treatment session — planned procedures (GET)
  static String plannedProcedures(int treatmentSessionId) =>
      '/treatment-sessions/$treatmentSessionId/planned-procedures';

  // Treatment session — summary of a completed session (GET)
  static String sessionSummary(int sessionId) =>
      '/treatment-sessions/summary/$sessionId';

  // Treatment session — complete (PATCH)
  static String completeTreatmentSession(int treatmentSessionId) =>
      '/treatment-sessions/$treatmentSessionId/complete';

  // Treatment session — start (PATCH)
  static String startTreatmentSession(int treatmentSessionId) =>
      '/treatment-sessions/$treatmentSessionId/start';

  // Treatment session — edit schedule (PATCH)
  static String editTreatmentSession(int treatmentSessionId) =>
      '/treatment-sessions/$treatmentSessionId/edit';

  // Materials for a subject (GET)
  static String subjectMaterials(int subjectId) =>
      '/subjects/$subjectId/materials';

  // Clinical appointments — student
  static const String clinicalAppointments = '/clinical-appointments';
  static const String todayAppointments = '/clinical-appointments/today';
  static const String availableAppointments = '/clinical-appointments/available';
  // Grouped schedule for the Home screen: { today: [...], upcoming: [...] }.
  static const String studentUpcomingAppointments =
      '/clinical-appointments/student-upcoming';

  // Student dashboard / academic profile
  static const String studentProfile = '/students/profile';

  // Subjects (clinical courses) — student
  static const String mySubjects = '/students/me/subjects';
  static String subjectDetails(int subjectId) => '$mySubjects/$subjectId';
  static String subjectProcedures(int subjectId) =>
      '/subjects/$subjectId/procedures';

  // Case acceptance requests — student
  static const String diagnosisSubmission = '/diagnosis-submission';

  // Push notifications — device token registration (POST)
  static const String registerDeviceToken = '/fcm-tokens';

  // Push notifications — notification history/list (GET)
  static const String notifications = '/notifications';

  // AI assistant — analyze a dental image (POST, multipart)
  static const String aiAnalyze = '/ai/analyze';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
}