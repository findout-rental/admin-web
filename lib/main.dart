import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';
import 'core/utils/app_logger.dart';
import 'core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Error handling for Flutter web
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    AppLogger.error(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // Platform error handling
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error(
      'Platform Error',
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  try {
    // Initialize GetStorage
    await GetStorage.init();
    AppLogger.info('GetStorage initialized successfully');
    
    // Initialize Firebase
    try {
      await FirebaseService.initialize();
      AppLogger.info('Firebase initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.warning('Firebase initialization failed (notifications may not work)', error: e, stackTrace: stackTrace);
      // Continue without Firebase - app can still work with polling
    }
    
    runApp(const App());
  } catch (e, stackTrace) {
    AppLogger.fatal(
      'Failed to initialize app',
      error: e,
      stackTrace: stackTrace,
    );
    // Show error UI if initialization fails
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize application',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
