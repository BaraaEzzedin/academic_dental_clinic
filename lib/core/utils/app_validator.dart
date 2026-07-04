class AppValidator {
  AppValidator._();

  static String? validateStudentNumber(
      String? value,
      ) {
    if (value == null || value.trim().isEmpty) {
      return 'Student number is required';
    }

    if (!RegExp(r'^\d{9}$').hasMatch(value)) {
      return 'Student number must be 9 digits';
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
}