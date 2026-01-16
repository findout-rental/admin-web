class ApiConstants {
  // Base URL - Update based on environment
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  
  // Profile endpoints
  static const String profile = '/profile';
  static const String updateProfile = '/profile';
  static const String uploadPhoto = '/profile/upload-photo';
  static const String updateLanguage = '/profile/language';
  
  // Admin endpoints
  static const String dashboardStats = '/admin/dashboard/statistics';
  static const String pendingRegistrations = '/admin/registrations/pending';
  static const String registrationDetail = '/admin/registrations';
  static const String approveRegistration = '/admin/registrations';
  static const String rejectRegistration = '/admin/registrations';
  static const String allUsers = '/admin/users';
  static const String userDetail = '/admin/users';
  static const String deleteUser = '/admin/users';
  static const String userDeposit = '/admin/users';
  static const String userWithdraw = '/admin/users';
  static const String userBalance = '/admin/users';
  static const String userTransactions = '/admin/users';
  static const String allApartments = '/admin/apartments';
  static const String allBookings = '/admin/bookings';
  
  // Location endpoints
  static const String governorates = '/locations/governorates';
  static const String cities = '/locations/cities';
  
  // Notifications
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications';
  static const String markAllRead = '/notifications/read-all';
  static const String updateFCMToken = '/notifications/fcm-token';
}

