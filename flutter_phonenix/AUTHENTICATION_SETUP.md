# Authentication Setup Guide - Smart Visitor Entry Management System

## Overview
This document describes the complete authentication setup for the Flutter Smart Visitor Entry Management System with Firebase integration.

## Firebase Configuration

### Firebase Project Details
- **Project ID**: flutter-fundamentals-demo
- **Auth Domain**: flutter-fundamentals-demo.firebaseapp.com
- **Storage Bucket**: flutter-fundamentals-demo.firebasestorage.app
- **API Key**: AIzaSyA8cJRNJIHkQbV5fi7uORLjVieebRe0ufw
- **App ID**: 1:923655831668:web:41c5fb71223d7421eb9121
- **Messaging Sender ID**: 923655831668
- **Measurement ID**: G-XC0K7ECQ4Q

### Configuration Files
The Firebase configuration is centralized in:
- **File**: `lib/firebase_options.dart`
- Contains platform-specific configurations for Web, Android, iOS, macOS, Windows, and Linux

## Authentication Flow

### 1. Application Startup
When the app starts (in `main.dart`):
1. Flutter initializes Firebase with the appropriate platform credentials
2. `AuthWrapper` listens to `FirebaseAuth.authStateChanges()`
3. Based on authentication state:
   - **Authenticated**: User is navigated to `HomeScreen`
   - **Not Authenticated**: User is navigated to `LoginScreen`

### 2. Signup Flow
**Screen**: `lib/screens/auth/signup_screen.dart`

#### Fields Required:
- **Full Name**: User's complete name (minimum 2 characters)
- **Email**: Valid email address
- **Role**: Either "Admin" or "Guard" (selected via dropdown)
- **Password**: At least 6 characters
- **Confirm Password**: Must match the password field

#### Process:
1. Form validation using `Validators` class
2. `AuthService.signUp()` is called with:
   - Email and Password → creates Firebase auth account
   - User details → stored in Firestore `users` collection
3. Upon successful signup:
   - User document created with: `id`, `email`, `name`, `role`, `createdAt`
   - User is automatically navigated to home screen

#### Error Handling:
- Firebase auth errors (duplicate email, weak password, etc.) are displayed via SnackBar
- Generic error message shown for unexpected errors

### 3. Login Flow
**Screen**: `lib/screens/auth/login_screen.dart`

#### Fields Required:
- **Email**: User's registered email
- **Password**: User's password

#### Process:
1. Form validation for email and password
2. `AuthService.login()` calls Firebase authentication
3. Upon successful login:
   - User is authenticated and session is established
   - `AuthWrapper` detects auth state change and navigates to `HomeScreen`
4. Failed login shows appropriate error message

#### Error Handling:
- Invalid credentials display specific Firebase error
- Generic error for network/other issues

### 4. Home Screen (Authenticated)
**Screen**: `lib/screens/home/home_screen.dart`

Displays comprehensive user information:
- **User Avatar**: First letter of user's name in a circle
- **User Name**: Full name from profile
- **Email Address**: User's email (with ellipsis overflow handling)
- **Role Badge**: Color-coded display of user role (Admin/Guard)
  - Admin: Red/Primary color background
  - Guard: Blue background

Additional features:
- **Quick Statistics**: 
  - Number of visitors currently inside
  - Today's visit count
- **Quick Actions**:
  - Add Visitor button
  - View All Visitors button
- **Logout Button**: In app bar for session termination

### 5. Logout Flow
When user taps the Logout button:
1. `AuthService.logout()` calls `FirebaseAuth.signOut()`
2. Auth state changes
3. `AuthWrapper` redirects user back to `LoginScreen`

## Project Structure

```
lib/
├── main.dart                          # App entry point with AuthWrapper
├── firebase_options.dart              # Firebase configuration for all platforms
├── models/
│   ├── user.dart                      # AppUser model
│   └── visitor.dart                   # Visitor model
├── services/
│   ├── auth_service.dart              # Authentication logic
│   ├── user_service.dart              # Firestore user operations
│   └── visitor_service.dart           # Visitor operations
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart          # Login UI and logic
│   │   ├── signup_screen.dart         # Signup UI and logic
│   │   └── index.dart                 # Exports
│   └── home/
│       ├── home_screen.dart           # Authenticated home screen
│       ├── add_visitor_screen.dart    # Visitor management
│       ├── visitors_list_screen.dart  # View all visitors
│       ├── visitor_detail_screen.dart # Visitor details
│       └── index.dart                 # Exports
└── utils/
    ├── constants.dart                 # App constants & validation patterns
    ├── theme.dart                     # App theme & colors
    ├── validators.dart                # Form field validators
    └── index.dart                     # Exports
```

