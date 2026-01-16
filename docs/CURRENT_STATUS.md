# Admin Web Panel - Current Status Report

## Project Context

**IMPORTANT**: This admin web panel is located in the `findout` folder alongside the backend project. The folder structure is:
```
findout/
├── backend/          # Backend API server
└── admin_web/        # This Flutter web admin panel
```

Both projects should be run simultaneously for testing. The backend provides the API endpoints, and this admin web panel consumes them.

---

## Overall Status Summary

### ✅ What's Working

1. **Authentication**
   - Login page with mobile number and password
   - Language switching (English/Arabic) on login page
   - Theme switching (Light/Dark) on login page
   - Forgot password flow (UI implemented)
   - Logout functionality
   - **Note**: Phone number format issue exists (see Issues section)

2. **UI/UX**
   - Modern, responsive card-based layouts
   - Dark and light theme support
   - RTL/LTR layout switching for Arabic/English
   - Professional design with proper spacing and shadows
   - All pages are localized (English/Arabic)

3. **Navigation & Layout**
   - Sidebar navigation with all menu items
   - Top app bar with profile, notifications, language, and theme toggles
   - Breadcrumb navigation
   - Proper routing between pages

4. **Dashboard**
   - Statistics cards showing totals
   - Quick action buttons
   - Last updated timestamp
   - **Status**: UI complete, data fetching needs verification

5. **Settings Pages**
   - Profile settings page (photo upload, personal info)
   - Language settings page
   - Theme settings page
   - All localized and themed

6. **Legal Pages**
   - Privacy Policy page
   - Terms of Service page
   - Both fully localized

7. **Firebase/FCM Integration**
   - Firebase SDK configured in `web/index.html`
   - `FirebaseService` created for FCM token management
   - Notification controller integrated with Firebase
   - FCM token update endpoint implemented
   - **Status**: Frontend setup complete, needs backend testing

8. **Localization**
   - All UI text translated to Arabic and English
   - Currency changed from EGP to SYP (Syrian Pound)
   - RTL/LTR layout working correctly
   - Language switching functional (with `Get.forceAppUpdate()`)

9. **Error Handling**
   - Empty state messages (no data found)
   - Error snackbars for actual errors
   - Loading states for async operations

---

## ⚠️ What Needs to be Fixed/Tested

### Critical Issues

1. **Phone Number Format Problem**
   - **Issue**: Login only accepts `+963991877688` format, not `0991877688`
   - **Need to check**: Is this a backend validation issue or frontend formatting issue?
   - **Location**: `lib/presentation/pages/auth/login_page.dart` and backend login endpoint
   - **Action**: Test with curl to see what format backend expects

2. **Endpoints Not Working**
   Many endpoints are implemented in the frontend but not properly connected or tested:
   
   - ❌ **View User Details**: Clicking on a user doesn't show details
   - ❌ **Approve User**: Approve button doesn't work
   - ❌ **Reject User**: Reject button doesn't work
   - ❌ **View Booking Details**: Clicking on a booking doesn't show details
   - ❌ **View Apartment Details**: Clicking on an apartment doesn't show details
   - ❌ **Deposit Money**: Deposit functionality not working
   - ❌ **Withdraw Money**: Withdraw functionality not working
   - ❌ **Transaction History**: Not loading properly
   - ❌ **Notification Panel**: Buttons not working
   - ❌ **Profile Photo Upload**: Says success but doesn't display

   **Action Required**: Test ALL endpoints with curl commands to verify backend responses, then fix frontend integration.

3. **Data Loading Issues**
   - Empty states showing even when data might exist
   - Error messages appearing for empty data (should show "no data found" instead)
   - Pagination not working correctly
   - Search and filters not working properly

4. **Notification Service**
   - **Status**: Frontend setup complete
   - **What was done**:
     - Firebase SDK added to `web/index.html`
     - `FirebaseService` created with FCM token management
     - Notification controller integrated
     - `UpdateFCMTokenUsecase` implemented
     - Notification panel UI created
   - **Needs Testing**:
     - Test FCM token registration endpoint
     - Test push notification delivery
     - Test notification panel functionality
     - Verify notification badge count updates

---

## Backend Connection Status

### ✅ Connected Endpoints

1. **Authentication**
   - `POST /api/admin/login` - Login
   - `POST /api/admin/forgot-password` - Forgot password
   - `POST /api/admin/reset-password` - Reset password

