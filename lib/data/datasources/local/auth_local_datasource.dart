import '../../../core/storage/local_storage.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> removeToken();
  Future<void> saveUser(UserModel user);
  UserModel? getUser();
  Future<void> removeUser();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  @override
  Future<void> saveToken(String token) async {
    await LocalStorage.saveToken(token);
  }

  @override
  String? getToken() {
    return LocalStorage.getToken();
  }

  @override
  Future<void> removeToken() async {
    await LocalStorage.removeToken();
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await LocalStorage.saveUser(user.toJson());
  }

  @override
  UserModel? getUser() {
    final userData = LocalStorage.getUser();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<void> removeUser() async {
    await LocalStorage.removeUser();
  }
}

