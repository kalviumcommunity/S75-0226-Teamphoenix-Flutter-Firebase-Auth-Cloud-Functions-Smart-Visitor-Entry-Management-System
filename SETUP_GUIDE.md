# Smart Visitor Entry Management System

A complete Firebase-based application for managing visitor entry and exit in organizations. Built with Flutter (frontend) and Firebase Cloud Functions (backend).

## 📱 Project Structure

```
flutter_phonenix/
├── lib/
│   ├── main.dart                    # App entry point with Firebase initialization
│   ├── firebase_options.dart        # Firebase configuration (auto-generated)
│   ├── models/                      # Data models
│   │   ├── user.dart
│   │   ├── visitor.dart
│   │   └── index.dart
│   ├── screens/                     # UI screens
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   └── index.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   ├── add_visitor_screen.dart
│   │   │   ├── visitors_list_screen.dart
│   │   │   ├── visitor_detail_screen.dart
│   │   │   └── index.dart
│   │   └── index.dart
│   ├── services/                    # Firebase services
│   │   ├── auth_service.dart
│   │   ├── user_service.dart
│   │   ├── visitor_service.dart
│   │   └── index.dart
│   ├── utils/                       # Utilities & constants
│   │   ├── constants.dart
│   │   ├── theme.dart
│   │   ├── validators.dart
│   │   └── index.dart
│   └── widgets/                     # Reusable widgets
│
├── pubspec.yaml                     # Flutter dependencies
├── analysis_options.yaml            # Lint rules
│
functions/
├── src/
│   └── index.ts                     # Cloud Functions implementation
├── package.json                     # Node.js dependencies
├── tsconfig.json                    # TypeScript configuration
└── serviceAccountKey.json           # Firebase credentials (template)

firebase.json                        # Firebase emulator configuration
firestore.rules                      # Firestore security rules
firestore.indexes.json               # Firestore composite indexes
.firebaserc                          # Firebase project config
README.md                            # This file
BACKEND_DOCS.md                      # Backend API documentation
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.11.0 or higher)
- Node.js 18+
- Firebase CLI
- Android Studio / Xcode (for mobile development)
- Git

### Frontend Setup

1. **Navigate to flutter project**
   ```bash
   cd flutter_phonenix
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Run FlutterFire CLI to configure:
     ```bash
     flutter pub global activate flutterfire_cli
     flutterfire configure
     ```
   - This will update `lib/firebase_options.dart` with your project credentials

4. **Run the app**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d chrome           # Web
   flutter run -d emulator-5554    # Android
   flutter run -d iPhone           # iOS
   ```

### Backend Setup

1. **Navigate to functions directory**
   ```bash
   cd functions
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Build TypeScript**
   ```bash
   npm run build
   ```

4. **Set up Firebase credentials**
   - Download service account key from Firebase Console
   - Copy to `serviceAccountKey.json`
   - Update `.firebaserc` with your project ID

5. **Test locally with emulator**
   ```bash
   firebase emulator:start
   ```

6. **Deploy to Firebase**
   ```bash
   firebase deploy
   ```

## 🔐 Authentication

### User Roles
- **Guard**: Can view visitor list, add visitors, mark exits
- **Admin**: Can perform all guard actions + delete records

### Login/Signup
- Email/Password authentication via Firebase Auth
- Automatic user profile creation in Firestore
- Soft token management via Firebase SDK

## 📊 Features

### Frontend
- ✅ User Authentication (Login/Signup)
- ✅ Visitor Management Dashboard
- ✅ Add New Visitor Form
- ✅ View All Visitors
- ✅ Mark Visitor Exit
- ✅ Visitor Details View
- ✅ Statistics & Reports
- ✅ Real-time Updates (Firestore Streams)
- ✅ Form Validation
- ✅ Error Handling

### Backend
- ✅ User Management API
- ✅ Visitor CRUD Operations
- ✅ Active Visitors Query
- ✅ Statistics API
- ✅ Daily Report Generation (Scheduled)
- ✅ Firestore Security Rules
- ✅ Authentication Triggers
- ✅ Audit Trail (via UIDs)

## 🗄️ Database Schema

### Firestore Collections