2. **Profile**
   - `GET /api/admin/profile` - Get profile
   - `PUT /api/admin/profile` - Update profile
   - `POST /api/admin/profile/photo` - Upload photo

3. **Dashboard**
   - `GET /api/admin/dashboard/statistics` - Dashboard stats

4. **Notifications**
   - `GET /api/admin/notifications` - Get notifications
   - `PUT /api/admin/notifications/{id}/read` - Mark as read
   - `PUT /api/admin/notifications/read-all` - Mark all as read
   - `GET /api/admin/notifications/unread-count` - Get unread count
   - `POST /api/admin/notifications/fcm-token` - Update FCM token

### ⚠️ Partially Connected / Needs Testing

1. **Users**
   - `GET /api/admin/users` - List users (implemented, needs testing)
   - `GET /api/admin/users/{id}` - User details (NOT WORKING)
   - `GET /api/admin/users/{id}/balance` - User balance (implemented, needs testing)
   - `GET /api/admin/users/{id}/transactions` - Transaction history (implemented, needs testing)
   - `POST /api/admin/users/{id}/deposit` - Deposit money (NOT WORKING)
   - `POST /api/admin/users/{id}/withdraw` - Withdraw money (NOT WORKING)

2. **Pending Registrations**
   - `GET /api/admin/pending-registrations` - List pending (implemented, needs testing)
   - `POST /api/admin/pending-registrations/{id}/approve` - Approve (NOT WORKING)
   - `POST /api/admin/pending-registrations/{id}/reject` - Reject (NOT WORKING)

3. **Apartments**
   - `GET /api/admin/apartments` - List apartments (implemented, needs testing)
   - `GET /api/admin/apartments/{id}` - Apartment details (NOT WORKING)
   - Location filters implemented but need testing

4. **Bookings**
   - `GET /api/admin/bookings` - List bookings (implemented, needs testing)
   - `GET /api/admin/bookings/{id}` - Booking details (NOT WORKING)

5. **Locations**
   - `GET /api/admin/governorates` - Get governorates (implemented, needs testing)
   - `GET /api/admin/cities?governorate_id={id}` - Get cities (implemented, needs testing)

---

## Testing Instructions

### Prerequisites

1. **Start Backend Server**
   ```bash
   cd findout/backend
   # Run your backend server (command depends on your backend setup)
   # Example: npm start, python manage.py runserver, etc.
   ```

2. **Start Frontend Server**
   ```bash
   cd findout/admin_web
   flutter run -d chrome
   # Or use your preferred method
   ```

3. **Get Authentication Token**
   - Login through the web interface
   - Copy the authentication token from browser DevTools (Application > Local Storage or Network tab)
   - Use this token in curl commands: `Authorization: Bearer <token>`

### Database Seeding

**CRITICAL**: Before testing, seed the database with test data:

1. **Create 5 Pending Users**
   - Use Syrian phone numbers (format: `0991877688` or `+963991877688`)
   - Use Arabic names
   - Status: pending approval

2. **Create 5 Approved Users**
   - Mix of tenants and owners
   - Use Syrian phone numbers
   - Use Arabic names
   - Status: approved/active

3. **Create 5 Active Apartments**
   - Associated with approved owners
   - Various governorates and cities
   - Different price ranges
   - Status: active

4. **Create 5 Bookings**
   - Associated with approved tenants and apartments
   - Various statuses (pending, approved, active, completed, cancelled)
   - Different date ranges

5. **Create 5 Notifications**
   - Various types
   - Mix of read/unread
   - Different timestamps

**Note**: Use Syrian phone number format that matches what the backend expects. Test both `0991877688` and `+963991877688` formats.

### Testing Endpoints with cURL

#### 1. Test Login Endpoint
```bash
# Test with local format
curl -X POST http://localhost:YOUR_PORT/api/admin/login \
  -H "Content-Type: application/json" \
  -d '{
    "mobile": "0991877688",
    "password": "password123"
  }'

# Test with international format
curl -X POST http://localhost:YOUR_PORT/api/admin/login \
  -H "Content-Type: application/json" \
  -d '{
    "mobile": "+963991877688",
    "password": "password123"
  }'
```

#### 2. Test User Details Endpoint
```bash
curl -X GET http://localhost:YOUR_PORT/api/admin/users/1 \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json"
```

