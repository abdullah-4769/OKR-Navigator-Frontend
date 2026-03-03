import 'package:get/Get.dart';

import '../core/app_strings.dart';

class Validators {
  static String? isRequired(String? value, [String? message]) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'required_field'.tr;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'email_required'.tr;
    final regex = RegExp(r'^[\w.%+-]+@[\w.-]+\.[A-Za-z]{2,}$');
    return regex.hasMatch(value) ? null : 'invalid_email'.tr;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'phone_required'.tr;

    final cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');
    final phoneRegex = RegExp(r'^(\+\d{1,3})?[\d\s\-\(\)]{8,15}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'invalid_phone'.tr;
    }

    final digitsOnly = cleanedValue.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 8) {
      return 'phone_too_short'.tr;
    }

    if (digitsOnly.length > 15) {
      return 'phone_too_long'.tr;
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'password_required'.tr;
    if (value.length < 6) return 'password_length_error'.tr;

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasDigits = RegExp(r'[0-9]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);

    if (!hasUppercase) {
      return 'password_uppercase'.tr;
    }

    if (!hasDigits) {
      return 'password_number'.tr;
    }

    if (!hasLowercase) {
      return 'password_lowercase'.tr;
    }

    return null;
  }

  static String? confirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'confirm_password_required'.tr;
    }

    if (password != confirmPassword) {
      return 'password_mismatch'.tr;
    }

    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'password_required'.tr;
    if (value.length < 6) return 'login_password_min_length'.tr;
    return null;
  }
}


// import '../core/app_strings.dart';
//
// class Validators {
//   static String? isRequired(String? value, [String? message]) {
//     if (value == null || value.trim().isEmpty) {
//       return message ?? AppStrings.nameRequired;
//     }
//     return null;
//   }
//
//   static String? email(String? value) {
//     if (value == null || value.isEmpty) return AppStrings.emailRequired;
//     final regex = RegExp(r'^[\w.%+-]+@[\w.-]+\.[A-Za-z]{2,}$');
//     return regex.hasMatch(value) ? null : AppStrings.invalidEmail;
//   }
//
//   static String? phone(String? value) {
//     if (value == null || value.isEmpty) return AppStrings.phoneRequired;
//
//     // Remove all non-digit characters except +
//     final cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');
//
//     // Check for valid phone number patterns
//     final phoneRegex = RegExp(r'^(\+\d{1,3})?[\d\s\-\(\)]{8,15}$');
//
//     if (!phoneRegex.hasMatch(value)) {
//       return AppStrings.invalidPhone;
//     }
//
//     // Check minimum length
//     final digitsOnly = cleanedValue.replaceAll(RegExp(r'[^\d]'), '');
//     if (digitsOnly.length < 8) {
//       return 'Phone number is too short';
//     }
//
//     if (digitsOnly.length > 15) {
//       return 'Phone number is too long';
//     }
//
//     return null;
//   }
//
//   static String? password(String? value) {
//     if (value == null || value.isEmpty) return AppStrings.passwordRequired;
//     if (value.length < 6) return AppStrings.passwordLengthError;
//
//     // Optional: Add more password strength requirements
//     final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
//     final hasDigits = RegExp(r'[0-9]').hasMatch(value);
//     final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
//     final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
//
//     if (!hasUppercase) {
//       return 'Password must contain at least one uppercase letter';
//     }
//
//     if (!hasDigits) {
//       return 'Password must contain at least one number';
//     }
//
//     if (!hasLowercase) {
//       return 'Password must contain at least one lowercase letter';
//     }
//
//     // Optional: Uncomment if you want special characters requirement
//     // if (!hasSpecialCharacters) {
//     //   return 'Password must contain at least one special character';
//     // }
//
//     return null;
//   }
//
//   static String? confirmPassword(String? password, String? confirmPassword) {
//     if (confirmPassword == null || confirmPassword.isEmpty) {
//       return AppStrings.confirmPasswordRequired;
//     }
//
//     if (password != confirmPassword) {
//       return AppStrings.passwordMismatch;
//     }
//
//     return null;
//   }
//
//   // Simple password validator for login (less strict)
//   static String? loginPassword(String? value) {
//     if (value == null || value.isEmpty) return AppStrings.passwordRequired;
//     if (value.length < 6) return 'Password must be at least 6 characters';
//     return null;
//   }
// }
//
//
//