#### `users`
```dart
User {
  id: String,                    // Firebase UID
  email: String,                 // User email
  name: String,                  // Full name
  role: 'admin' | 'guard',      // User role
  createdAt: DateTime,           // Account creation time
  lastLogin: DateTime,           // Last login timestamp
  isActive: boolean              // Account status
}
```

#### `visitors`
```dart
Visitor {
  id: String,                    // Document ID
  name: String,                  // Visitor name
  email: String,                 // Visitor email
  phone: String,                 // Phone number
  purpose: String,               // Purpose of visit
  hostName: String,              // Host/employee name
  companyName: String,           // Visitor's company
  documentType: String,          // 'passport', 'id_card', 'driving_license', 'visa'
  documentNumber: String,        // Document ID number
  entryTime: DateTime,           // Entry timestamp
  exitTime: DateTime?,           // Exit timestamp (nullable)
  status: 'inside' | 'exited',  // Current status
  durationMinutes: int?,         // Stay duration
  createdByUid: String,          // UID of staff member
  exitByUid: String?             // UID of exit recorder
}
```

#### `daily_reports`
```
Report {
  date: Date,                    // Report date
  totalVisitors: int,            // Total visitors
  exitedCount: int,              // Visitors who exited
  insideCount: int,              // Visitors still inside
  createdAt: DateTime            // Report timestamp
}
```

## 🔗 API Endpoints (Cloud Functions)

See [BACKEND_DOCS.md](BACKEND_DOCS.md) for detailed API documentation.

### Key Functions
- `addVisitor` - Add new visitor entry
- `markVisitorExit` - Record visitor exit
- `getActiveVisitors` - Get all active visitors
- `getStatistics` - Get visitor statistics
- `generateDailyReport` - Scheduled daily reports

## 🛡️ Security

### Firestore Rules
- Authenticated users can read/write visitor records
- Only admins can delete records
- Users can only access their own profile
- Cloud Functions have full access via service account

### Best Practices
- All functions require authentication
- Input validation on all API endpoints
- Audit trails via UID tracking
- Role-based access control
- Secure password handling via Firebase Auth

## 📋 Testing

### Manual Testing Steps
1. **Sign Up** → Create a new account
2. **Login** → Authenticate with credentials
3. **Add Visitor** → Fill form with test visitor data
4. **View List** → See all visitors in list
5. **View Details** → Click visitor to see details
6. **Mark Exit** → Record visitor exit
7. **Logout** → Sign out from app

### Testing with Firebase Emulator
```bash
# Terminal 1: Start emulator
firebase emulator:start

# Terminal 2: Run Flutter (configure to use emulator)
flutter run
```

## 📦 Dependencies

### Frontend (Flutter)
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `cloud_firestore`: Database operations
- `cloud_functions`: Callable functions
- `provider`: State management
- `get`: Navigation & state
- `intl`: Date/time formatting
- `http`: HTTP requests
- `equatable`: Equality comparison

### Backend (Node.js)
- `firebase-admin`: Firebase Admin SDK
- `firebase-functions`: Cloud Functions SDK
- `cors`: CORS handling
- `typescript`: TypeScript compiler
- `@types/node`: Node.js types

## 🐛 Troubleshooting

### Common Issues

**Issue**: "Cannot connect to Firebase"
- Solution: Verify internet connection and Firebase credentials in `firebase_options.dart`

**Issue**: "Firestore permission denied"
- Solution: Check Firestore security rules and ensure you're signed in

**Issue**: "Cloud Functions not deploying"
- Solution: Run `npm run build` first, verify service account permissions

**Issue**: "Flutter pubspec dependencies not installing"
- Solution: Run `flutter clean` then `flutter pub get`

## 📈 Future Enhancements

- [ ] QR code scanning for visitor IDs
- [ ] Photo capture at entry/exit
- [ ] Email notifications for visitor arrivals
- [ ] SMS alerts for long-stay visitors
- [ ] Advanced reporting & analytics
- [ ] Integration with building access systems
- [ ] Multi-location support
- [ ] Mobile app push notifications

## 📄 License

This project is proprietary and confidential.

## 👥 Support

For issues or questions, please contact the development team.

---

**Version**: 1.0.0  
**Last Updated**: February 2026  
**Team**: Phoenix Development
