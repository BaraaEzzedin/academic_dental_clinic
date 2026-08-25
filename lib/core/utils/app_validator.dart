class AppValidator {
  AppValidator._();

  static String? validateEmail(
      String? value,
      ) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailRegExp = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!emailRegExp.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(
      String? value,
      ) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8 || value.length > 16) {
      return 'Password must contain 8-16 characters';
    }

    return null;
  }


  static String? validatePatientNumber(
      String? value,
      ) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    if (!isValidSyrianPhone(value)) {
      return 'Phone number must be 963 followed by 9 digits';
    }

    return null;
  }

  /// Whether [value] is a Syrian mobile number in the canonical wire format:
  /// `963` followed by exactly 9 digits (e.g. `963938304093`).
  static bool isValidSyrianPhone(String? value) =>
      RegExp(r'^963\d{9}$').hasMatch((value ?? '').trim());

  static String? validateOtp(
      String? value,
      ) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP code is required';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'OTP code must be 6 digits';
    }

    return null;
  }
}