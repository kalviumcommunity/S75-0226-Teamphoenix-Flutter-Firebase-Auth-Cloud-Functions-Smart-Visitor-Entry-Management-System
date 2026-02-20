import 'constants.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emptyField;
    }
    if (!RegExp(AppConstants.emailPattern).hasMatch(value)) {
      return AppConstants.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emptyField;
    }
    if (value.length < 6) {
      return AppConstants.invalidPassword;
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppConstants.emptyField;
    }
    if (password != confirmPassword) {
      return AppConstants.passwordMismatch;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emptyField;
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters.';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emptyField;
    }
    if (!RegExp(AppConstants.phonePattern).hasMatch(value)) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emptyField;
    }
    return null;
  }
}
