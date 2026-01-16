# Firebase/FCM Setup Guide for FindOut Admin Web

## Step-by-Step Instructions

### 1. Get Your Firebase Configuration

Since you already have Firebase connected to your backend, you need to get your Firebase Web App configuration:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click the gear icon ⚙️ → **Project Settings**
4. Scroll down to **Your apps** section
5. If you don't have a Web app, click **Add app** → **Web** (</> icon)
6. Register your app (give it a nickname like "FindOut Admin Web")
7. Copy the Firebase configuration object

### 2. Get Your VAPID Key

For Web Push Notifications, you need a VAPID key:

1. In Firebase Console, go to **Project Settings**
2. Click on the **Cloud Messaging** tab
3. Scroll down to **Web configuration**
4. Under **Web Push certificates**, you'll see:
   - **Key pair** (this is your VAPID key)
   - If you don't have one, click **Generate key pair**

### 3. Update `web/index.html`

Open `web/index.html` and replace the placeholder values:

```javascript
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",                    // Replace with your API key
  authDomain: "YOUR_AUTH_DOMAIN",            // Replace with your auth domain
  projectId: "YOUR_PROJECT_ID",              // Replace with your project ID
  storageBucket: "YOUR_STORAGE_BUCKET",      // Replace with your storage bucket
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID", // Replace with your sender ID
  appId: "YOUR_APP_ID",                      // Replace with your app ID
  measurementId: "YOUR_MEASUREMENT_ID"       // Optional - for Analytics
};

// Also replace:
messaging.getToken({ vapidKey: 'YOUR_VAPID_KEY' })  // Replace with your VAPID key
```

### 4. Install Dependencies

Run this command to install the Firebase packages:

```bash
flutter pub get
```

### 5. Test the Setup

1. Run your app: `flutter run -d chrome`
2. When you log in, the app will:
   - Request notification permission from the browser
   - Get an FCM token
   - Automatically register the token with your backend
3. Check the browser console for logs:
   - "FCM Token obtained: ..." - means token was generated
   - "FCM token registered successfully" - means token was sent to backend

### 6. Verify Backend Integration

The FCM token will be automatically sent to your backend via:
- **Endpoint**: `POST /notifications/fcm-token`
- **Body**: `{ "fcm_token": "your-token-here" }`

Make sure your backend is ready to receive and store this token.

### 7. Test Push Notifications

To test if notifications work:

1. Send a test notification from Firebase Console:
   - Go to **Cloud Messaging** → **Send test message**
   - Enter your FCM token
   - Send a test notification

2. Or use your backend API to send notifications (if implemented)

## Troubleshooting

### Notification Permission Denied
- The browser will prompt for permission on first load
- If denied, user needs to manually enable in browser settings
- Chrome: Settings → Privacy and security → Site settings → Notifications

### FCM Token Not Generated
- Check browser console for errors
- Ensure Firebase config is correct
- Ensure VAPID key is correct
- Check that Firebase SDK scripts are loaded in `index.html`

### Token Not Registered with Backend
- Check network tab in browser DevTools
- Verify the API endpoint `/notifications/fcm-token` exists
- Check backend logs for errors
- Ensure user is authenticated (token requires auth)

## Important Notes

- **VAPID Key**: This is required for web push notifications. Make sure you have it.
- **HTTPS Required**: Push notifications only work over HTTPS (or localhost for development)
- **Browser Support**: Not all browsers support push notifications (Chrome, Firefox, Edge support it)
- **Token Refresh**: The app automatically handles token refresh and re-registration

## Next Steps

Once setup is complete:
1. ✅ FCM tokens will be automatically registered on login
2. ✅ Push notifications will be received in real-time
3. ✅ Notifications will appear in the notification panel
4. ✅ Unread count will update automatically
