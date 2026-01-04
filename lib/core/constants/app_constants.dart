class AppConstants {
  // App Info
  static const String appName = 'FindOut Admin';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Supported Languages
  static const String defaultLanguage = 'en';
  static const String arabicLanguage = 'ar';
  
  // Theme
  static const String defaultTheme = 'light';
  static const String darkTheme = 'dark';
  
  // Minimum Screen Width
  static const double minScreenWidth = 1024.0;
}

