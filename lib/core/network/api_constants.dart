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

  // Clinical appointments — student
  static const String todayAppointments = '/clinical-appointments/today';

  // Subjects (clinical courses) — student
  static const String mySubjects = '/students/me/subjects';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
}