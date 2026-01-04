import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final GetStorage _storage = GetStorage();

  // Token operations
  static Future<void> saveToken(String token) async {
    await _storage.write('auth_token', token);
  }

  static String? getToken() {
    return _storage.read<String>('auth_token');
  }

  static Future<void> removeToken() async {
    await _storage.remove('auth_token');
  }

  // User data operations
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write('user_data', user);
  }

  static Map<String, dynamic>? getUser() {
    return _storage.read<Map<String, dynamic>>('user_data');
  }

  static Future<void> removeUser() async {
    await _storage.remove('user_data');
  }

  // Language operations
  static Future<void> saveLanguage(String language) async {
    await _storage.write('language_preference', language);
  }

  static String getLanguage() {
    return _storage.read<String>('language_preference') ?? 'en';
  }

  // Theme operations
  static Future<void> saveTheme(String theme) async {
    await _storage.write('theme_mode', theme);
  }

  static String getTheme() {
    return _storage.read<String>('theme_mode') ?? 'light';
  }

  // Generic operations
  static Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  static T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  static Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  static Future<void> clear() async {
    await _storage.erase();
  }
}

