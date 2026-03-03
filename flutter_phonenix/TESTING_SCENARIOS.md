# Implementation Checklist & Test Scenarios

## ✅ Implementation Status

### Firebase Configuration
- [x] Firebase credentials updated in `lib/firebase_options.dart`
- [x] Project ID: `flutter-fundamentals-demo`
- [x] All platform configurations (Web, Android, iOS, macOS, Windows, Linux)
- [x] API Key and App IDs configured
- [x] Storage bucket and authentication domain set

### Authentication System
- [x] `AuthService` with signup, login, logout, password reset
- [x] `UserService` for user profile management
- [x] `AppUser` model with serialization/deserialization
- [x] Form validators for email, password, name, confirmation

### UI/Screens
- [x] **LoginScreen**: Email and password login
- [x] **SignupScreen**: Full name, email, role selection, password, confirm password
- [x] **HomeScreen**: User profile display with name, email, and role badge
- [x] **AuthWrapper**: Automatic routing based on authentication state

### Theme & Styling
- [x] Consistent color scheme (Blue primary, Gray secondary)
- [x] Proper typography and spacing
- [x] Loading indicators for async operations
- [x] Error handling with SnackBar messages

### Data Persistence
- [x] Firestore integration for user profiles
- [x] Cloud Functions support enabled
- [x] Storage bucket configured

---

## 🧪 Test Scenarios

### Scenario 1: First Time User - Complete Signup Flow

**Objective**: Test complete signup process with validation

**Steps**:
1. Launch the app
2. Click "Sign Up" link on LoginScreen
3. Test form validations:
   - Leave "Full Name" empty → Should show error "This field cannot be empty."
   - Enter name with 1 character → Should show error "Name must be at least 2 characters."
   - Enter invalid email (e.g., "notanemail") → Should show error "Please enter a valid email address."
   - Enter password with 4 characters → Should show error "Password must be at least 6 characters."
   - Enter password but different confirm password → Should show error "Passwords do not match."
4. Fill form correctly:
   - Full Name: `Aman Kumar`
   - Email: `aman.kumar@example.com`
   - Role: `Admin` (from dropdown)
   - Password: `SecurePass123`
   - Confirm Password: `SecurePass123`
5. Click "Sign Up"
6. Wait for submission
7. Should see HomeScreen with:
   - User avatar showing "A"
   - Name: "Aman Kumar"
   - Email: "aman.kumar@example.com"
   - Role: "ADMIN" in colored badge
   - Logout button in app bar

**Expected Result**: ✅ User account created, user data displayed on HomeScreen

---

### Scenario 2: Duplicate Email Registration

**Objective**: Test error handling for existing email

**Steps**:
1. On SignupScreen, use email from Scenario 1: `aman.kumar@example.com`
2. Fill other fields with different valid data
3. Click "Sign Up"

**Expected Result**: ❌ Firebase error "The email address is already in use by another account." should display as SnackBar

---

### Scenario 3: Create Guard User

**Objective**: Test different role assignment

**Steps**:
1. Click "Already have an account? Login" link on SignupScreen
2. Click "Sign Up" again to create new account
3. Fill form with:
   - Full Name: `Robert Security`
   - Email: `robert.security@example.com`
   - Role: `Guard`
   - Password: `GuardPass456`
   - Confirm Password: `GuardPass456`
4. Click "Sign Up"
5. HomeScreen should show:
   - Avatar: "R"
   - Name: "Robert Security"
   - Email: "robert.security@example.com"
   - Role: "GUARD" in blue badge

**Expected Result**: ✅ Guard account created with correct role display

---

### Scenario 4: Login with Valid Credentials

**Objective**: Test authentication persistence

**Steps**:
1. On HomeScreen (from Scenario 1), click "Logout"
2. Confirm you're back at LoginScreen
3. Enter:
   - Email: `aman.kumar@example.com`
   - Password: `SecurePass123`
4. Click "Login"

**Expected Result**: ✅ Successfully logged in, HomeScreen displays with previous user data

---

### Scenario 5: Login with Invalid Credentials

**Objective**: Test error handling for wrong password

**Steps**:
1. On LoginScreen, enter:
   - Email: `aman.kumar@example.com`
   - Password: `WrongPassword123`
2. Click "Login"

**Expected Result**: ❌ Firebase error "The password is invalid or the user does not have a password." should display

---

### Scenario 6: Empty Form Submission

**Objective**: Test required field validation

**Steps**:
1. On LoginScreen, click "Login" without filling any fields
2. On SignupScreen, click "Sign Up" without filling any fields

**Expected Result**: ❌ Form validation errors shown for empty fields: "This field cannot be empty."

---

### Scenario 7: Session Persistence

**Objective**: Test that user stays logged in after app restart (if on same session)

**Steps**:
1. Login with valid credentials (Scenario 4)
2. HomeScreen displays user info
3. Close the app (in debug, hot reload should preserve state)
4. Reopen app
5. Observe navigation

