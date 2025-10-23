import '../core/app_strings.dart';

class Validators {
  static String? isRequired(String? value, [String? message]) {
    if (value == null || value.trim().isEmpty) {
      return message ?? AppStrings.nameRequired;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return AppStrings.emailRequired;
    final regex = RegExp(r'^[\w.%+-]+@[\w.-]+\.[A-Za-z]{2,}$');
    return regex.hasMatch(value) ? null : AppStrings.invalidEmail;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return AppStrings.phoneRequired;

    // Remove all non-digit characters except +
    final cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Check for valid phone number patterns
    final phoneRegex = RegExp(r'^(\+\d{1,3})?[\d\s\-\(\)]{8,15}$');

    if (!phoneRegex.hasMatch(value)) {
      return AppStrings.invalidPhone;
    }

    // Check minimum length
    final digitsOnly = cleanedValue.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 8) {
      return 'Phone number is too short';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    if (value.length < 6) return AppStrings.passwordLengthError;

    // Optional: Add more password strength requirements
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  static String? confirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppStrings.confirmPasswordRequired;
    }

    if (password != confirmPassword) {
      return AppStrings.passwordMismatch;
    }

    return null;
  }
}