#### 3. Test Approve User Endpoint
```bash
curl -X POST http://localhost:YOUR_PORT/api/admin/pending-registrations/1/approve \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json"
```

#### 4. Test Booking Details Endpoint
```bash
curl -X GET http://localhost:YOUR_PORT/api/admin/bookings/1 \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json"
```

#### 5. Test Apartment Details Endpoint
```bash
curl -X GET http://localhost:YOUR_PORT/api/admin/apartments/1 \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json"
```

#### 6. Test Deposit Money Endpoint
```bash
curl -X POST http://localhost:YOUR_PORT/api/admin/users/1/deposit \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 1000.00,
    "description": "Test deposit"
  }'
```

#### 7. Test Withdraw Money Endpoint
```bash
curl -X POST http://localhost:YOUR_PORT/api/admin/users/1/withdraw \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 500.00,
    "description": "Test withdrawal"
  }'
```

#### 8. Test Transaction History Endpoint
```bash
curl -X GET "http://localhost:YOUR_PORT/api/admin/users/1/transactions?type=all&page=1&per_page=20" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json"
```

#### 9. Test FCM Token Update Endpoint
```bash
curl -X POST http://localhost:YOUR_PORT/api/admin/notifications/fcm-token \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "fcm_token": "test_fcm_token_12345"
  }'
```

#### 10. Test Notification Endpoints
```bash
# Get notifications
curl -X GET http://localhost:YOUR_PORT/api/admin/notifications \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json"

# Mark notification as read
curl -X PUT http://localhost:YOUR_PORT/api/admin/notifications/1/read \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json"

# Get unread count
curl -X GET http://localhost:YOUR_PORT/api/admin/notifications/unread-count \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json"
```

### Testing Checklist

- [ ] Login with `0991877688` format
- [ ] Login with `+963991877688` format
- [ ] View user details (click on user in list)
- [ ] Approve pending registration
- [ ] Reject pending registration
- [ ] View booking details (click on booking)
- [ ] View apartment details (click on apartment)
- [ ] Deposit money to user account
- [ ] Withdraw money from user account
- [ ] View transaction history
- [ ] Upload profile photo
- [ ] Update profile information
- [ ] Change language (EN/AR)
- [ ] Change theme (Light/Dark)
- [ ] View notifications panel
- [ ] Mark notification as read
- [ ] Mark all notifications as read
- [ ] Test FCM token registration
- [ ] Test search functionality
- [ ] Test filters (status, role, location, etc.)
- [ ] Test pagination
- [ ] Test empty states

---

## Frontend Code Locations

### Controllers
- `lib/presentation/controllers/auth/login_controller.dart` - Login logic
- `lib/presentation/controllers/user/all_users_controller.dart` - User management
- `lib/presentation/controllers/registration/pending_registrations_controller.dart` - Pending registrations
- `lib/presentation/controllers/apartment/all_apartments_controller.dart` - Apartment management
- `lib/presentation/controllers/booking/all_bookings_controller.dart` - Booking management
- `lib/presentation/controllers/notification/notification_controller.dart` - Notifications
- `lib/presentation/controllers/settings/profile_controller.dart` - Profile settings
- `lib/presentation/controllers/settings/language_controller.dart` - Language settings
- `lib/presentation/controllers/settings/theme_controller.dart` - Theme settings

### API Endpoints
- `lib/core/constants/api_constants.dart` - All API endpoint definitions
- `lib/data/datasources/remote/` - Remote data sources for each module
- `lib/data/repositories/` - Repository implementations

### Pages
- `lib/presentation/pages/` - All page implementations

---

## Next Steps

1. **Test all endpoints with curl** to verify backend responses
2. **Fix phone number format issue** (check backend vs frontend)
3. **Fix all non-working endpoints** based on curl test results
4. **Seed database** with test data (5 items for each entity)
5. **Test notification service** end-to-end
6. **Fix UI issues** based on endpoint fixes
7. **Test all user flows** end-to-end
8. **Fix any remaining bugs** found during testing

---

## Notes

- All currency displays use SYP (Syrian Pound)
- All user-facing text is localized (English/Arabic)
- Theme switching works throughout the app
- Language switching requires `Get.forceAppUpdate()` to work properly
- Empty states show "no data found" messages instead of errors
- Error handling distinguishes between actual errors and empty data

---

**Last Updated**: [Current Date]
**Status**: In Development - Testing Phase
