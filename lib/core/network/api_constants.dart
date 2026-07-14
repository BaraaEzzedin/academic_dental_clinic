class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'http://192.168.0.2:3000';

  // Auth — staff
  static const String staffLogin = '/auth/staff/login';

  // Auth — patient
  static const String requestOtp = '/auth/login/send-otp';
  static const String verifyOtp = '/auth/login/verify-otp';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}