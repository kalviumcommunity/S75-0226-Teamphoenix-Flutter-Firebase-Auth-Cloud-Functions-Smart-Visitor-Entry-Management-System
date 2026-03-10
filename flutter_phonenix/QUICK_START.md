# Quick Start Guide - Smart Visitor Entry System

## 🚀 Quick Setup (5 minutes)

### Step 1: Get Dependencies
```bash
cd flutter_phonenix
flutter pub get
```

### Step 2: Configure Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project with ID: **flutter-fundamentals-demo**
3. Go to **Authentication** → **Email/Password** → Enable
4. Go to **Firestore Database** → Create database → Start in test mode
5. Create two collections: **users** and **visitors**

### Step 3: Run Application
```bash
# Web
flutter run -d chrome --web-port=5000

# Android
flutter run -d android

# iOS
flutter run -d ios
```

---

## 📝 Test User Flow (5 minutes)

### Create Your First Account

1. **Click "Sign Up"** on login screen
2. Fill in:
   ```
   Full Name: John Admin
   Email: john@example.com
   Role: Admin
   Password: MyPass123
   Confirm: MyPass123
   ```
3. **Click "Sign Up"**
4. You'll see HomeScreen with:
   - Avatar showing "J"
   - Name: "John Admin"
   - Email: "john@example.com"
   - Role badge: "ADMIN"

### Test Logout & Login

1. **Click "Logout"** button in app bar
2. Back at LoginScreen
3. **Enter credentials**:
   ```
   Email: john@example.com
   Password: MyPass123
   ```
4. **Click "Login"**
5. Should see HomeScreen again with same user info

### Create Guard Account

1. Click "Sign Up"
2. Fill in:
   ```
   Full Name: Robert Guard
   Email: robert@example.com
   Role: Guard
   Password: GuardPass456
   Confirm: GuardPass456
   ```
3. **Click "Sign Up"**
4. Notice role badge shows "GUARD" instead of "ADMIN"

---

## 📱 What's Implemented

### ✅ Authentication System
- User signup with full name, email, password, role selection
- User login with email and password
- Password confirmation on signup
- Form validation with helpful error messages
- Session persistence across app restarts
- Logout functionality

### ✅ User Profile
- Display user name, email, and role on HomeScreen
- User avatar with first letter initial
- Color-coded role badges (Admin = blue, Guard = blue)
- Profile card design with proper spacing

### ✅ Database Integration
- User data stored in Firestore
- User role properly captured (admin/guard)
- Timestamps for account creation
- Real-time sync with Firebase

### ✅ Error Handling
- Invalid email format detection
- Weak password detection
- Password mismatch validation
- Duplicate email prevention
- Helpful error messages as SnackBars
- Loading indicators during operations

---

## 🎨 User Interface

### LoginScreen
```
┌─────────────────────────────────┐
│                                 │
│    Smart Visitor Entry          │
│    Management System            │
│                                 │
│    ┌─────────────────────────┐  │
│    │ Email                   │  │
│    └─────────────────────────┘  │
│                                 │
│    ┌─────────────────────────┐  │
│    │ Password               👁  │
│    └─────────────────────────┘  │
│                                 │
│    ┌─────────────────────────┐  │
│    │       LOGIN             │  │
│    └─────────────────────────┘  │
│                                 │
│    Don't have account? Sign Up  │
│                                 │
└─────────────────────────────────┘
```

### SignupScreen
```
┌─────────────────────────────────┐
│  ◀ Create Account               │
│                                 │
│    ┌─────────────────────────┐  │
│    │ Full Name               │  │
│    └─────────────────────────┘  │
│                                 │
│    ┌─────────────────────────┐  │
│    │ Email                   │  │
│    └─────────────────────────┘  │
│                                 │
│    ┌─────────────────────────┐  │
│    │ Select Role         ▼   │  │
│    │ Admin / Guard           │  │
│    └─────────────────────────┘  │
│                                 │
│    ┌─────────────────────────┐  │
│    │ Password               👁  │
│    └─────────────────────────┘  │
│                                 │
│    ┌─────────────────────────┐  │
│    │ Confirm Password       👁  │
│    └─────────────────────────┘  │
│                                 │
│    ┌─────────────────────────┐  │
│    │      SIGN UP            │  │
│    └─────────────────────────┘  │
│                                 │
│    Already have account? Login  │
│                                 │
└─────────────────────────────────┘
```

### HomeScreen (Authenticated)
```
┌─────────────────────────────────┐
│  Smart Visitor Entry  🚪 Logout │
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────┐    │
│  │ [J] │ John Admin        │    │
│  │     │ john@example.com  │    │
│  │────────────────────────│    │
│  │ 🔒 Role: [ADMIN]       │    │
│  └─────────────────────────┘    │
│                                 │
│  Statistics                     │
│  ┌─────────────────────────┐    │
│  │  5         Today:  0    │    │
│  │  Inside     Visits      │    │
│  └─────────────────────────┘    │
│                                 │
│  Quick Actions                  │
│  ┌──────────────┬──────────────┐│
│  │ ➕ Add       │ 📋 View All  ││
│  │   Visitor    │   Visitors   ││
│  └──────────────┴──────────────┘│
│                                 │
└─────────────────────────────────┘
```

