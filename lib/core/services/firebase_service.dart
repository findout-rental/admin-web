import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/app_logger.dart';

/// Firebase service for handling FCM tokens and push notifications
class FirebaseService {
  static FirebaseMessaging? _messaging;
  static String? _currentToken;
  static Function(String)? onTokenRefresh;
  static Function(Map<String, dynamic>)? onMessageReceived;

  /// Initialize Firebase
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _messaging = FirebaseMessaging.instance;
      
      // Request notification permission
      final settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      
      AppLogger.info('Firebase notification permission: ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await _setupTokenHandling();
        await _setupMessageHandling();
      } else {
        AppLogger.warning('Notification permission not granted: ${settings.authorizationStatus}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Firebase', error: e, stackTrace: stackTrace);
    }
  }

  /// Setup FCM token handling
  static Future<void> _setupTokenHandling() async {
    try {
      // Get initial token
      _currentToken = await _messaging!.getToken();
      if (_currentToken != null) {
        AppLogger.info('FCM Token obtained: ${_currentToken!.substring(0, 20)}...');
      }

      // Listen for token refresh
      _messaging!.onTokenRefresh.listen((newToken) {
        AppLogger.info('FCM Token refreshed: ${newToken.substring(0, 20)}...');
        _currentToken = newToken;
        onTokenRefresh?.call(newToken);
      });
    } catch (e, stackTrace) {
      AppLogger.error('Failed to setup token handling', error: e, stackTrace: stackTrace);
    }
  }

  /// Setup message handling
  static Future<void> _setupMessageHandling() async {
    try {
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        AppLogger.info('Foreground message received: ${message.messageId}');
        final payload = {
          'notification': {
            'title': message.notification?.title,
            'body': message.notification?.body,
          },
          'data': message.data,
        };
        onMessageReceived?.call(payload);
      });

      // Handle background messages (when app is in background)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        AppLogger.info('Background message opened app: ${message.messageId}');
        final payload = {
          'notification': {
            'title': message.notification?.title,
            'body': message.notification?.body,
          },
          'data': message.data,
        };
        onMessageReceived?.call(payload);
      });

      // Check if app was opened from a notification
      final initialMessage = await _messaging!.getInitialMessage();
      if (initialMessage != null) {
        AppLogger.info('App opened from notification: ${initialMessage.messageId}');
        final payload = {
          'notification': {
            'title': initialMessage.notification?.title,
            'body': initialMessage.notification?.body,
          },
          'data': initialMessage.data,
        };
        onMessageReceived?.call(payload);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to setup message handling', error: e, stackTrace: stackTrace);
    }
  }

  /// Get current FCM token
  static String? getCurrentToken() {
    return _currentToken;
  }

  /// Delete FCM token (for logout)
  static Future<void> deleteToken() async {
    try {
      await _messaging?.deleteToken();
      _currentToken = null;
      AppLogger.info('FCM Token deleted');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete FCM token', error: e, stackTrace: stackTrace);
    }
  }

}
