class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'http://localhost:3000/api';

  // Auth — staff
  static const String staffLogin = '/auth/staff/login';

  // Auth — patient
  static const String requestOtp = '/auth/login/send-otp';
  static const String verifyOtp = '/auth/login/verify-otp';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}