---

## ⚙️ Configuration Details

### Firebase Project: flutter-fundamentals-demo
- **API Key**: AIzaSyA8cJRNJIHkQbV5fi7uORLjVieebRe0ufw
- **Auth Domain**: flutter-fundamentals-demo.firebaseapp.com
- **Project ID**: flutter-fundamentals-demo
- **Storage Bucket**: flutter-fundamentals-demo.firebasestorage.app
- **Messaging Sender ID**: 923655831668
- **App ID**: 1:923655831668:web:41c5fb71223d7421eb9121
- **Measurement ID**: G-XC0K7ECQ4Q

### Firestore Collections
- **users**: Stores user profiles
  - Fields: id, email, name, role, createdAt
- **visitors**: Stores visitor records
  - Fields: id, name, email, phone, status, entryTime, exitTime

---

## 🔍 Troubleshooting

### Issue: "Firebase not initialized"
**Solution**: Make sure `flutter pub get` completed successfully

```bash
flutter pub get
flutter clean
flutter pub get
flutter run
```

### Issue: "Authentication fails"
**Solution**: Verify Email/Password auth is enabled in Firebase Console
1. Go to Firebase Console
2. Authentication → Sign-in providers
3. Email/Password → Enable

### Issue: "User data not showing"
**Solution**: Check Firestore collections exist and user document was created
1. Go to Firebase Console → Firestore
2. Check "users" collection exists
3. Check document matches user's UID (in Firebase Auth)

### Issue: "Can't create test data from Flutter"
**Solution**: Enable Firestore test rules
1. Go to Firestore Database
2. Go to Rules tab
3. Set to: `allow read, write: if true;` (for testing only)
4. Deploy

### Issue: "Password too weak"
**Solution**: Firebase requires minimum 6 characters
- Valid: `MyPass123`, `AbcDef6`, `Pass@123`
- Invalid: `123`, `abcdef`, `pass`

### Issue: "Email already exists"
**Solution**: Use different email or reset password
- Each email can only have one account
- Use password reset if you forgot password

---

## 📚 File Organization

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # ✨ Firebase config (UPDATED)
├── models/
│   ├── user.dart               # User model
│   ├── visitor.dart            # Visitor model
│   └── index.dart
├── services/
│   ├── auth_service.dart       # Authentication methods
│   ├── user_service.dart       # User profile methods
│   ├── visitor_service.dart    # Visitor methods
│   └── index.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart   # Login UI
│   │   ├── signup_screen.dart  # Signup UI
│   │   └── index.dart
│   └── home/
│       ├── home_screen.dart    # ✨ Home (ENHANCED)
│       ├── add_visitor_screen.dart
│       ├── visitors_list_screen.dart
│       └── ...
└── utils/
    ├── theme.dart              # Colors & sizes
    ├── validators.dart         # Form validation
    ├── constants.dart          # App constants
    └── index.dart
```

---

## 🎯 Common Tasks

### To test password validation:
Try passwords: `ab` (too short), `MyPass123` (valid)

### To test email validation:
Try emails: `notanemail` (invalid), `user@test.com` (valid)

### To test role selection:
Choose between Admin and Guard in signup form

### To test persistence:
1. Login successfully
2. Close and reopen app
3. You should still be logged in

### To test logout:
Click "Logout" button → you return to LoginScreen

---

## 🚨 Important Notes

1. **Firebase Console Setup**: You MUST create the Firebase project and enable features before running the app

2. **Firestore Collections**: The app will create them automatically if they don't exist (with test rules)

3. **Password Policy**: Firebase requires minimum 6 characters

4. **Email Verification**: Not currently enabled (can be added later)

5. **Test Mode Warning**: Start with test rules (`allow read, write: if true;`) then implement proper security rules for production

---

## ✅ Checklist Before Testing

- [ ] Flutter SDK installed
- [ ] Firebase project created: flutter-fundamentals-demo
- [ ] Authentication → Email/Password enabled
- [ ] Firestore database created
- [ ] `flutter pub get` completed
- [ ] No compilation errors
- [ ] Chrome/Android device ready
- [ ] Firestore rules configured (test mode OK)

---

## 🎉 You're All Set!

Everything is configured and ready to test. Just run:

```bash
flutter run -d chrome
```

Then:
1. Click "Sign Up"
2. Create account
3. See user info on HomeScreen
4. Click "Logout" and login again
5. Verify everything works!

---

**Created**: February 24, 2026
**System**: Smart Visitor Entry Management System
**Ready?** ✅ Yes! Go test it out!
