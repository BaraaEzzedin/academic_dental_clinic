class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://main-dental-clinical.onrender.com';

  // Auth — staff
  static const String staffLogin = '/auth/staff/login';

  // Auth — patient
  static const String requestOtp = '/auth/login/send-otp';
  static const String verifyOtp = '/auth/login/verify-otp';

  // Clinical cases — student
  static const String myClinicalCases = '/clinical-cases/my-cases';
  static const String openCases = '/clinical-cases/open';
  static String openCaseDetails(int id) => '$openCases/$id';
  static const String assignedCases = '/clinical-cases/assigned';
  static String assignedCaseDetails(int id) => '/clinical-cases/my/$id/assigned';
  static String myCaseDetails(int id) => '/clinical-cases/my/$id';
  static String caseMedia(int id) => '/clinical-cases/$id/media';

  // Clinical appointments — student
  static const String clinicalAppointments = '/clinical-appointments';
  static const String todayAppointments = '/clinical-appointments/today';
  static const String availableAppointments = '/clinical-appointments/available';

  // Subjects (clinical courses) — student
  static const String mySubjects = '/students/me/subjects';
  static String subjectProcedures(int subjectId) =>
      '/subjects/$subjectId/procedures';

  // Case acceptance requests — student
  static const String diagnosisSubmission = '/diagnosis-submission';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
}