**Expected Result**: ✅ AuthWrapper should check auth state and:
- If session is still valid → Show HomeScreen
- If session has ended → Show LoginScreen

---

### Scenario 8: Password Visibility Toggle

**Objective**: Test password field visibility toggle

**Steps**:
1. On LoginScreen or SignupScreen, click eye icon next to password field
2. Password text should become visible
3. Click eye icon again
4. Password text should be hidden again

**Expected Result**: ✅ Password visibility toggles correctly

---

### Scenario 9: Navigation Between Auth Screens

**Objective**: Test navigation flow between signup and login

**Steps**:
1. Start on LoginScreen
2. Click "Don't have an account? Sign Up" → Should go to SignupScreen
3. Click back arrow → Should go back to LoginScreen
4. On LoginScreen, click "Sign Up" link → Should go to SignupScreen
5. Click "Already have an account? Login" → Should go to LoginScreen

**Expected Result**: ✅ All navigation flows work correctly

---

### Scenario 10: Email Format Validation

**Objective**: Test email validation patterns

**Steps**:
On LoginScreen or SignupScreen, test various email formats:
1. Valid: `user@example.com` ✅
2. Valid: `user.name@company.co.uk` ✅
3. Invalid: `userexample.com` (no @) ❌ "Please enter a valid email address."
4. Invalid: `user@example` (no TLD) ❌ "Please enter a valid email address."
5. Invalid: `user @example.com` (space) ❌ "Please enter a valid email address."

**Expected Result**: ✅ All invalid formats rejected, valid formats accepted

---

## 🔍 Data Verification

### Firestore Structure to Verify

After creating users in Scenarios 1 and 3, check Firebase Console:

1. Go to **Firestore Database**
2. Check **users** collection
3. You should see documents with IDs matching Firebase UIDs:

**Document 1 (from Scenario 1)**:
```json
{
  id: "firebase_uid_1",
  email: "aman.kumar@example.com",
  name: "Aman Kumar",
  role: "admin",
  createdAt: "2024-02-24T10:30:00.000Z"
}
```

**Document 2 (from Scenario 3)**:
```json
{
  id: "firebase_uid_2",
  email: "robert.security@example.com",
  name: "Robert Security",
  role: "guard",
  createdAt: "2024-02-24T10:35:00.000Z"
}
```

---

## 📱 Platform-Specific Testing

### Web Testing
1. Run: `flutter run -d chrome`
2. Test all scenarios on web
3. Test responsive design

### Android Testing (if available)
1. Run: `flutter run -d android`
2. Verify all features work
3. Test device-specific paths

### iOS Testing (if available)
1. Run: `flutter run -d ios`
2. Verify all features work
3. Check iOS-specific UI adjustments

---

## 🚀 Before Going to Production

- [ ] Enable Firebase Authentication Email/Password provider
- [ ] Set up Firestore Security Rules
- [ ] Create backup/recovery procedures
- [ ] Set up error logging and monitoring
- [ ] Test on actual devices (not just emulator)
- [ ] Update legal documents (Privacy Policy, Terms of Service)
- [ ] Implement rate limiting for auth endpoints
- [ ] Set up automated backups
- [ ] Create user support documentation
- [ ] Test with various network conditions
- [ ] Implement analytics tracking
- [ ] Test with mixed character passwords (special chars, numbers, unicode)

---

## 🐛 Debugging Tips

### Check Auth State
In Android Studio console, add debug print:
```dart
_authService.authStateChanges.listen((user) {
  print('Auth state changed: ${user?.email}');
});
```

### Verify Firestore Writes
Add Firestore listener:
```dart
FirebaseFirestore.instance
    .collection('users')
    .snapshots()
    .listen((snapshot) {
  print('Users in DB: ${snapshot.docs.length}');
});
```

### Firebase Console Checks
1. **Authentication**: View all registered users
2. **Firestore**: Check user documents structure
3. **Storage**: Verify storage permissions
4. **Cloud Functions**: Check function logs
5. **Realtime Database**: Check if being used

### Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| User data not showing on HomeScreen | Check Firestore user document exists; UID matches |
| Login fails with valid credentials | Check email is verified in Firebase Console |
| Navigation loops | Verify AuthWrapper is checking auth state correctly |
| Firestore permission denied | Check Firestore Security Rules in console |
| Network timeout | Check internet connection and Firebase service status |

---

## 📊 Performance Notes

- **First load**: May take 2-3 seconds for Firebase initialization
- **Signup**: ~2-3 seconds (Firebase + Firestore write)
- **Login**: ~1 second (Firebase auth only)
- **HomeScreen**: ~1 second (Firestore read for user data)
- **Logout**: ~1 second (Firebase signout + navigation)

---

**Test Date**: February 24, 2026
**System**: Smart Visitor Entry Management System
**Status**: Ready for Testing
