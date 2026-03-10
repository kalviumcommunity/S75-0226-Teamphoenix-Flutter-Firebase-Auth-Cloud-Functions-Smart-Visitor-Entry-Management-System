class AppConstants {
  // App Info
  static const String appName = 'Smart Visitor Entry';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String visitorsCollection = 'visitors';

  // User Roles
  static const String adminRole = 'admin';
  static const String guardRole = 'guard';

  // Visitor Status
  static const String visitorInside = 'inside';
  static const String visitorExited = 'exited';

  // Document Types
  static const List<String> documentTypes = [
    'passport',
    'id_card',
    'driving_license',
    'visa'
  ];

  // Regex Patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9]{10,15}$';

  // Error Messages
  static const String genericError = 'An error occurred. Please try again.';
  static const String networkError = 'Network error. Please check your connection.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPassword = 'Password must be at least 6 characters.';
  static const String passwordMismatch = 'Passwords do not match.';
  static const String emptyField = 'This field cannot be empty.';
}
