import 'package:logger/logger.dart';

/// Centralized logging utility for the application
/// 
/// Usage:
/// ```dart
/// AppLogger.info('User logged in');
/// AppLogger.error('Failed to load data', error: e);
/// AppLogger.debug('API response', data: response);
/// ```
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true, // Should each log print contain a timestamp
    ),
    level: _getLogLevel(),
  );

  /// Get log level based on environment
  /// In production, only show warnings and errors
  static Level _getLogLevel() {
    // You can check for debug mode or environment variable
    // For now, we'll use Level.debug in development
    // In production builds, Flutter automatically removes debug code
    // but you can also check: kDebugMode from foundation
    return Level.debug;
  }

  /// Log debug messages (development only)
  static void debug(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.d(
      message,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
    if (data != null) {
      _logger.d('Data: $data');
    }
  }

  /// Log informational messages
  static void info(
    String message, {
    Map<String, dynamic>? data,
  }) {
    _logger.i(
      message,
      time: DateTime.now(),
    );
    if (data != null) {
      _logger.i('Data: $data');
    }
  }

  /// Log warning messages
  static void warning(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.w(
      message,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
    if (data != null) {
      _logger.w('Data: $data');
    }
  }

  /// Log error messages
  static void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
    if (data != null) {
      _logger.e('Data: $data');
    }
  }

  /// Log fatal errors
  static void fatal(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.f(
      message,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
    if (data != null) {
      _logger.f('Data: $data');
    }
  }

  /// Set log level dynamically (useful for production)
  static void setLevel(Level level) {
    // Note: This won't work with the current static logger
    // For production, you might want to create a new logger instance
    // or use a different approach
  }
}

