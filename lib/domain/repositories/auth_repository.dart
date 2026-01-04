import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String mobileNumber, String password);
  Future<void> logout();
  Future<User> getCurrentUser();
  bool isAuthenticated();
  String? getToken();
}

