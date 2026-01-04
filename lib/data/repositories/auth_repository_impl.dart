import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<User> login(String mobileNumber, String password) async {
    try {
      final response = await remoteDatasource.login(mobileNumber, password);
      
      // Extract token and user data from response
      // API response structure: { "success": true, "data": { "token": "...", "user": {...} } }
      final data = response['data'] as Map<String, dynamic>? ?? response;
      final token = data['token'] as String?;
      final userData = data['user'] as Map<String, dynamic>?;
      
      if (userData == null) {
        throw Exception('User data not found in response');
      }
      
      if (token != null) {
        await localDatasource.saveToken(token);
      }
      
      final user = UserModel.fromJson(userData);
      await localDatasource.saveUser(user);
      
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDatasource.logout();
    } catch (e) {
      // Continue with local logout even if remote fails
    } finally {
      await localDatasource.removeToken();
      await localDatasource.removeUser();
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final response = await remoteDatasource.getCurrentUser();
      // API response structure: { "success": true, "data": { "user": {...} } }
      final data = response['data'] as Map<String, dynamic>? ?? response;
      final userData = data['user'] as Map<String, dynamic>?;
      
      if (userData == null) {
        throw Exception('User data not found in response');
      }
      
      final user = UserModel.fromJson(userData);
      await localDatasource.saveUser(user);
      return user;
    } catch (e) {
      // Try to get from local storage as fallback
      final localUser = localDatasource.getUser();
      if (localUser != null) {
        return localUser;
      }
      rethrow;
    }
  }

  @override
  bool isAuthenticated() {
    return localDatasource.getToken() != null;
  }

  @override
  String? getToken() {
    return localDatasource.getToken();
  }
}

