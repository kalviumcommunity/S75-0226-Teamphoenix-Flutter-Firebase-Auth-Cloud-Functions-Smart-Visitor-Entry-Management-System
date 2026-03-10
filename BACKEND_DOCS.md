# Smart Visitor Entry Management System - Backend Documentation

## Cloud Functions

### Overview
The backend uses Firebase Cloud Functions (TypeScript) to handle:
- User management
- Visitor operations
- Statistics and reporting
- Scheduled tasks

### Environment Setup

1. **Install Firebase CLI**
   ```bash
   npm install -g firebase-tools
   ```

2. **Initialize Firebase Project**
   ```bash
   firebase login
   firebase init
   ```

3. **Install Dependencies**
   ```bash
   cd functions
   npm install
   ```

### API Functions

#### 1. onUserCreate (Auth Trigger)
- **Type**: Auth trigger
- **Event**: User creation
- **Action**: Creates user profile document in Firestore
- **Fields**:
  - id, email, name, role (default: 'guard')
  - createdAt, lastLogin, isActive

#### 2. onUserDelete (Auth Trigger)
- **Type**: Auth trigger
- **Event**: User deletion
- **Action**: Deletes user profile document

#### 3. addVisitor (Callable Function)
- **Endpoint**: `addVisitor`
- **Method**: POST (via Callable)
- **Authentication**: Required
- **Parameters**:
  ```
  {
    name: string,
    email: string,
    phone: string,
    purpose: string,
    hostName: string,
    companyName: string,
    documentType: string,
    documentNumber: string
  }
  ```
- **Response**:
  ```
  {
    success: boolean,
    message: string,
    visitorId: string
  }
  ```

#### 4. markVisitorExit (Callable Function)
- **Endpoint**: `markVisitorExit`
- **Method**: POST (via Callable)
- **Authentication**: Required
- **Parameters**:
  ```
  {
    visitorId: string
  }
  ```
- **Response**:
  ```
  {
    success: boolean,
    message: string,
    durationMinutes: number
  }
  ```

#### 5. getActiveVisitors (Callable Function)
- **Endpoint**: `getActiveVisitors`
- **Method**: GET (via Callable)
- **Authentication**: Required
- **Response**:
  ```
  {
    success: boolean,
    count: number,
    visitors: Visitor[]
  }
  ```

#### 6. getStatistics (Callable Function)
- **Endpoint**: `getStatistics`
- **Method**: GET (via Callable)
- **Authentication**: Required
- **Response**:
  ```
  {
    success: boolean,
    statistics: {
      activeVisitors: number,
      todayVisitors: number,
      timestamp: string
    }
  }
  ```

#### 7. generateDailyReport (Scheduled Task)
- **Type**: Pub/Sub Schedule
- **Schedule**: Daily at 11:59 PM UTC
- **Action**: Generates daily visitor statistics report
- **Storage**: Stored in `daily_reports` collection

### Firestore Collections

#### 1. users
```
{
  id: string,
  email: string,
  name: string,
  role: 'admin' | 'guard',
  createdAt: timestamp,
  lastLogin: timestamp,
  isActive: boolean
}
```

#### 2. visitors
```
{
  name: string,
  email: string,
  phone: string,
  purpose: string,
  hostName: string,
  companyName: string,
  documentType: string,
  documentNumber: string,
  entryTime: timestamp,
  exitTime: timestamp | null,
  status: 'inside' | 'exited',
  durationMinutes: number | null,
  createdByUid: string,
  exitByUid: string | null
}
```

#### 3. daily_reports
```
{
  date: date,
  totalVisitors: number,
  exitedCount: number,
  insideCount: number,
  createdAt: timestamp
}
```

### Firestore Security Rules
- Authenticated users can read and create/update visitors
- Only admin users can delete visitor records
- Users can only read/write their own user document
- Cloud Functions have full access via service account

### Deployment

**Build TypeScript**
```bash
cd functions
npm run build
```

**Deploy Functions**
```bash
firebase deploy --only functions
```

**Test Locally**
```bash
firebase emulator:start
```

### Error Handling
All functions include proper error handling with:
- Authentication validation
- Data validation
- Firestore transaction safety
- Detailed error logging

### Security Features
- Firebase Authentication required
- Firestore Security Rules enforce authorization
- Input validation on all functions
- Role-based access control (admin/guard)
- Comprehensive audit trails via UID tracking