## Database Structure

### Firestore Collections

#### `users` Collection
```json
{
  "id": "uid",
  "email": "user@example.com",
  "name": "John Doe",
  "role": "admin" | "guard",
  "createdAt": "2024-02-24T10:00:00.000Z"
}
```

#### `visitors` Collection
```json
{
  "id": "visitorId",
  "name": "Visitor Name",
  "email": "visitor@example.com",
  "phone": "+1234567890",
  "status": "inside" | "exited",
  "entryTime": "2024-02-24T10:00:00.000Z",
  "exitTime": "2024-02-24T11:00:00.000Z"
}
```

## Key Classes

### AuthService
**File**: `lib/services/auth_service.dart`

Methods:
- `signUp()`: Create new account with email, password, name, and role
- `login()`: Authenticate with email and password
- `logout()`: Sign out current user
- `resetPassword()`: Send password reset email
- `authStateChanges`: Stream to listen to authentication changes
- `currentUser`: Get currently authenticated user

### UserService
**File**: `lib/services/user_service.dart`

Methods:
- `createUser()`: Create user document in Firestore with profile data
- `getUser()`: Retrieve user profile by UID
- `updateUser()`: Update user profile information
- `getAllUsers()`: Fetch all users from database

### AppUser Model
**File**: `lib/models/user.dart`

Properties:
- `id`: Firebase UID
- `email`: User's email address
- `name`: User's full name
- `role`: "admin" or "guard"
- `createdAt`: Account creation timestamp

Features:
- `fromJson()`: Create AppUser from Firestore data
- `toJson()`: Serialize AppUser for database storage
- `copyWith()`: Create modified copy of AppUser

## Validation Rules

### Email
- Pattern: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
- Error: "Please enter a valid email address."

### Password
- Minimum length: 6 characters
- Error: "Password must be at least 6 characters."

### Name
- Minimum length: 2 characters
- Error: "Name must be at least 2 characters."

### Confirm Password
- Must match password field
- Error: "Passwords do not match."

## Testing the Authentication Flow

### Test Signup
1. Launch the app → you'll see LoginScreen
2. Click "Sign Up" link
3. Fill in:
   - Full Name: "John Admin"
   - Email: "john.admin@example.com"
   - Role: Select "Admin"
   - Password: "password123"
   - Confirm Password: "password123"
4. Click "Sign Up" button
5. If successful, HomeScreen displays with user info
6. Click "Logout" to return to login

### Test Login
1. Once account is created, click "Logout"
2. You're back at LoginScreen
3. Enter email and password
4. Click "Login"
5. HomeScreen displays with authenticated user info

### Test Role Display
1. Create accounts with different roles (Admin and Guard)
2. Login with Admin account → see "ADMIN" badge
3. Login with Guard account → see "GUARD" badge

## Security Notes

1. **Passwords**: Never transmitted in plain text (handled by Firebase)
2. **Session**: Automatically managed by Firebase Auth
3. **Tokens**: JWT tokens managed internally by Firebase
4. **Firestore**: Use security rules in Firebase Console for data access control
5. **API Keys**: These are safe to embed in client apps (web/mobile)

## Firebase Console Setup Required

1. Go to Firebase Console (firebase.google.com)
2. Create new project with ID: "flutter-fundamentals-demo"
3. Enable Authentication:
   - Go to Authentication → Sign-in providers
   - Enable "Email/Password"
4. Create Firestore database:
   - Go to Firestore Database
   - Create "users" collection
   - Create "visitors" collection
5. Set appropriate security rules for data access

## Troubleshooting

### "User not found" during Login
- Ensure the email is correct
- Check if account was created in signup

### "Email already in use" during Signup
- Email is already registered
- Use different email or use "Reset Password" for existing account

### User info not displaying on Home Screen
- Ensure Firestore document exists for user
- Check UserService.getUser() is being called in HomeScreen initState

### Navigation issues
- Ensure all routes are defined in main.dart
- Check AuthWrapper is properly listening to auth state changes

## Future Enhancements

Planned features:
- [ ] Email verification
- [ ] Two-factor authentication (2FA)
- [ ] Social login (Google, Facebook)
- [ ] Password strength meter
- [ ] Profile edit screen
- [ ] User image upload
- [ ] Activity logs
- [ ] Session management

---

**Last Updated**: February 24, 2026
**Project**: Smart Visitor Entry Management System
**Framework**: Flutter
**Backend**: Firebase
