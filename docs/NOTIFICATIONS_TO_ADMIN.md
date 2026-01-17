# Notifications Sent to Admin

This document lists all events that send notifications to admin users in the FindOut system.

## Notification Types Sent to Admin

### 1. **New Message** (`new_message`)
- **Trigger:** When any user (tenant or owner) sends a message to the admin
- **Location:** `backend/app/Services/WebSocketMessageService.php` → `handleSendMessage()`
- **How to test:** Use the `send_notification_to_admin.sh` script or send a message via API/WebSocket

### 2. **New User Registration** (`new_user_registration`) ✅ NEW
- **Trigger:** When a new user (tenant or owner) registers
- **Location:** `backend/app/Http/Controllers/AuthController.php` → `register()`
- **Notification:** Sent to ALL approved admin users
- **Message:** "{User Name} ({Role}) has registered and is pending approval."
- **How to test:** Register a new user via the app, or use `test_new_user_registration.sh`

### 3. **New Apartment** (`new_apartment`) ✅ NEW
- **Trigger:** When an owner publishes a new apartment
- **Location:** `backend/app/Http/Controllers/Owner/ApartmentController.php` → `store()`
- **Notification:** Sent to ALL approved admin users
- **Message:** "A new apartment at {address} has been published by {owner name}."
- **How to test:** Create a new apartment via the app, or use `test_new_apartment.sh`

### 4. **New Booking** (`new_booking`) ✅ NEW
- **Trigger:** When a tenant creates a new booking request
- **Location:** `backend/app/Http/Controllers/Tenant/BookingController.php` → `store()`
- **Notification:** Sent to ALL approved admin users
- **Message:** "{Tenant Name} has submitted a new booking request for {apartment address}."
- **How to test:** Create a new booking via the app, or use `test_new_booking.sh`

### 5. **System Update** (`system_update`)
- **Trigger:** Manual/administrative notifications (can be created via tinker or scripts)
- **Location:** Created manually or via `NotificationService::create()`

## Events That Do NOT Send Notifications to Admin

### ❌ New User Registration
- **Status:** NO automatic notification sent to admin
- **How Admin Knows:** Admin must check the "Pending Registrations" page manually
- **Location:** `backend/app/Http/Controllers/AuthController.php` → `register()`
- **Note:** This could be a future enhancement - currently admin discovers new registrations by checking the dashboard or pending registrations page

### ✅ Admin Actions (Admin sends notifications TO users)
- **Account Approved** (`account_approved`) - Admin approves user → User gets notification
- **Account Rejected** (`account_rejected`) - Admin rejects user → User gets notification
- **Location:** `backend/app/Http/Controllers/Admin/UserController.php`

## Other Notification Types (Not for Admin)

These are sent between tenants and owners, not to admin:

1. **Booking Request Received** (`booking_request_received`) - Tenant → Owner
2. **Booking Approved** (`booking_approved`) - Owner → Tenant
3. **Booking Rejected** (`booking_rejected`) - Owner → Tenant
4. **Booking Cancelled** (`booking_cancelled`) - Tenant → Owner
5. **Booking Modified** (`booking_modified`) - Tenant → Owner
6. **Modification Approved** (`modification_approved`) - Owner → Tenant
7. **Modification Rejected** (`modification_rejected`) - Owner → Tenant
8. **New Review** (`new_review`) - Tenant → Owner

## Testing Notifications

### Send a Message Notification to Admin
```bash
cd /home/ace/Desktop/findout/backend
./send_notification_to_admin.sh "Your test message here"
```

### Create a System Update Notification (via tinker)
```bash
php artisan tinker
$admin = App\Models\User::where('role', 'admin')->first();
$notification = App\Models\Notification::create([
    'user_id' => $admin->id,
    'type' => 'system_update',
    'title' => 'System Update',
    'title_ar' => 'تحديث النظام',
    'message' => 'This is a system update notification',
    'message_ar' => 'هذا إشعار تحديث النظام',
    'is_read' => false,
]);
```

## Summary

**Currently, only messages sent directly to the admin trigger notifications.**

To get more notifications to admin, you would need to:
1. Add notification creation in `AuthController::register()` to notify all admins when a new user registers
2. Add other event listeners for admin notifications
